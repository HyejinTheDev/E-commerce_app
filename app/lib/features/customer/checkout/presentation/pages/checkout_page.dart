import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/pill_button.dart';
import '../../../cart/bloc/cart_bloc.dart';
import '../../../cart/bloc/cart_event.dart';
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
            // Clear the cart after successful order
            context.read<CartBloc>().add(const CartCleared());

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: const Icon(Icons.check_circle_rounded,
                    color: AppColors.sageGreen, size: 56),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Đặt hàng thành công!', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text('Đơn hàng của bạn đã được đặt thành công.',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center),
                  ],
                ),
                actions: [
                  Center(
                    child: PillButton(
                      label: 'Tiếp Tục Mua Sắm',
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (checkoutState.status == CheckoutStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(checkoutState.errorMessage ?? 'Đặt hàng thất bại. Vui lòng thử lại.'),
                backgroundColor: Colors.red.shade400,
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
                      title: Text('Thanh Toán',
                          style: AppTextStyles.headlineMedium),
                    ),

                    // Step indicator
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Row(
                          children: [
                            _StepDot(label: 'Giao hàng', isActive: true),
                            Expanded(child: Container(height: 1, color: AppColors.pearlMist)),
                            _StepDot(label: 'Thanh toán', isActive: false),
                            Expanded(child: Container(height: 1, color: AppColors.pearlMist)),
                            _StepDot(label: 'Xác nhận', isActive: false),
                          ],
                        ),
                      ),
                    ),

                    // Shipping Address
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                        child: _Section(
                          title: 'Địa Chỉ Giao Hàng',
                          action: 'Thay đổi',
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
                            Text('Giao hàng', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 12),
                            _DeliveryOption(
                              title: 'Tiêu chuẩn (5-7 ngày)',
                              price: 'Miễn phí',
                              priceColor: AppColors.sageGreen,
                              isSelected: checkoutState.deliveryOption == 0,
                              onTap: () => context.read<CheckoutBloc>().add(
                                  const CheckoutDeliverySelected(0)),
                            ),
                            const SizedBox(height: 10),
                            _DeliveryOption(
                              title: 'Nhanh (2-3 ngày)',
                              price: '300.000₫',
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
                          title: 'Thanh toán',
                          action: 'Thay đổi',
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
                              _TotalRow('Tạm tính', cartState.formattedSubtotal),
                              const SizedBox(height: 8),
                              _TotalRow('Vận chuyển',
                                  checkoutState.formattedDeliveryCost,
                                  valueColor: checkoutState.deliveryCost == 0
                                      ? AppColors.sageGreen
                                      : null),
                              const SizedBox(height: 8),
                              _TotalRow('Thuế', cartState.formattedTax),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Divider(color: AppColors.pearlMist),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tổng cộng',
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
                        ? 'Đang đặt hàng...'
                        : 'Đặt Hàng — ${cartState.formattedTotal}',
                    isFullWidth: true,
                    onPressed: checkoutState.status == CheckoutStatus.placing
                        ? null
                        : () {
                            final cartItems = context.read<CartBloc>().state.items
                                .map((item) => {
                                      'productId': item.productId,
                                      'quantity': item.quantity,
                                    })
                                .toList();
                            context
                                .read<CheckoutBloc>()
                                .add(CheckoutOrderPlaced(items: cartItems));
                          },
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
