import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  // Public - Customer browsing
  async findAll(query: { search?: string; categoryId?: string; page?: number; limit?: number }) {
    const { search, categoryId, page = 1, limit = 20 } = query;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }
    if (categoryId) where.categoryId = categoryId;

    const [products, total] = await Promise.all([
      this.prisma.product.findMany({
        where,
        skip,
        take: limit,
        include: { shop: { select: { name: true, logo: true } }, category: true },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.product.count({ where }),
    ]);

    return { data: products, total, page, pages: Math.ceil(total / limit) };
  }

  async findById(id: string) {
    const product = await this.prisma.product.findUnique({
      where: { id },
      include: { shop: true, category: true, reviews: { include: { user: { select: { name: true, avatar: true } } } } },
    });
    if (!product) throw new NotFoundException('Product not found');
    return product;
  }

  // Seller - CRUD
  async create(shopId: string, data: any) {
    return this.prisma.product.create({ data: { ...data, shopId } });
  }

  async update(id: string, data: any) {
    return this.prisma.product.update({ where: { id }, data });
  }

  async delete(id: string) {
    return this.prisma.product.delete({ where: { id } });
  }

  async findByShop(shopId: string) {
    return this.prisma.product.findMany({ where: { shopId }, include: { category: true } });
  }
}
