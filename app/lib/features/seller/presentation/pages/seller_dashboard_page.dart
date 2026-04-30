import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_event.dart';
import '../../bloc/seller_bloc.dart';
import '../../bloc/seller_event.dart';
import '../../bloc/seller_state.dart';
import 'add_product_page.dart';

class SellerDashboardPage extends StatelessWidget {
  const SellerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: SafeArea(
        child: BlocBuilder<SellerBloc, SellerState>(
          builder: (context, state) {
            if (state.status == SellerStatus.loading && state.shopName == null) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.charcoalInk),
              );
            }

            return RefreshIndicator(
              color: AppColors.charcoalInk,
              onRefresh: () async {
                context.read<SellerBloc>().add(const SellerDashboardLoaded());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ─── Header ───
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.charcoalInk,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.storefront_rounded,
                            color: AppColors.vanillaCream, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.shopName ?? 'Cửa hàng',
                                style: AppTextStyles.titleLarge),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: state.shopStatus == 'APPROVED'
                                    ? const Color(0xFF4CAF50)
                                    : AppColors.warmSand,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                state.shopStatus == 'APPROVED'
                                    ? 'Đang hoạt động'
                                    : 'Chờ duyệt',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthLogoutRequested());
                        },
                        icon: Icon(Icons.logout_rounded,
                            color: AppColors.stoneGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ─── Revenue Card ───
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tổng doanh thu',
                            style: TextStyle(
                                color: Color(0xFFAAAAAA), fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.formatVnd(state.totalRevenue),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── Stats Grid ───
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.inventory_2_outlined,
                        label: 'Sản phẩm',
                        value: '${state.totalProducts}',
                        color: const Color(0xFF5C6BC0),
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.receipt_long_outlined,
                        label: 'Đơn hàng',
                        value: '${state.totalOrders}',
                        color: const Color(0xFF26A69A),
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.pending_actions_outlined,
                        label: 'Chờ xử lý',
                        value: '${state.pendingOrders}',
                        color: const Color(0xFFEF5350),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ─── Quick Actions ───
                  Text('Quản lý', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 16),
                  _ActionTile(
                    icon: Icons.add_box_outlined,
                    title: 'Thêm sản phẩm mới',
                    subtitle: 'Đăng bán sản phẩm lên cửa hàng',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<SellerBloc>(),
                            child: const AddProductPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.softWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.pearlMist),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 12),
            Text(value,
                style: AppTextStyles.titleLarge.copyWith(fontSize: 22)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.softWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.pearlMist),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.charcoalInk.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.charcoalInk, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.stoneGray),
          ],
        ),
      ),
    );
  }
}
