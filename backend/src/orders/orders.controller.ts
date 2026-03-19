import { Controller, Get, Post, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { OrdersService } from './orders.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards';
import { Roles, CurrentUser } from '../common/decorators';
import { Role, OrderStatus } from '@prisma/client';

@ApiTags('Orders')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller()
export class OrdersController {
  constructor(private ordersService: OrdersService) {}

  // Customer
  @Post('orders')
  create(@CurrentUser('id') userId: string, @Body() data: any) {
    return this.ordersService.create(userId, data);
  }

  @Get('orders')
  findMyOrders(@CurrentUser('id') userId: string) {
    return this.ordersService.findByCustomer(userId);
  }

  @Get('orders/:id/track')
  track(@Param('id') id: string) {
    return this.ordersService.track(id);
  }

  // Seller
  @Get('seller/orders')
  @UseGuards(RolesGuard)
  @Roles(Role.SELLER)
  findShopOrders(@CurrentUser() user: any) {
    return this.ordersService.findByShop(user.shopId);
  }

  @Patch('seller/orders/:id/status')
  @UseGuards(RolesGuard)
  @Roles(Role.SELLER)
  updateStatus(@Param('id') id: string, @Body('status') status: OrderStatus) {
    return this.ordersService.updateStatus(id, status);
  }
}
