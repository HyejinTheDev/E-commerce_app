# E-commerce Full-Stack — 4 Actor System

## Stack

| Layer | Technology |
|---|---|
| **Mobile** | Flutter + Clean Architecture + BLoC + Dio + Freezed + GetIt |
| **Backend** | NestJS + TypeScript + Prisma ORM |
| **Database** | PostgreSQL |
| **Auth** | JWT (access + refresh tokens) + Role-based guards |

---

## 4 Actors & Use Cases

### 👤 1. Customer (Người dùng)
- Đăng ký / Đăng nhập
- Duyệt sản phẩm, tìm kiếm, lọc theo danh mục
- Thêm vào giỏ hàng, đặt hàng, thanh toán
- Theo dõi đơn hàng realtime
- Đánh giá sản phẩm & shop
- Quản lý địa chỉ, thông tin cá nhân

### 🏪 2. Seller (Người bán hàng)
- Đăng ký shop, quản lý thông tin shop
- CRUD sản phẩm (thêm, sửa, xóa, cập nhật tồn kho)
- Quản lý đơn hàng (xác nhận, đóng gói, chuyển giao shipper)
- Xem thống kê doanh thu
- Quản lý khuyến mãi / voucher

### 🚚 3. Delivery (Giao hàng)
- Nhận đơn giao hàng
- Cập nhật trạng thái giao hàng (đang lấy, đang giao, đã giao)
- Xác nhận giao thành công / thất bại
- Xem lịch sử giao hàng, thu nhập

### 🛡️ 4. Admin
- Quản lý users, sellers, shippers
- Duyệt shop đăng ký
- Quản lý danh mục sản phẩm
- Xem reports, thống kê toàn hệ thống
- Xử lý khiếu nại, ban/unban accounts

---

## Database Schema (Prisma)

```prisma
enum Role { CUSTOMER SELLER DELIVERY ADMIN }
enum OrderStatus { PENDING CONFIRMED PROCESSING SHIPPING DELIVERED CANCELLED RETURNED }
enum ShipmentStatus { ASSIGNED PICKING_UP PICKED_UP IN_TRANSIT DELIVERED FAILED }
enum ShopStatus { PENDING APPROVED REJECTED SUSPENDED }

model User {
  id              String           @id @default(uuid())
  email           String           @unique
  password        String
  name            String
  phone           String?
  avatar          String?
  role            Role             @default(CUSTOMER)
  addresses       Address[]
  orders          Order[]          // Customer's orders
  reviews         Review[]
  shop            Shop?            // If role = SELLER
  deliveryProfile DeliveryProfile? // If role = DELIVERY
  createdAt       DateTime         @default(now())
  updatedAt       DateTime         @updatedAt
}

model Shop {
  id          String     @id @default(uuid())
  sellerId    String     @unique
  seller      User       @relation(fields: [sellerId], references: [id])
  name        String
  description String?
  logo        String?
  banner      String?
  status      ShopStatus @default(PENDING)
  rating      Float      @default(0)
  products    Product[]
  vouchers    Voucher[]
  createdAt   DateTime   @default(now())
  updatedAt   DateTime   @updatedAt
}

model DeliveryProfile {
  id          String     @id @default(uuid())
  userId      String     @unique
  user        User       @relation(fields: [userId], references: [id])
  vehicleType String
  licensePlate String?
  isAvailable Boolean    @default(true)
  shipments   Shipment[]
  createdAt   DateTime   @default(now())
}

model Category {
  id       String     @id @default(uuid())
  name     String     @unique
  slug     String     @unique
  image    String?
  parentId String?
  parent   Category?  @relation("SubCategories", fields: [parentId], references: [id])
  children Category[] @relation("SubCategories")
  products Product[]
}

model Product {
  id          String      @id @default(uuid())
  name        String
  slug        String      @unique
  description String
  price       Decimal
  salePrice   Decimal?
  stock       Int         @default(0)
  images      String[]
  shopId      String
  shop        Shop        @relation(fields: [shopId], references: [id])
  categoryId  String
  category    Category    @relation(fields: [categoryId], references: [id])
  orderItems  OrderItem[]
  reviews     Review[]
  createdAt   DateTime    @default(now())
  updatedAt   DateTime    @updatedAt
}

model Order {
  id            String      @id @default(uuid())
  customerId    String
  customer      User        @relation(fields: [customerId], references: [id])
  items         OrderItem[]
  totalAmount   Decimal
  status        OrderStatus @default(PENDING)
  addressId     String
  address       Address     @relation(fields: [addressId], references: [id])
  shipment      Shipment?
  paymentMethod String?
  note          String?
  createdAt     DateTime    @default(now())
  updatedAt     DateTime    @updatedAt
}

model OrderItem {
  id        String  @id @default(uuid())
  orderId   String
  order     Order   @relation(fields: [orderId], references: [id])
  productId String
  product   Product @relation(fields: [productId], references: [id])
  quantity  Int
  price     Decimal
}

model Shipment {
  id          String         @id @default(uuid())
  orderId     String         @unique
  order       Order          @relation(fields: [orderId], references: [id])
  driverId    String
  driver      DeliveryProfile @relation(fields: [driverId], references: [id])
  status      ShipmentStatus @default(ASSIGNED)
  pickedUpAt  DateTime?
  deliveredAt DateTime?
  note        String?
  createdAt   DateTime       @default(now())
  updatedAt   DateTime       @updatedAt
}

model Address {
  id        String  @id @default(uuid())
  userId    String
  user      User    @relation(fields: [userId], references: [id])
  name      String
  phone     String
  street    String
  ward      String
  district  String
  city      String
  isDefault Boolean @default(false)
  orders    Order[]
}

model Review {
  id        String   @id @default(uuid())
  userId    String
  user      User     @relation(fields: [userId], references: [id])
  productId String
  product   Product  @relation(fields: [productId], references: [id])
  rating    Int
  comment   String?
  createdAt DateTime @default(now())
}

model Voucher {
  id          String   @id @default(uuid())
  shopId      String
  shop        Shop     @relation(fields: [shopId], references: [id])
  code        String   @unique
  discount    Decimal
  minOrder    Decimal  @default(0)
  maxUses     Int
  usedCount   Int      @default(0)
  expiresAt   DateTime
  createdAt   DateTime @default(now())
}
```

