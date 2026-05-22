import { Module } from '@nestjs/common';
import { ShopsService } from './shops.service';
import { ShopsController } from './shops.controller';
import { SellerController } from './seller.controller';
import { ProductsModule } from '../products/products.module';
import { OrdersModule } from '../orders/orders.module';

@Module({
  imports: [ProductsModule, OrdersModule],
  controllers: [ShopsController, SellerController],
  providers: [ShopsService],
  exports: [ShopsService],
})
export class ShopsModule {}
