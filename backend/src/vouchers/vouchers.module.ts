import { Module } from '@nestjs/common';
import { VouchersService } from './vouchers.service';
import { VouchersController, CustomerVouchersController } from './vouchers.controller';

@Module({
  controllers: [VouchersController, CustomerVouchersController],
  providers: [VouchersService],
  exports: [VouchersService],
})
export class VouchersModule {}
