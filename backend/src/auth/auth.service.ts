import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    const { Role } = await import('@prisma/client');

    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email already exists');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);
    const role = dto.role || Role.CUSTOMER;

    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        password: hashedPassword,
        name: dto.name,
        phone: dto.phone,
        role,
      },
    });

    // Auto-create Shop for SELLER
    if (role === Role.SELLER) {
      await this.prisma.shop.create({
        data: {
          sellerId: user.id,
          name: `${dto.shopName || dto.name}'s Shop`,
          description: dto.shopDescription || null,
        },
      });
    }

    // Auto-create DeliveryProfile for DELIVERY
    if (role === Role.DELIVERY) {
      await this.prisma.deliveryProfile.create({
        data: {
          userId: user.id,
          vehicleType: dto.vehicleType || 'Xe máy',
          licensePlate: dto.licensePlate || null,
        },
      });
    }

    return this.generateTokens(user.id, user.email, user.role, user.name);
  }

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isPasswordValid = await bcrypt.compare(dto.password, user.password);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    return this.generateTokens(user.id, user.email, user.role, user.name);
  }

  async refreshToken(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    return this.generateTokens(user.id, user.email, user.role, user.name);
  }

  private generateTokens(userId: string, email: string, role: string, name: string) {
    const payload = { sub: userId, email, role };

    return {
      accessToken: this.jwtService.sign(payload),
      refreshToken: this.jwtService.sign(payload, {
        secret: process.env.JWT_REFRESH_SECRET,
        expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
      }),
      user: { id: userId, email, role, name },
    };
  }
}
