import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ShipmentStatus } from '@prisma/client';

@Injectable()
export class ShipmentsService {
  constructor(private prisma: PrismaService) {}

  async findByDriver(driverId: string) {
    return this.prisma.shipment.findMany({
      where: { driverId },
      include: { order: { include: { items: { include: { product: true } }, address: true, customer: { select: { name: true, phone: true } } } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateStatus(shipmentId: string, status: ShipmentStatus) {
    const data: any = { status };
    if (status === ShipmentStatus.PICKED_UP) data.pickedUpAt = new Date();
    if (status === ShipmentStatus.DELIVERED) data.deliveredAt = new Date();

    return this.prisma.shipment.update({ where: { id: shipmentId }, data });
  }

  async getHistory(driverId: string) {
    return this.prisma.shipment.findMany({
      where: { driverId, status: { in: [ShipmentStatus.DELIVERED, ShipmentStatus.FAILED] } },
      include: { order: true },
      orderBy: { deliveredAt: 'desc' },
    });
  }

  async toggleAvailability(userId: string, isAvailable: boolean) {
    return this.prisma.deliveryProfile.update({
      where: { userId },
      data: { isAvailable },
    });
  }
}
