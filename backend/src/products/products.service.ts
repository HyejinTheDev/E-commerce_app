import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  // Public - Customer browsing
  async findAll(query: { search?: string; categoryId?: string; page?: number; limit?: number; sort?: string; maxPrice?: number }) {
    const { search, categoryId } = query;
    const page = Number(query.page) || 1;
    const limit = Number(query.limit) || 20;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }
    if (categoryId) where.categoryId = categoryId;
    if (query.maxPrice) {
      where.price = { lte: Number(query.maxPrice) };
    }

    // Determine sort order
    let orderBy: any = { createdAt: 'desc' };
    switch (query.sort) {
      case 'price_asc':
        orderBy = { price: 'asc' };
        break;
      case 'price_desc':
        orderBy = { price: 'desc' };
        break;
      case 'newest':
        orderBy = { createdAt: 'desc' };
        break;
      // 'best_rated' handled after fetch
    }

    const [products, total] = await Promise.all([
      this.prisma.product.findMany({
        where,
        skip,
        take: limit,
        include: { shop: { select: { name: true, logo: true } }, category: true, reviews: { select: { rating: true } } },
        orderBy,
      }),
      this.prisma.product.count({ where }),
    ]);

    // For best_rated, sort by average review rating in memory
    let sortedProducts = products;
    if (query.sort === 'best_rated') {
      sortedProducts = [...products].sort((a, b) => {
        const avgA = a.reviews.length > 0 ? a.reviews.reduce((sum, r) => sum + r.rating, 0) / a.reviews.length : 0;
        const avgB = b.reviews.length > 0 ? b.reviews.reduce((sum, r) => sum + r.rating, 0) / b.reviews.length : 0;
        return avgB - avgA;
      });
    }

    return { data: sortedProducts, total, page, pages: Math.ceil(total / limit) };
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

  // Reviews
  async addReview(productId: string, userId: string, data: { rating: number; comment?: string }) {
    // Verify product exists
    const product = await this.prisma.product.findUnique({ where: { id: productId } });
    if (!product) throw new NotFoundException('Product not found');

    const review = await this.prisma.review.create({
      data: {
        productId,
        userId,
        rating: data.rating,
        comment: data.comment,
      },
      include: {
        user: { select: { name: true, avatar: true } },
      },
    });

    return review;
  }
}
