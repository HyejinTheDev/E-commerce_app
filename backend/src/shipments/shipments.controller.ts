import { Controller, Get, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { ShipmentsService } from './shipments.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards';
import { Roles, CurrentUser } from '../common/decorators';
import { Role, ShipmentStatus } from '@prisma/client';

@ApiTags('Delivery')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.DELIVERY)
@Controller('delivery')
export class ShipmentsController {
  constructor(private shipmentsService: ShipmentsService) {}

  @Get('shipments')
  findMyShipments(@CurrentUser() user: any) {
    return this.shipmentsService.findByDriver(user.deliveryProfileId);
  }

  @Patch('shipments/:id/status')
  updateStatus(@Param('id') id: string, @Body('status') status: ShipmentStatus) {
    return this.shipmentsService.updateStatus(id, status);
  }

  @Get('history')
  getHistory(@CurrentUser() user: any) {
    return this.shipmentsService.getHistory(user.deliveryProfileId);
  }

  @Patch('availability')
  toggleAvailability(@CurrentUser('id') userId: string, @Body('isAvailable') isAvailable: boolean) {
    return this.shipmentsService.toggleAvailability(userId, isAvailable);
  }
}
