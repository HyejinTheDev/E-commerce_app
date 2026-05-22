import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class VouchersService {
  constructor(private prisma: PrismaService) {}

  async create(shopId: string, data: any) {
    return this.prisma.voucher.create({ data: { ...data, shopId } });
  }

  async findByShop(shopId: string) {
    return this.prisma.voucher.findMany({ where: { shopId } });
  }

  async update(id: string, data: any) {
    return this.prisma.voucher.update({ where: { id }, data });
  }

  async delete(id: string) {
    return this.prisma.voucher.delete({ where: { id } });
  }

  async validateVoucher(code: string) {
    const voucher = await this.prisma.voucher.findUnique({ where: { code } });
    if (!voucher) return null;
    if (voucher.usedCount >= voucher.maxUses) return null;
    if (new Date() > voucher.expiresAt) return null;
    return voucher;
  }
}
