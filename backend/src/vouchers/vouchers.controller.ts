import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards, BadRequestException } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { VouchersService } from './vouchers.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards';
import { Roles, CurrentUser } from '../common/decorators';
import { Role } from '@prisma/client';

@ApiTags('Seller - Vouchers')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.SELLER)
@Controller('seller/vouchers')
export class VouchersController {
  constructor(private vouchersService: VouchersService) {}

  @Post()
  create(@CurrentUser() user: any, @Body() data: any) {
    return this.vouchersService.create(user.shopId, data);
  }

  @Get()
  findMyVouchers(@CurrentUser() user: any) {
    return this.vouchersService.findByShop(user.shopId);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() data: any) {
    return this.vouchersService.update(id, data);
  }

  @Delete(':id')
  delete(@Param('id') id: string) {
    return this.vouchersService.delete(id);
  }
}

// ─── Customer-facing voucher validation ───
@ApiTags('Customer - Vouchers')
@Controller('vouchers')
export class CustomerVouchersController {
  constructor(private vouchersService: VouchersService) {}

  @Post('validate')
  async validate(@Body('code') code: string) {
    if (!code) {
      throw new BadRequestException('Vui lòng nhập mã giảm giá');
    }
    const voucher = await this.vouchersService.validateVoucher(code.toUpperCase());
    if (!voucher) {
      throw new BadRequestException('Mã không hợp lệ hoặc đã hết hạn');
    }
    return {
      id: voucher.id,
      code: voucher.code,
      discount: Number(voucher.discount),
      minOrder: Number(voucher.minOrder),
      expiresAt: voucher.expiresAt,
    };
  }
}