---

## API Endpoints by Actor

### Auth (All)
| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/auth/register` | Đăng ký (chọn role) |
| `POST` | `/auth/login` | Đăng nhập → JWT |
| `POST` | `/auth/refresh` | Refresh token |

### Customer
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/products` | Danh sách SP (filter, sort, paginate) |
| `GET` | `/products/:id` | Chi tiết SP |
| `GET` | `/categories` | Danh mục |
| `POST` | `/orders` | Tạo đơn hàng |
| `GET` | `/orders` | Lịch sử đơn hàng |
| `GET` | `/orders/:id/track` | Theo dõi đơn hàng |
| `POST` | `/reviews` | Đánh giá SP |

### Seller
| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/seller/shop` | Đăng ký shop |
| `CRUD` | `/seller/products` | Quản lý SP |
| `GET` | `/seller/orders` | Đơn hàng của shop |
| `PATCH` | `/seller/orders/:id/status` | Cập nhật trạng thái |
| `CRUD` | `/seller/vouchers` | Quản lý voucher |
| `GET` | `/seller/stats` | Thống kê doanh thu |

### Delivery
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/delivery/shipments` | Đơn được giao |
| `PATCH` | `/delivery/shipments/:id/status` | Cập nhật trạng thái |
| `GET` | `/delivery/history` | Lịch sử giao hàng |
| `PATCH` | `/delivery/availability` | Bật/tắt nhận đơn |

### Admin
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/admin/users` | Quản lý users |
| `PATCH` | `/admin/shops/:id/approve` | Duyệt shop |
| `CRUD` | `/admin/categories` | Quản lý danh mục |
| `GET` | `/admin/stats` | Thống kê hệ thống |

---

## NestJS Module Structure

```
backend/src/
├── prisma/          # Prisma service
├── auth/            # JWT, guards, role-based access
├── users/           # User profile, addresses
├── products/        # Products (public read, seller write)
├── categories/      # Categories (public read, admin write)
├── orders/          # Order lifecycle
├── shipments/       # Delivery tracking
├── shops/           # Shop management
├── vouchers/        # Voucher system
├── admin/           # Admin dashboard APIs
└── common/
    ├── guards/      # RolesGuard
    ├── decorators/  # @Roles(), @CurrentUser()
    └── filters/     # Exception filter
```

---

## Flutter Feature Structure

```
lib/features/
├── auth/              # Shared: login, register (role selection)
├── customer/
│   ├── home/          # Homepage, banners, categories
│   ├── product/       # Browse, search, detail
│   ├── cart/          # Shopping cart
│   ├── order/         # Place order, order history, tracking
│   └── review/        # Rate & review
├── seller/
│   ├── dashboard/     # Revenue stats
│   ├── product_mgmt/  # CRUD products
│   ├── order_mgmt/    # Manage orders
│   └── shop/          # Shop profile
├── delivery/
│   ├── shipments/     # Active deliveries
│   ├── history/       # Past deliveries
│   └── profile/       # Availability toggle
└── admin/
    ├── dashboard/     # System stats
    ├── user_mgmt/     # Manage all users
    ├── shop_approval/ # Approve/reject shops
    └── category_mgmt/ # Manage categories
```

---

## Verification Plan

### Backend
```bash
npx prisma generate && npx prisma db push
npm run start:dev
# Test each endpoint with curl/Postman
```

### Flutter
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run
```
