import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards, Req } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators';
import { Role } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { ProductsService } from '../products/products.service';
import { OrdersService } from '../orders/orders.service';

@ApiTags('Seller')
@Controller('seller')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class SellerController {
  constructor(
    private prisma: PrismaService,
    private productsService: ProductsService,
    private ordersService: OrdersService,
  ) {}

  // ─── Register as Seller (any authenticated user) ───
  @Post('register')
  async registerAsSeller(
    @CurrentUser() user: any,
    @Body() data: { shopName: string; shopDescription?: string },
  ) {
    // Check if already a seller
    const existingShop = await this.prisma.shop.findUnique({
      where: { sellerId: user.id },
    });
    if (existingShop) {
      return { message: 'Bạn đã có cửa hàng', shop: existingShop };
    }

    // Upgrade role to SELLER
    await this.prisma.user.update({
      where: { id: user.id },
      data: { role: Role.SELLER },
    });

    // Create shop
    const shop = await this.prisma.shop.create({
      data: {
        sellerId: user.id,
        name: data.shopName || `${user.name}'s Shop`,
        description: data.shopDescription || null,
      },
    });

    return { message: 'Đăng ký bán hàng thành công!', shop };
  }

  // ─── Check seller status (any authenticated user) ───
  @Get('status')
  async getSellerStatus(@CurrentUser() user: any) {
    const shop = await this.prisma.shop.findUnique({
      where: { sellerId: user.id },
    });
    return {
      isSeller: shop != null,
      shop: shop,
    };
  }

  // ─── Dashboard Stats ───
  @Get('dashboard')
  async getDashboard(@CurrentUser() user: any) {
    const shop = await this.prisma.shop.findUnique({
      where: { sellerId: user.id },
    });
    if (!shop) return { error: 'Shop not found' };

    const [totalProducts, totalOrders, products] = await Promise.all([
      this.prisma.product.count({ where: { shopId: shop.id } }),
      this.prisma.order.count({
        where: { items: { some: { product: { shopId: shop.id } } } },
      }),
      this.prisma.product.findMany({
        where: { shopId: shop.id },
        include: { orderItems: true },
      }),
    ]);

    // Calculate revenue
    const totalRevenue = products.reduce((sum, p) => {
      const itemRevenue = p.orderItems.reduce(
        (s, item) => s + Number(item.price) * item.quantity,
        0,
      );
      return sum + itemRevenue;
    }, 0);

    // Pending orders
    const pendingOrders = await this.prisma.order.count({
      where: {
        status: 'PENDING',
        items: { some: { product: { shopId: shop.id } } },
      },
    });

    return {
      shop: { id: shop.id, name: shop.name, status: shop.status },
      stats: {
        totalProducts,
        totalOrders,
        pendingOrders,
        totalRevenue,
      },
    };
  }

  // ─── My Products ───
  @Get('products')
  async getProducts(@CurrentUser() user: any) {
    const shop = await this.prisma.shop.findUnique({
      where: { sellerId: user.id },
    });
    if (!shop) return [];
    return this.productsService.findByShop(shop.id);
  }

  @Post('products')
  async createProduct(@CurrentUser() user: any, @Body() data: any) {
    const shop = await this.prisma.shop.findUnique({
      where: { sellerId: user.id },
    });
    if (!shop) return { error: 'Shop not found' };
    return this.productsService.create(shop.id, data);
  }

  @Patch('products/:id')
  async updateProduct(@Param('id') id: string, @Body() data: any) {
    return this.productsService.update(id, data);
  }

  @Delete('products/:id')
  async deleteProduct(@Param('id') id: string) {
    return this.productsService.delete(id);
  }

  // ─── My Orders ───
  @Get('orders')
  async getOrders(@CurrentUser() user: any) {
    const shop = await this.prisma.shop.findUnique({
      where: { sellerId: user.id },
    });
    if (!shop) return [];
    return this.ordersService.findByShop(shop.id);
  }

  @Patch('orders/:id/status')
  async updateOrderStatus(
    @Param('id') id: string,
    @Body() data: { status: string },
  ) {
    return this.ordersService.updateStatus(id, data.status as any);
  }
}
