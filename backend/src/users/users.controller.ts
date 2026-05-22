import { Controller, Get, Patch, Post, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators';

@ApiTags('Users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('profile')
  getProfile(@CurrentUser('id') userId: string) {
    return this.usersService.findById(userId);
  }

  @Patch('profile')
  updateProfile(@CurrentUser('id') userId: string, @Body() data: any) {
    return this.usersService.updateProfile(userId, data);
  }

  @Get('addresses')
  getAddresses(@CurrentUser('id') userId: string) {
    return this.usersService.getAddresses(userId);
  }

  @Post('addresses')
  addAddress(@CurrentUser('id') userId: string, @Body() data: any) {
    return this.usersService.addAddress(userId, data);
  }

  @Delete('addresses/:id')
  deleteAddress(@Param('id') id: string) {
    return this.usersService.deleteAddress(id);
  }
}
