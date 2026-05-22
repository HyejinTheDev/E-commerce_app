import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class NotificationsService {
  constructor(private prisma: PrismaService) {}

  // Create a notification
  async create(userId: string, type: string, title: string, body: string, data?: any) {
    return this.prisma.notification.create({
      data: { userId, type, title, body, data },
    });
  }

  // Notify order status change → sends to the order's customer
  async notifyOrderStatusChange(orderId: string, status: string) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      select: { customerId: true, id: true },
    });
    if (!order) return;

    const statusMessages: Record<string, { title: string; body: string }> = {
      CONFIRMED: {
        title: '✅ Đơn hàng đã xác nhận',
        body: `Đơn hàng #${orderId.substring(0, 8)} đã được người bán xác nhận.`,
      },
      PROCESSING: {
        title: '📦 Đang chuẩn bị hàng',
        body: `Đơn hàng #${orderId.substring(0, 8)} đang được đóng gói.`,
      },
      SHIPPING: {
        title: '🚚 Đang giao hàng',
        body: `Đơn hàng #${orderId.substring(0, 8)} đang trên đường đến bạn.`,
      },
      DELIVERED: {
        title: '🎉 Giao hàng thành công',
        body: `Đơn hàng #${orderId.substring(0, 8)} đã được giao. Cảm ơn bạn!`,
      },
      CANCELLED: {
        title: '❌ Đơn hàng đã huỷ',
        body: `Đơn hàng #${orderId.substring(0, 8)} đã bị huỷ.`,
      },
    };

    const msg = statusMessages[status];
    if (msg) {
      await this.create(order.customerId, 'ORDER_STATUS', msg.title, msg.body, { orderId });
    }
  }

  // Get notifications for a user
  async findAll(userId: string, page = 1, limit = 30) {
    const skip = (page - 1) * limit;
    const [notifications, total] = await Promise.all([
      this.prisma.notification.findMany({
        where: { userId },
        orderBy: { createdAt: 'desc' },
        take: limit,
        skip,
      }),
      this.prisma.notification.count({ where: { userId } }),
    ]);
    return { data: notifications, total, page, pages: Math.ceil(total / limit) };
  }

  // Get unread count
  async getUnreadCount(userId: string) {
    const count = await this.prisma.notification.count({
      where: { userId, isRead: false },
    });
    return { unreadCount: count };
  }

  // Mark one as read
  async markAsRead(id: string, userId: string) {
    return this.prisma.notification.updateMany({
      where: { id, userId },
      data: { isRead: true },
    });
  }

  // Mark all as read
  async markAllAsRead(userId: string) {
    return this.prisma.notification.updateMany({
      where: { userId, isRead: false },
      data: { isRead: true },
    });
  }
}
