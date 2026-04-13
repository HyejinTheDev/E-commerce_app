import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../order/domain/entities/order.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/widgets/pill_chip.dart';
import '../../bloc/orders_bloc.dart';
import '../../bloc/orders_event.dart';
import '../../bloc/orders_state.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: SafeArea(
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.charcoalInk),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppColors.vanillaCream,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text('My Orders',
                      style: AppTextStyles.headlineMedium),
                ),

                // Status Tabs
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.tabs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return PillChip(
                            label: state.tabs[index],
                            isSelected: state.selectedTab == index,
                            onTap: () => context
                                .read<OrdersBloc>()
                                .add(OrdersTabChanged(index)),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Order Cards
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  sliver: state.filteredOrders.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.receipt_long_outlined,
                                    size: 48, color: AppColors.stoneGray),
                                const SizedBox(height: 12),
                                Text('No orders found',
                                    style: AppTextStyles.titleMedium),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final order = state.filteredOrders[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: OrderCard(
                                  orderId: 'Order #${order.id}',
                                  date: order.date,
                                  status: order.statusLabel,
                                  deliveryEstimate: order.deliveryEstimate,
                                  totalAmount: order.formattedTotal,
                                  itemCount: order.itemCount,
                                  onTrack: order.status == OrderStatus.shipping
                                      ? () {}
                                      : null,
                                ),
                              );
                            },
                            childCount: state.filteredOrders.length,
                          ),
                        ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }
}
