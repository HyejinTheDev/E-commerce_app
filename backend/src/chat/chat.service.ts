import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ChatService {
  constructor(private prisma: PrismaService) {}

  // Get or create a conversation between two users
  async getOrCreateConversation(userId: string, otherUserId: string, shopId?: string) {
    // Sort IDs to ensure consistent unique constraint
    const [p1, p2] = [userId, otherUserId].sort();

    let conversation = await this.prisma.conversation.findUnique({
      where: { participant1Id_participant2Id: { participant1Id: p1, participant2Id: p2 } },
      include: {
        participant1: { select: { id: true, name: true, avatar: true, role: true } },
        participant2: { select: { id: true, name: true, avatar: true, role: true } },
        messages: { take: 1, orderBy: { createdAt: 'desc' } },
      },
    });

    if (!conversation) {
      conversation = await this.prisma.conversation.create({
        data: { participant1Id: p1, participant2Id: p2, shopId },
        include: {
          participant1: { select: { id: true, name: true, avatar: true, role: true } },
          participant2: { select: { id: true, name: true, avatar: true, role: true } },
          messages: { take: 1, orderBy: { createdAt: 'desc' } },
        },
      });
    }

    return conversation;
  }

  // List all conversations for a user
  async getConversations(userId: string) {
    const conversations = await this.prisma.conversation.findMany({
      where: { OR: [{ participant1Id: userId }, { participant2Id: userId }] },
      include: {
        participant1: { select: { id: true, name: true, avatar: true, role: true } },
        participant2: { select: { id: true, name: true, avatar: true, role: true } },
      },
      orderBy: { lastMessageAt: { sort: 'desc', nulls: 'last' } },
    });

    // Count unread messages for each conversation
    const result = await Promise.all(
      conversations.map(async (conv) => {
        const unreadCount = await this.prisma.message.count({
          where: { conversationId: conv.id, senderId: { not: userId }, isRead: false },
        });
        return { ...conv, unreadCount };
      }),
    );

    return result;
  }

  // Get messages in a conversation (paginated)
  async getMessages(conversationId: string, userId: string, page = 1, limit = 50) {
    // Mark all messages from other user as read
    await this.prisma.message.updateMany({
      where: { conversationId, senderId: { not: userId }, isRead: false },
      data: { isRead: true },
    });

    const messages = await this.prisma.message.findMany({
      where: { conversationId },
      include: { sender: { select: { id: true, name: true, avatar: true } } },
      orderBy: { createdAt: 'desc' },
      take: limit,
      skip: (page - 1) * limit,
    });

    return messages.reverse(); // Return in chronological order
  }

  // Send a message
  async sendMessage(conversationId: string, senderId: string, content: string, imageUrl?: string) {
    const message = await this.prisma.message.create({
      data: { conversationId, senderId, content, imageUrl },
      include: { sender: { select: { id: true, name: true, avatar: true } } },
    });

    // Update conversation last message
    await this.prisma.conversation.update({
      where: { id: conversationId },
      data: { lastMessage: content, lastMessageAt: new Date() },
    });

    return message;
  }

  // Get unread count for a user across all conversations
  async getUnreadCount(userId: string) {
    const count = await this.prisma.message.count({
      where: {
        conversation: { OR: [{ participant1Id: userId }, { participant2Id: userId }] },
        senderId: { not: userId },
        isRead: false,
      },
    });
    return { unreadCount: count };
  }
}
