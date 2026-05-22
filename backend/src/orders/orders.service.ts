import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { OrderStatus } from '@prisma/client';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class OrdersService {
  constructor(
    private prisma: PrismaService,
    private notificationsService: NotificationsService,
  ) {}

  // Customer — create order
  async create(customerId: string, data: { addressId?: string; items: { productId: string; quantity: number }[]; paymentMethod?: string; note?: string }) {
    // Resolve address: use provided or find/create default
    let addressId = data.addressId;
    if (!addressId || addressId === 'default-address') {
      const defaultAddr = await this.prisma.address.findFirst({
        where: { userId: customerId, isDefault: true },
      });
      if (defaultAddr) {
        addressId = defaultAddr.id;
      } else {
        // Create a default address for the user
        const newAddr = await this.prisma.address.create({
          data: {
            userId: customerId,
            name: 'Default Address',
            phone: '0000000000',
            street: '123 Default Street',
            ward: 'Ward 1',
            district: 'District 1',
            city: 'Ho Chi Minh City',
            isDefault: true,
          },
        });
        addressId = newAddr.id;
      }
    }

    const orderItems = await Promise.all(
      data.items.map(async (item) => {
        const product = await this.prisma.product.findUnique({ where: { id: item.productId } });
        if (!product) throw new NotFoundException(`Product ${item.productId} not found`);
        return { productId: item.productId, quantity: item.quantity, price: product.salePrice || product.price };
      }),
    );

    const totalAmount = orderItems.reduce((sum, item) => sum + Number(item.price) * item.quantity, 0);

    const order = await this.prisma.order.create({
      data: {
        customerId,
        addressId,
        totalAmount,
        paymentMethod: data.paymentMethod,
        note: data.note,
        items: { create: orderItems },
      },
      include: { items: { include: { product: true } } },
    });

    // Notify customer about new order
    await this.notificationsService.create(
      customerId,
      'ORDER_STATUS',
      '🛒 Đặt hàng thành công',
      `Đơn hàng #${order.id.substring(0, 8)} đã được tạo. Chờ người bán xác nhận.`,
      { orderId: order.id },
    );

    return order;
  }

  // Customer — order history
  async findByCustomer(customerId: string) {
    return this.prisma.order.findMany({
      where: { customerId },
      include: { items: { include: { product: true } }, shipment: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  // Track order
  async track(orderId: string) {
    return this.prisma.order.findUnique({
      where: { id: orderId },
      include: { items: { include: { product: true } }, shipment: true, address: true },
    });
  }

  // Seller — orders for shop
  async findByShop(shopId: string) {
    return this.prisma.order.findMany({
      where: { items: { some: { product: { shopId } } } },
      include: { items: { include: { product: true } }, customer: { select: { name: true, email: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  // Seller — update status
  async updateStatus(orderId: string, status: OrderStatus) {
    const order = await this.prisma.order.update({
      where: { id: orderId },
      data: { status },
      include: { shipment: true },
    });

    // When order moves to SHIPPING, auto-create shipment for delivery
    if (status === OrderStatus.SHIPPING && !order.shipment) {
      // Find an available delivery driver
      const availableDriver = await this.prisma.deliveryProfile.findFirst({
        where: { isAvailable: true },
        orderBy: { createdAt: 'asc' },
      });

      if (availableDriver) {
        await this.prisma.shipment.create({
          data: {
            orderId: order.id,
            driverId: availableDriver.id,
            status: 'ASSIGNED',
          },
        });
      }
    }

    // 🔔 Notify customer about status change
    await this.notificationsService.notifyOrderStatusChange(orderId, status);

    return order;
  }
}
