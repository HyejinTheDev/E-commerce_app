import '../../features/product/domain/entities/product.dart';
import '../../features/category/domain/entities/category.dart';
import '../../features/order/domain/entities/order.dart';

/// Dữ liệu giả cho phát triển UI — sẽ được thay bằng API thật
class MockData {
  MockData._();

  static const List<Product> featuredProducts = [
    Product(
      id: '1',
      name: 'Áo Cardigan Len Mềm',
      brand: 'Thời Trang Lumière',
      price: 89.00,
      originalPrice: 120.00,
      badge: 'Giảm 25%',
      description:
          'Được dệt từ cotton hữu cơ cao cấp, chiếc áo cardigan len mềm mang đến phom dáng thanh lịch tự nhiên. Hoàn hảo để phối lớp trong những ngày giao mùa.',
      rating: 4.8,
      reviewCount: 124,
      category: 'Thời trang',
    ),
    Product(
      id: '2',
      name: 'Quần Ống Rộng Linen',
      brand: 'Atelier Blanc',
      price: 65.00,
      description: 'Quần ống rộng dáng thoải mái, may từ vải linen Pháp thoáng mát.',
      rating: 4.5,
      reviewCount: 67,
      category: 'Thời trang',
    ),
    Product(
      id: '3',
      name: 'Bình Gốm Sứ',
      brand: 'Terra Home',
      price: 42.00,
      badge: 'MỚI',
      description: 'Bình gốm thủ công với đường cong tự nhiên và lớp men mờ tinh tế.',
      rating: 4.9,
      reviewCount: 31,
      category: 'Nhà cửa & Đời sống',
    ),
    Product(
      id: '4',
      name: 'Khăn Lụa Tơ Tằm',
      brand: 'Lumière Phụ Kiện',
      price: 35.00,
      description: 'Khăn lụa tơ tằm nhẹ nhàng với viền cuộn tay tinh xảo.',
      rating: 4.6,
      reviewCount: 52,
      category: 'Phụ kiện',
    ),
    Product(
      id: '5',
      name: 'Áo Cardigan Cashmere',
      brand: 'Atelier Blanc',
      price: 145.00,
      description: 'Áo cardigan pha cashmere sang trọng với nút khuy xà cừ.',
      rating: 4.7,
      reviewCount: 89,
      category: 'Thời trang',
    ),
    Product(
      id: '6',
      name: 'Áo Cardigan Croptop',
      brand: 'Luna Studio',
      price: 72.00,
      description: 'Phom dáng croptop hiện đại bằng len merino pha mềm mại.',
      rating: 4.4,
      reviewCount: 45,
      category: 'Thời trang',
    ),
  ];

  static const List<Category> categories = [
    Category(id: '1', name: 'Thời trang', iconName: 'checkroom', productCount: 128),
    Category(id: '2', name: 'Giày dép', iconName: 'sports_gymnastics', productCount: 64),
    Category(id: '3', name: 'Túi xách', iconName: 'shopping_bag', productCount: 42),
    Category(id: '4', name: 'Phụ kiện', iconName: 'watch', productCount: 95),
    Category(id: '5', name: 'Nhà cửa & Đời sống', iconName: 'home', productCount: 73),
    Category(id: '6', name: 'Làm đẹp', iconName: 'face', productCount: 56),
    Category(id: '7', name: 'Điện tử', iconName: 'devices', productCount: 38),
    Category(id: '8', name: 'Thể thao', iconName: 'fitness_center', productCount: 47),
  ];

  static const List<String> categoryFilters = [
    'Tất cả',
    'Thời trang',
    'Giày dép',
    'Phụ kiện',
    'Nhà cửa',
  ];

  static const List<String> searchFilters = [
    'Tất cả',
    'Thời trang',
    'Dưới 100\$',
    'Đánh giá cao',
    'Hàng mới',
  ];

  static final List<Order> orders = [
    const Order(
      id: 'LU-2847',
      date: '20/03/2026',
      status: OrderStatus.shipping,
      totalAmount: 274.05,
      itemCount: 3,
      deliveryEstimate: 'Dự kiến nhận 25/03',
    ),
    const Order(
      id: 'LU-2831',
      date: '15/03/2026',
      status: OrderStatus.processing,
      totalAmount: 130.00,
      itemCount: 2,
      deliveryEstimate: 'Dự kiến gửi hàng: 24/03',
    ),
    const Order(
      id: 'LU-2798',
      date: '08/03/2026',
      status: OrderStatus.delivered,
      totalAmount: 189.00,
      itemCount: 3,
    ),
    const Order(
      id: 'LU-2756',
      date: '28/02/2026',
      status: OrderStatus.cancelled,
      totalAmount: 42.00,
      itemCount: 1,
    ),
  ];
}
