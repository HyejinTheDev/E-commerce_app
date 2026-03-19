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
      this.prisma.user.findMany({ where, skip: (page - 1) * limit, take: limit, orderBy: { createdAt: 'desc' } }),
      this.prisma.user.count({ where }),
    ]);

    return { data: users, total, page, pages: Math.ceil(total / limit) };
  }

  // Shop approval
  async approveShop(shopId: string, status: ShopStatus) {
    return this.prisma.shop.update({ where: { id: shopId }, data: { status } });
  }

  async getPendingShops() {
    return this.prisma.shop.findMany({ where: { status: ShopStatus.PENDING }, include: { seller: { select: { name: true, email: true } } } });
  }

  // System stats
  async getStats() {
    const [totalUsers, totalOrders, totalProducts, totalShops] = await Promise.all([
      this.prisma.user.count(),
      this.prisma.order.count(),
      this.prisma.product.count(),
      this.prisma.shop.count(),
    ]);

    return { totalUsers, totalOrders, totalProducts, totalShops };
  }

  // Ban/unban
  async toggleUserBan(userId: string, banned: boolean) {
    // Implementation depends on additional field in User model
    return this.prisma.user.update({ where: { id: userId }, data: {} });
  }
}
