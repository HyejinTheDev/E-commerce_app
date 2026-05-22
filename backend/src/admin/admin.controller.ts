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

  // ─── Users ───
  @Get('users')
  getAllUsers(@Query() query: { role?: string; page?: number; limit?: number }) {
    return this.adminService.getAllUsers(query);
  }

  @Patch('users/:id/role')
  updateUserRole(@Param('id') id: string, @Body('role') role: string) {
    return this.adminService.updateUserRole(id, role);
  }

  // ─── Shops ───
  @Get('shops')
  getAllShops() {
    return this.adminService.getAllShops();
  }

  @Get('shops/pending')
  getPendingShops() {
    return this.adminService.getPendingShops();
  }

  @Patch('shops/:id/approve')
  approveShop(@Param('id') id: string, @Body('status') status: ShopStatus) {
    return this.adminService.approveShop(id, status);
  }

  // ─── Drivers ───
  @Get('drivers')
  getAllDrivers() {
    return this.adminService.getAllDrivers();
  }

  @Patch('drivers/:id/availability')
  toggleDriverAvailability(
    @Param('id') id: string,
    @Body('isAvailable') isAvailable: boolean,
  ) {
    return this.adminService.toggleDriverAvailability(id, isAvailable);
  }

  // ─── Stats ───
  @Get('stats')
  getStats() {
    return this.adminService.getStats();
  }
}
