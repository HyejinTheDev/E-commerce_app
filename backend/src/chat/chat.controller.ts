import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { ChatService } from './chat.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators';

@ApiTags('Chat')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('chat')
export class ChatController {
  constructor(private chatService: ChatService) {}

  // Start or get a conversation with another user
  @Post('conversations')
  startConversation(
    @CurrentUser('id') userId: string,
    @Body() body: { otherUserId: string; shopId?: string },
  ) {
    return this.chatService.getOrCreateConversation(userId, body.otherUserId, body.shopId);
  }

  // List all conversations
  @Get('conversations')
  getConversations(@CurrentUser('id') userId: string) {
    return this.chatService.getConversations(userId);
  }

  // Get messages in a conversation
  @Get('conversations/:id/messages')
  getMessages(
    @Param('id') conversationId: string,
    @CurrentUser('id') userId: string,
    @Query('page') page?: number,
  ) {
    return this.chatService.getMessages(conversationId, userId, page || 1);
  }

  // Send a message
  @Post('conversations/:id/messages')
  sendMessage(
    @Param('id') conversationId: string,
    @CurrentUser('id') senderId: string,
    @Body() body: { content: string; imageUrl?: string },
  ) {
    return this.chatService.sendMessage(conversationId, senderId, body.content, body.imageUrl);
  }

  // Get unread count
  @Get('unread')
  getUnreadCount(@CurrentUser('id') userId: string) {
    return this.chatService.getUnreadCount(userId);
  }
}
