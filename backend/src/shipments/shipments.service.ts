import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ShipmentStatus, OrderStatus } from '@prisma/client';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class ShipmentsService {
  constructor(
    private prisma: PrismaService,
    private notificationsService: NotificationsService,
  ) {}

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

    const shipment = await this.prisma.shipment.update({
      where: { id: shipmentId },
      data,
      include: { order: true },
    });

    // Sync order status when shipment is delivered
    if (status === ShipmentStatus.DELIVERED && shipment.order) {
      await this.prisma.order.update({
        where: { id: shipment.orderId },
        data: { status: OrderStatus.DELIVERED },
      });
      // 🔔 Notify customer
      await this.notificationsService.notifyOrderStatusChange(shipment.orderId, 'DELIVERED');
    }

    return shipment;
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
