import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { OrdersService } from './orders.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators';

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
}
