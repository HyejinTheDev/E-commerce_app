import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/cart_item_card.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        size: 64, color: AppColors.stoneGray),
                    const SizedBox(height: 16),
                    Text('Your cart is empty',
                        style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text('Browse products and add items',
                        style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 24),
                    PillButton(
                      label: 'Start Shopping',
                      onPressed: () => context.go('/home'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      backgroundColor: AppColors.vanillaCream,
                      elevation: 0,
                      title: Text('My Cart',
                          style: AppTextStyles.headlineMedium),
                      actions: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text('${state.itemCount} items',
                                style: AppTextStyles.bodySmall),
                          ),
                        ),
                      ],
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = state.items[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CartItemCard(
                                imageUrl: item.imageUrl,
                                name: item.name,
                                brand: item.brand,
                                price: item.formattedPrice,
                                quantity: item.quantity,
                                onIncrement: () => context
                                    .read<CartBloc>()
                                    .add(CartItemIncremented(item.productId)),
                                onDecrement: () => context
                                    .read<CartBloc>()
                                    .add(CartItemDecremented(item.productId)),
                                onRemove: () => context
                                    .read<CartBloc>()
                                    .add(CartItemRemoved(item.productId)),
                              ),
                            );
                          },
                          childCount: state.items.length,
                        ),
                      ),
                    ),
                    // Order Summary
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.softWhite,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.charcoalInk
                                    .withValues(alpha: 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _SummaryRow('Subtotal', state.formattedSubtotal),
                              const SizedBox(height: 10),
                              _SummaryRow('Shipping', state.formattedShipping,
                                  valueColor: state.shipping == 0
                                      ? AppColors.sageGreen
                                      : null),
                              const SizedBox(height: 10),
                              _SummaryRow('Tax', state.formattedTax),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child:
                                    Divider(color: AppColors.pearlMist),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total',
                                      style: AppTextStyles.titleMedium),
                                  Text(state.formattedTotal,
                                      style: AppTextStyles.priceLarge),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  color: AppColors.softWhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.charcoalInk.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: PillButton(
                    label: 'Proceed to Checkout',
                    isFullWidth: true,
                    onPressed: () => context.push('/checkout'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _SummaryRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value,
            style: AppTextStyles.titleSmall
                .copyWith(color: valueColor ?? AppColors.charcoalInk)),
      ],
    );
  }
}
