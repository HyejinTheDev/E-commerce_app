import { Controller, Get, Patch, Param, Query, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards';
import { Roles } from '../common/decorators';
import { Role, ShopStatus } from '@prisma/client';

@ApiTags('Admin')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.ADMIN)
@Controller('admin')
export class AdminController {
  constructor(private adminService: AdminService) {}

  @Get('users')
  getAllUsers(@Query() query: { role?: string; page?: number; limit?: number }) {
    return this.adminService.getAllUsers(query);
  }

  @Get('shops/pending')
  getPendingShops() {
    return this.adminService.getPendingShops();
  }

  @Patch('shops/:id/approve')
  approveShop(@Param('id') id: string, @Body('status') status: ShopStatus) {
    return this.adminService.approveShop(id, status);
  }

  @Get('stats')
  getStats() {
    return this.adminService.getStats();
  }

  @Patch('users/:id/ban')
  toggleBan(@Param('id') id: string, @Body('banned') banned: boolean) {
    return this.adminService.toggleUserBan(id, banned);
  }
}
