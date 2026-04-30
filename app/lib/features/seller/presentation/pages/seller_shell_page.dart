import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../bloc/seller_bloc.dart';
import '../../bloc/seller_event.dart';
import '../../data/datasources/seller_remote_datasource.dart';
import 'seller_dashboard_page.dart';
import 'seller_products_page.dart';
import 'seller_orders_page.dart';

/// Main seller shell: hosts bottom nav + 3 tab pages sharing one SellerBloc
class SellerShellPage extends StatefulWidget {
  const SellerShellPage({super.key});

  @override
  State<SellerShellPage> createState() => _SellerShellPageState();
}

class _SellerShellPageState extends State<SellerShellPage> {
  int _currentIndex = 0;

  final _pages = const [
    SellerDashboardPage(),
    SellerProductsPage(),
    SellerOrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SellerBloc(getIt<SellerRemoteDataSource>())
        ..add(const SellerDashboardLoaded())
        ..add(const SellerProductsLoaded())
        ..add(const SellerOrdersLoaded()),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE8E2D8),
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Tổng quan',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_rounded),
              label: 'Sản phẩm',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Đơn hàng',
            ),
          ],
        ),
      ),
    );
  }
}
