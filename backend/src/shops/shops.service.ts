import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ShopsService {
  constructor(private prisma: PrismaService) {}

  async create(sellerId: string, data: { name: string; description?: string }) {
    return this.prisma.shop.create({ data: { ...data, sellerId } });
  }

  async findBySeller(sellerId: string) {
    return this.prisma.shop.findUnique({ where: { sellerId }, include: { products: true } });
  }

  async update(sellerId: string, data: any) {
    return this.prisma.shop.update({ where: { sellerId }, data });
  }

  async getStats(sellerId: string) {
    const shop = await this.prisma.shop.findUnique({ where: { sellerId } });
    if (!shop) return null;

    const totalProducts = await this.prisma.product.count({ where: { shopId: shop.id } });
    const totalOrders = await this.prisma.order.count({
      where: { items: { some: { product: { shopId: shop.id } } } },
    });

    return { shop, totalProducts, totalOrders };
  }
}
