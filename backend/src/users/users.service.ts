import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findById(id: string) {
    return this.prisma.user.findUnique({
      where: { id },
      include: { addresses: true },
    });
  }

  async updateProfile(id: string, data: any) {
    return this.prisma.user.update({
      where: { id },
      data,
    });
  }

  // Address management
  async addAddress(userId: string, data: any) {
    return this.prisma.address.create({
      data: { ...data, userId },
    });
  }

  async getAddresses(userId: string) {
    return this.prisma.address.findMany({
      where: { userId },
    });
  }

  async deleteAddress(id: string) {
    return this.prisma.address.delete({ where: { id } });
  }
}
