const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Đang khởi tạo dữ liệu...');

  // Create test user
  const hashedPassword = await bcrypt.hash('password123', 10);
  const customer = await prisma.user.upsert({
    where: { email: 'customer@test.com' },
    update: {},
    create: {
      email: 'customer@test.com',
      password: hashedPassword,
      name: 'Nguyễn Thị Mai',
      phone: '0912345678',
      role: 'CUSTOMER',
    },
  });
  console.log('✅ Khách hàng đã tạo:', customer.email);

  // Create seller
  const seller = await prisma.user.upsert({
    where: { email: 'seller@test.com' },
    update: {},
    create: {
      email: 'seller@test.com',
      password: hashedPassword,
      name: 'Cửa hàng Lucent',
      role: 'SELLER',
    },
  });

  // Create shop
  const shop = await prisma.shop.upsert({
    where: { sellerId: seller.id },
    update: {
      name: 'Thời Trang Lumière',
      description: 'Thời trang & phong cách sống cao cấp',
    },
    create: {
      sellerId: seller.id,
      name: 'Thời Trang Lumière',
      description: 'Thời trang & phong cách sống cao cấp',
      status: 'APPROVED',
      rating: 4.8,
    },
  });
  console.log('✅ Cửa hàng đã tạo:', shop.name);

  // Create categories
  const categoriesData = [
    { name: 'Thời trang', slug: 'clothing' },
    { name: 'Giày dép', slug: 'shoes' },
    { name: 'Túi xách', slug: 'bags' },
    { name: 'Phụ kiện', slug: 'accessories' },
    { name: 'Nhà cửa & Đời sống', slug: 'home-living' },
    { name: 'Làm đẹp', slug: 'beauty' },
    { name: 'Điện tử', slug: 'electronics' },
    { name: 'Thể thao', slug: 'sports' },
  ];

  const categories = {};
  for (const cat of categoriesData) {
    const created = await prisma.category.upsert({
      where: { slug: cat.slug },
      update: { name: cat.name },
      create: cat,
    });
    categories[cat.name] = created;
  }
  console.log('✅ Danh mục đã tạo:', Object.keys(categories).length);

  // Create products
  const productsData = [
    {
      name: 'Áo Cardigan Len Mềm',
      slug: 'soft-knit-cardigan',
      description: 'Được dệt từ cotton hữu cơ cao cấp, chiếc áo cardigan len mềm mang đến phom dáng thanh lịch tự nhiên. Hoàn hảo để phối lớp trong những ngày giao mùa.',
      price: 120.00,
      salePrice: 89.00,
      stock: 50,
      images: ['https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=400'],
      categoryName: 'Thời trang',
    },
    {
      name: 'Quần Ống Rộng Linen',
      slug: 'linen-wide-trousers',
      description: 'Quần ống rộng dáng thoải mái, may từ vải linen Pháp thoáng mát.',
      price: 65.00,
      stock: 35,
      images: ['https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400'],
      categoryName: 'Thời trang',
    },
    {
      name: 'Bình Gốm Sứ',
      slug: 'ceramic-vase',
      description: 'Bình gốm thủ công với đường cong tự nhiên và lớp men mờ tinh tế.',
      price: 42.00,
      stock: 20,
      images: ['https://images.unsplash.com/photo-1578500494198-246f612d3b3d?w=400'],
      categoryName: 'Nhà cửa & Đời sống',
    },
    {
      name: 'Khăn Lụa Tơ Tằm',
      slug: 'silk-scarf',
      description: 'Khăn lụa tơ tằm nhẹ nhàng với viền cuộn tay tinh xảo.',
      price: 35.00,
      stock: 40,
      images: ['https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400'],
      categoryName: 'Phụ kiện',
    },
    {
      name: 'Áo Cardigan Cashmere',
      slug: 'cashmere-cardigan',
      description: 'Áo cardigan pha cashmere sang trọng với nút khuy xà cừ.',
      price: 145.00,
      stock: 15,
      images: ['https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400'],
      categoryName: 'Thời trang',
    },
    {
      name: 'Áo Cardigan Croptop',
      slug: 'cropped-cardigan',
      description: 'Phom dáng croptop hiện đại bằng len merino pha mềm mại.',
      price: 72.00,
      stock: 25,
      images: ['https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=400'],
      categoryName: 'Thời trang',
    },
    {
      name: 'Túi Tote Vải Canvas',
      slug: 'canvas-tote-bag',
      description: 'Túi tote canvas tối giản với quai da và phụ kiện đồng thau.',
      price: 58.00,
      stock: 30,
      images: ['https://images.unsplash.com/photo-1544816155-12df9643f363?w=400'],
      categoryName: 'Túi xách',
    },
    {
      name: 'Giày Chạy Bộ Pro',
      slug: 'running-shoes-pro',
      description: 'Giày chạy bộ siêu nhẹ với đệm đàn hồi cao.',
      price: 129.00,
      salePrice: 99.00,
      stock: 45,
      images: ['https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400'],
      categoryName: 'Giày dép',
    },
    {
      name: 'Tai Nghe Không Dây',
      slug: 'wireless-earbuds',
      description: 'Tai nghe không dây cao cấp với chống ồn chủ động và pin 24 giờ.',
      price: 89.00,
      stock: 60,
      images: ['https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400'],
      categoryName: 'Điện tử',
    },
    {
      name: 'Thảm Yoga Cao Cấp',
      slug: 'yoga-mat-premium',
      description: 'Thảm yoga cao su tự nhiên chống trượt với đường canh chỉnh.',
      price: 55.00,
      stock: 25,
      images: ['https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400'],
      categoryName: 'Thể thao',
    },
  ];

  let productCount = 0;
  for (const p of productsData) {
    const { categoryName, ...productData } = p;
    await prisma.product.upsert({
      where: { slug: productData.slug },
      update: {
        name: productData.name,
        description: productData.description,
        images: productData.images,
      },
      create: {
        ...productData,
        shopId: shop.id,
        categoryId: categories[categoryName].id,
      },
    });
    productCount++;
  }
  console.log('✅ Sản phẩm đã tạo:', productCount);

  // Create address for customer
  const existingAddr = await prisma.address.findFirst({
    where: { userId: customer.id, isDefault: true },
  });
  if (!existingAddr) {
    await prisma.address.create({
      data: {
        userId: customer.id,
        name: 'Nguyễn Thị Mai',
        phone: '0912345678',
        street: '123 Nguyễn Huệ',
        ward: 'Phường Bến Nghé',
        district: 'Quận 1',
        city: 'TP. Hồ Chí Minh',
        isDefault: true,
      },
    });
  }
  console.log('✅ Địa chỉ đã tạo');

  // Create vouchers
  const vouchersData = [
    {
      code: 'GIAM10',
      discount: 10,
      minOrder: 50,
      maxUses: 100,
      expiresAt: new Date('2027-12-31'),
    },
    {
      code: 'GIAM50K',
      discount: 2,
      minOrder: 30,
      maxUses: 50,
      expiresAt: new Date('2027-12-31'),
    },
    {
      code: 'FREESHIP',
      discount: 0.5,
      minOrder: 0,
      maxUses: 200,
      expiresAt: new Date('2027-12-31'),
    },
  ];

  for (const v of vouchersData) {
    await prisma.voucher.upsert({
      where: { code: v.code },
      update: {},
      create: {
        ...v,
        shopId: shop.id,
      },
    });
  }
  console.log('✅ Voucher đã tạo:', vouchersData.length);

  console.log('\n🎉 Khởi tạo dữ liệu hoàn tất!');
  console.log('📧 Đăng nhập test: customer@test.com / password123');
  console.log('🎫 Voucher test: GIAM10 | GIAM50K | FREESHIP');
}

main()
  .catch((e) => {
    console.error('❌ Khởi tạo thất bại:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
