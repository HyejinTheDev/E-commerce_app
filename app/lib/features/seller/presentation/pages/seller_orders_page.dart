import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../bloc/seller_bloc.dart';
import '../../bloc/seller_event.dart';
import '../../bloc/seller_state.dart';

class SellerOrdersPage extends StatelessWidget {
  const SellerOrdersPage({super.key});

  static const _statusMap = {
    'PENDING': ('Chờ xác nhận', Color(0xFFFFA726)),
    'CONFIRMED': ('Đã xác nhận', Color(0xFF42A5F5)),
    'PROCESSING': ('Đang xử lý', Color(0xFF5C6BC0)),
    'SHIPPING': ('Đang giao', Color(0xFF26A69A)),
    'DELIVERED': ('Đã giao', Color(0xFF66BB6A)),
    'CANCELLED': ('Đã hủy', Color(0xFFEF5350)),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: SafeArea(
        child: BlocBuilder<SellerBloc, SellerState>(
          builder: (context, state) {
            if (state.status == SellerStatus.loading && state.orders.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.charcoalInk),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Text('Đơn hàng',
                      style: AppTextStyles.displayLarge.copyWith(fontSize: 28)),
                ),
                Expanded(
                  child: state.orders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  size: 64,
                                  color: AppColors.stoneGray.withValues(alpha: 0.4)),
                              const SizedBox(height: 16),
                              Text('Chưa có đơn hàng',
                                  style: AppTextStyles.titleSmall
                                      .copyWith(color: AppColors.stoneGray)),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.charcoalInk,
                          onRefresh: () async {
                            context.read<SellerBloc>().add(const SellerOrdersLoaded());
                            await Future.delayed(const Duration(milliseconds: 500));
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: state.orders.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final order = state.orders[index];
                              return _OrderCard(order: order);
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String? ?? 'PENDING';
    final statusInfo = SellerOrdersPage._statusMap[status] ??
        ('Không rõ', AppColors.stoneGray);
    final totalAmount =
        double.tryParse(order['totalAmount']?.toString() ?? '0') ?? 0;
    final items = (order['items'] as List<dynamic>?) ?? [];
    final customer = order['customer'] as Map<String, dynamic>?;
    final orderId = (order['id'] as String?) ?? '';
    final shortId = orderId.length > 8 ? orderId.substring(0, 8) : orderId;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.pearlMist),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text('#$shortId',
                  style: AppTextStyles.titleSmall.copyWith(
                      fontFamily: 'monospace', fontSize: 13)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusInfo.$2.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusInfo.$1,
                    style: TextStyle(
                        color: statusInfo.$2,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          if (customer != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: AppColors.stoneGray),
                const SizedBox(width: 6),
                Text(customer['name'] as String? ?? 'Khách',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text('${items.length} sản phẩm · ${CurrencyFormatter.formatVnd(totalAmount)}',
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          // Actions for PENDING orders
          if (status == 'PENDING') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<SellerBloc>().add(
                          SellerOrderStatusUpdated(orderId, 'CANCELLED'));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Từ chối'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<SellerBloc>().add(
                          SellerOrderStatusUpdated(orderId, 'CONFIRMED'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.charcoalInk,
                      foregroundColor: AppColors.vanillaCream,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Xác nhận'),
                  ),
                ),
              ],
            ),
          ],
          if (status == 'CONFIRMED') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<SellerBloc>().add(
                      SellerOrderStatusUpdated(orderId, 'SHIPPING'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Giao hàng'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
