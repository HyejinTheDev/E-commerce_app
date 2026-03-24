import '../models/product.dart';
import '../models/category.dart';
import '../models/order.dart';

/// Mock data for UI development — will be replaced by API calls
class MockData {
  MockData._();

  static const List<Product> featuredProducts = [
    Product(
      id: '1',
      name: 'Soft Knit Cardigan',
      brand: 'Maison Lumière',
      price: 89.00,
      originalPrice: 120.00,
      badge: '25% OFF',
      description:
          'Crafted from premium organic cotton, this soft-knit cardigan offers an effortlessly elegant silhouette. Perfect for layering during transitional seasons.',
      rating: 4.8,
      reviewCount: 124,
      category: 'Clothing',
    ),
    Product(
      id: '2',
      name: 'Linen Wide Trousers',
      brand: 'Atelier Blanc',
      price: 65.00,
      description: 'Relaxed-fit wide leg trousers crafted from breathable French linen.',
      rating: 4.5,
      reviewCount: 67,
      category: 'Clothing',
    ),
    Product(
      id: '3',
      name: 'Ceramic Vase',
      brand: 'Terra Home',
      price: 42.00,
      badge: 'NEW',
      description: 'Hand-thrown ceramic vase with organic curves and matte glaze finish.',
      rating: 4.9,
      reviewCount: 31,
      category: 'Home & Living',
    ),
    Product(
      id: '4',
      name: 'Silk Scarf',
      brand: 'Lumière Accessories',
      price: 35.00,
      description: 'Lightweight mulberry silk scarf with hand-rolled edges.',
      rating: 4.6,
      reviewCount: 52,
      category: 'Accessories',
    ),
    Product(
      id: '5',
      name: 'Cashmere Cardigan',
      brand: 'Atelier Blanc',
      price: 145.00,
      description: 'Luxurious cashmere blend cardigan with mother-of-pearl buttons.',
      rating: 4.7,
      reviewCount: 89,
      category: 'Clothing',
    ),
    Product(
      id: '6',
      name: 'Cropped Cardigan',
      brand: 'Luna Studio',
      price: 72.00,
      description: 'Modern cropped silhouette in soft merino wool blend.',
      rating: 4.4,
      reviewCount: 45,
      category: 'Clothing',
    ),
  ];

  static const List<Category> categories = [
    Category(id: '1', name: 'Clothing', iconName: 'checkroom', productCount: 128),
    Category(id: '2', name: 'Shoes', iconName: 'sports_gymnastics', productCount: 64),
    Category(id: '3', name: 'Bags', iconName: 'shopping_bag', productCount: 42),
    Category(id: '4', name: 'Accessories', iconName: 'watch', productCount: 95),
    Category(id: '5', name: 'Home & Living', iconName: 'home', productCount: 73),
    Category(id: '6', name: 'Beauty', iconName: 'face', productCount: 56),
    Category(id: '7', name: 'Electronics', iconName: 'devices', productCount: 38),
    Category(id: '8', name: 'Sports', iconName: 'fitness_center', productCount: 47),
  ];

  static const List<String> categoryFilters = [
    'All',
    'Clothing',
    'Shoes',
    'Accessories',
    'Home',
  ];

  static const List<String> searchFilters = [
    'All',
    'Clothing',
    'Under \$100',
    'Best Rated',
    'New Arrivals',
  ];

  static final List<Order> orders = [
    const Order(
      id: 'LU-2847',
      date: 'Mar 20, 2026',
      status: OrderStatus.shipping,
      totalAmount: 274.05,
      itemCount: 3,
      deliveryEstimate: 'Arriving Mar 25',
    ),
    const Order(
      id: 'LU-2831',
      date: 'Mar 15, 2026',
      status: OrderStatus.processing,
      totalAmount: 130.00,
      itemCount: 2,
      deliveryEstimate: 'Estimated dispatch: Mar 24',
    ),
    const Order(
      id: 'LU-2798',
      date: 'Mar 8, 2026',
      status: OrderStatus.delivered,
      totalAmount: 189.00,
      itemCount: 3,
    ),
    const Order(
      id: 'LU-2756',
      date: 'Feb 28, 2026',
      status: OrderStatus.cancelled,
      totalAmount: 42.00,
      itemCount: 1,
    ),
  ];
}
