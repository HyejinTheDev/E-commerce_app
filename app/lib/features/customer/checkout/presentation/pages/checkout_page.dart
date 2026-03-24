import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/pill_button.dart';
import '../../../cart/bloc/cart_bloc.dart';
import '../../../cart/bloc/cart_state.dart';
import '../../bloc/checkout_bloc.dart';
import '../../bloc/checkout_event.dart';
import '../../bloc/checkout_state.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, checkoutState) {
          if (checkoutState.status == CheckoutStatus.success) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: const Icon(Icons.check_circle_rounded,
                    color: AppColors.sageGreen, size: 56),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Order Placed!', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text('Your order has been placed successfully.',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center),
                  ],
                ),
                actions: [
                  Center(
                    child: PillButton(
                      label: 'Continue Shopping',
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, checkoutState) {
          final cartState = context.watch<CartBloc>().state;

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      backgroundColor: AppColors.vanillaCream,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      title: Text('Checkout',
                          style: AppTextStyles.headlineMedium),
                    ),

                    // Step indicator
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Row(
                          children: [
                            _StepDot(label: 'Shipping', isActive: true),
                            Expanded(child: Container(height: 1, color: AppColors.pearlMist)),
                            _StepDot(label: 'Payment', isActive: false),
                            Expanded(child: Container(height: 1, color: AppColors.pearlMist)),
                            _StepDot(label: 'Review', isActive: false),
                          ],
                        ),
                      ),
                    ),

                    // Shipping Address
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                        child: _Section(
                          title: 'Shipping Address',
                          action: 'Change',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(checkoutState.shippingName,
                                  style: AppTextStyles.titleSmall),
                              const SizedBox(height: 4),
                              Text(checkoutState.shippingAddress,
                                  style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Delivery
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 12),
                            _DeliveryOption(
                              title: 'Standard (5-7 days)',
                              price: 'Free',
                              priceColor: AppColors.sageGreen,
                              isSelected: checkoutState.deliveryOption == 0,
                              onTap: () => context.read<CheckoutBloc>().add(
                                  const CheckoutDeliverySelected(0)),
                            ),
                            const SizedBox(height: 10),
                            _DeliveryOption(
                              title: 'Express (2-3 days)',
                              price: '\$12.00',
                              isSelected: checkoutState.deliveryOption == 1,
                              onTap: () => context.read<CheckoutBloc>().add(
                                  const CheckoutDeliverySelected(1)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Payment
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: _Section(
                          title: 'Payment',
                          action: 'Change',
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.pearlMist,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.credit_card_rounded,
                                    size: 20, color: AppColors.charcoalInk),
                              ),
                              const SizedBox(width: 12),
                              Text('•••• ${checkoutState.paymentLast4}',
                                  style: AppTextStyles.titleSmall),
                              const SizedBox(width: 8),
                              Text(checkoutState.paymentBrand,
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Order Total
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.softWhite,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _TotalRow('Subtotal', cartState.formattedSubtotal),
                              const SizedBox(height: 8),
                              _TotalRow('Shipping',
                                  checkoutState.formattedDeliveryCost,
                                  valueColor: checkoutState.deliveryCost == 0
                                      ? AppColors.sageGreen
                                      : null),
                              const SizedBox(height: 8),
                              _TotalRow('Tax', cartState.formattedTax),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Divider(color: AppColors.pearlMist),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total',
                                      style: AppTextStyles.titleMedium),
                                  Text(cartState.formattedTotal,
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

              // Bottom CTA
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
                    label: checkoutState.status == CheckoutStatus.placing
                        ? 'Placing Order...'
                        : 'Place Order — ${cartState.formattedTotal}',
                    isFullWidth: true,
                    onPressed: checkoutState.status == CheckoutStatus.placing
                        ? null
                        : () => context
                            .read<CheckoutBloc>()
                            .add(const CheckoutOrderPlaced()),
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

class _StepDot extends StatelessWidget {
  final String label;
  final bool isActive;
  const _StepDot({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: isActive ? AppColors.charcoalInk : AppColors.pearlMist,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.charcoalInk : AppColors.stoneGray)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? action;
  final Widget child;
  const _Section({required this.title, this.action, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.softWhite, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              if (action != null)
                Text(action!,
                    style: AppTextStyles.titleSmall
                        .copyWith(color: AppColors.warmSand)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  final String title;
  final String price;
  final Color? priceColor;
  final bool isSelected;
  final VoidCallback onTap;
  const _DeliveryOption(
      {required this.title,
      required this.price,
      this.priceColor,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.softWhite,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.charcoalInk, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                size: 22,
                color:
                    isSelected ? AppColors.charcoalInk : AppColors.stoneGray),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppTextStyles.titleSmall)),
            Text(price,
                style: AppTextStyles.titleSmall
                    .copyWith(color: priceColor ?? AppColors.charcoalInk)),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _TotalRow(this.label, this.value, {this.valueColor});

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
