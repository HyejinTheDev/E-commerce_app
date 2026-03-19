import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { OrderStatus } from '@prisma/client';

@Injectable()
export class OrdersService {
  constructor(private prisma: PrismaService) {}

  // Customer — create order
  async create(customerId: string, data: { addressId: string; items: { productId: string; quantity: number }[]; paymentMethod?: string; note?: string }) {
    const orderItems = await Promise.all(
      data.items.map(async (item) => {
        const product = await this.prisma.product.findUnique({ where: { id: item.productId } });
        if (!product) throw new NotFoundException(`Product ${item.productId} not found`);
        return { productId: item.productId, quantity: item.quantity, price: product.salePrice || product.price };
      }),
    );

    const totalAmount = orderItems.reduce((sum, item) => sum + Number(item.price) * item.quantity, 0);

    return this.prisma.order.create({
      data: {
        customerId,
        addressId: data.addressId,
        totalAmount,
        paymentMethod: data.paymentMethod,
        note: data.note,
        items: { create: orderItems },
      },
      include: { items: { include: { product: true } } },
    });
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
    return this.prisma.order.update({ where: { id: orderId }, data: { status } });
  }
}
