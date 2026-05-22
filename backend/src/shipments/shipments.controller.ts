import {
  Controller, Get, Post, Patch, Body, Param, UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators';
import { Role, ShipmentStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { ShipmentsService } from './shipments.service';

@ApiTags('Delivery')
@Controller('delivery')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ShipmentsController {
  constructor(
    private prisma: PrismaService,
    private shipmentsService: ShipmentsService,
  ) {}

  // ─── Register as Delivery Driver (any authenticated user) ───
  @Post('register')
  async registerAsDriver(
    @CurrentUser() user: any,
    @Body() data: { vehicleType: string; licensePlate?: string },
  ) {
    // Check if already a driver
    const existing = await this.prisma.deliveryProfile.findUnique({
      where: { userId: user.id },
    });
    if (existing) {
      return { message: 'Bạn đã đăng ký giao hàng', profile: existing };
    }

    // Upgrade role
    await this.prisma.user.update({
      where: { id: user.id },
      data: { role: Role.DELIVERY },
    });

    // Create delivery profile
    const profile = await this.prisma.deliveryProfile.create({
      data: {
        userId: user.id,
        vehicleType: data.vehicleType || 'Xe máy',
        licensePlate: data.licensePlate || null,
      },
    });

    return { message: 'Đăng ký giao hàng thành công!', profile };
  }

  // ─── Check delivery status (any authenticated user) ───
  @Get('status')
  async getDeliveryStatus(@CurrentUser() user: any) {
    const profile = await this.prisma.deliveryProfile.findUnique({
      where: { userId: user.id },
    });
    return {
      isDriver: profile != null,
      profile,
    };
  }

  // ─── Dashboard Stats ───
  @Get('dashboard')
  async getDashboard(@CurrentUser() user: any) {
    const profile = await this.prisma.deliveryProfile.findUnique({
      where: { userId: user.id },
    });
    if (!profile) return { error: 'Not a delivery driver' };

    const [totalShipments, activeShipments, completedShipments] =
      await Promise.all([
        this.prisma.shipment.count({ where: { driverId: profile.id } }),
        this.prisma.shipment.count({
          where: {
            driverId: profile.id,
            status: { in: ['ASSIGNED', 'PICKING_UP', 'PICKED_UP', 'IN_TRANSIT'] },
          },
        }),
        this.prisma.shipment.count({
          where: { driverId: profile.id, status: 'DELIVERED' },
        }),
      ]);

    return {
      profile: {
        id: profile.id,
        vehicleType: profile.vehicleType,
        licensePlate: profile.licensePlate,
        isAvailable: profile.isAvailable,
      },
      stats: {
        totalShipments,
        activeShipments,
        completedShipments,
      },
    };
  }

  // ─── My Shipments ───
  @Get('shipments')
  async findMyShipments(@CurrentUser() user: any) {
    const profile = await this.prisma.deliveryProfile.findUnique({
      where: { userId: user.id },
    });
    if (!profile) return [];
    return this.shipmentsService.findByDriver(profile.id);
  }

  @Patch('shipments/:id/status')
  updateStatus(
    @Param('id') id: string,
    @Body('status') status: ShipmentStatus,
  ) {
    return this.shipmentsService.updateStatus(id, status);
  }

  @Get('history')
  async getHistory(@CurrentUser() user: any) {
    const profile = await this.prisma.deliveryProfile.findUnique({
      where: { userId: user.id },
    });
    if (!profile) return [];
    return this.shipmentsService.getHistory(profile.id);
  }

  @Patch('availability')
  toggleAvailability(
    @CurrentUser('id') userId: string,
    @Body('isAvailable') isAvailable: boolean,
  ) {
    return this.shipmentsService.toggleAvailability(userId, isAvailable);
  }
}
