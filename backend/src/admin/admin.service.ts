import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ShopStatus } from '@prisma/client';

@Injectable()
export class AdminService {
  constructor(private prisma: PrismaService) {}

  // User management
  async getAllUsers(query: { role?: string; page?: number; limit?: number }) {
    const { role, page = 1, limit = 20 } = query;
    const where: any = {};
    if (role) where.role = role;

    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        skip: (page - 1) * limit,
        take: limit,
        orderBy: { createdAt: 'desc' },
        select: {
          id: true, email: true, name: true, phone: true,
          avatar: true, role: true, createdAt: true,
          _count: { select: { orders: true, reviews: true } },
        },
      }),
      this.prisma.user.count({ where }),
    ]);

    return { data: users, total, page, pages: Math.ceil(total / limit) };
  }

  // Shop approval
  async approveShop(shopId: string, status: ShopStatus) {
    return this.prisma.shop.update({
      where: { id: shopId },
      data: { status },
      include: { seller: { select: { name: true, email: true } } },
    });
  }

  async getPendingShops() {
    return this.prisma.shop.findMany({
      where: { status: ShopStatus.PENDING },
      include: { seller: { select: { name: true, email: true } }, _count: { select: { products: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getAllShops() {
    return this.prisma.shop.findMany({
      include: { seller: { select: { name: true, email: true } }, _count: { select: { products: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  // Delivery driver management
  async getAllDrivers() {
    return this.prisma.deliveryProfile.findMany({
      include: {
        user: { select: { name: true, email: true, phone: true } },
        _count: { select: { shipments: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async toggleDriverAvailability(driverId: string, isAvailable: boolean) {
    return this.prisma.deliveryProfile.update({
      where: { id: driverId },
      data: { isAvailable },
      include: { user: { select: { name: true, email: true } } },
    });
  }

  // Detailed system stats
  async getStats() {
    const [
      totalUsers, totalOrders, totalProducts, totalShops,
      totalDrivers, pendingShops, activeShipments,
    ] = await Promise.all([
      this.prisma.user.count(),
      this.prisma.order.count(),
      this.prisma.product.count(),
      this.prisma.shop.count(),
      this.prisma.deliveryProfile.count(),
      this.prisma.shop.count({ where: { status: 'PENDING' } }),
      this.prisma.shipment.count({ where: { status: { in: ['ASSIGNED', 'PICKING_UP', 'PICKED_UP', 'IN_TRANSIT'] } } }),
    ]);

    // Revenue
    const orders = await this.prisma.order.findMany({
      where: { status: { in: ['CONFIRMED', 'PROCESSING', 'SHIPPING', 'DELIVERED'] } },
      select: { totalAmount: true },
    });
    const totalRevenue = orders.reduce((sum, o) => sum + Number(o.totalAmount), 0);

    // Order status breakdown
    const ordersByStatus = await this.prisma.order.groupBy({
      by: ['status'],
      _count: true,
    });

    return {
      totalUsers, totalOrders, totalProducts, totalShops,
      totalDrivers, pendingShops, activeShipments, totalRevenue,
      ordersByStatus: ordersByStatus.reduce((acc, cur) => {
        acc[cur.status] = cur._count;
        return acc;
      }, {} as Record<string, number>),
    };
  }

  // Update user role
  async updateUserRole(userId: string, role: string) {
    return this.prisma.user.update({
      where: { id: userId },
      data: { role: role as any },
    });
  }
}

