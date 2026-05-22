import { Controller, Get, Post, Patch, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { ShopsService } from './shops.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards';
import { Roles, CurrentUser } from '../common/decorators';
import { Role } from '@prisma/client';

@ApiTags('Seller - Shop')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.SELLER)
@Controller('seller')
export class ShopsController {
  constructor(private shopsService: ShopsService) {}

  @Post('shop')
  createShop(@CurrentUser('id') userId: string, @Body() data: any) {
    return this.shopsService.create(userId, data);
  }

  @Get('shop')
  getMyShop(@CurrentUser('id') userId: string) {
    return this.shopsService.findBySeller(userId);
  }

  @Patch('shop')
  updateShop(@CurrentUser('id') userId: string, @Body() data: any) {
    return this.shopsService.update(userId, data);
  }

  @Get('stats')
  getStats(@CurrentUser('id') userId: string) {
    return this.shopsService.getStats(userId);
  }
}
