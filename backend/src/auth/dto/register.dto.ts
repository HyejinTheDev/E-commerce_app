import { IsEmail, IsNotEmpty, IsString, MinLength, IsOptional, IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Role } from '@prisma/client';

export class RegisterDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'password123' })
  @IsString()
  @MinLength(6)
  password: string;

  @ApiProperty({ example: 'John Doe' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({ example: '0123456789', required: false })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiProperty({ enum: Role, default: Role.CUSTOMER })
  @IsEnum(Role)
  @IsOptional()
  role?: Role;

  // ─── Seller-specific fields ───
  @ApiProperty({ example: 'My Fashion Store', required: false })
  @IsString()
  @IsOptional()
  shopName?: string;

  @ApiProperty({ example: 'Chuyên thời trang cao cấp', required: false })
  @IsString()
  @IsOptional()
  shopDescription?: string;

  // ─── Delivery-specific fields ───
  @ApiProperty({ example: 'Xe máy', required: false })
  @IsString()
  @IsOptional()
  vehicleType?: string;

  @ApiProperty({ example: '59A1-12345', required: false })
  @IsString()
  @IsOptional()
  licensePlate?: string;
}
