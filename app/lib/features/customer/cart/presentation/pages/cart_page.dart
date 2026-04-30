import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/cart_item_card.dart';
import '../../../../../core/widgets/pill_button.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../bloc/cart_state.dart';

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
                    Icon(Icons.shopping_bag_outlined,
                        size: 64, color: AppColors.stoneGray),
                    const SizedBox(height: 16),
                    Text('Giỏ hàng trống',
                        style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text('Duyệt sản phẩm và thêm vào giỏ',
                        style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 24),
                    PillButton(
                      label: 'Mua Sắm Ngay',
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
                      title: Text('Giỏ Hàng',
                          style: AppTextStyles.headlineMedium),
                      actions: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text('${state.itemCount} sản phẩm',
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
                    // ─── Voucher Input ───
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _VoucherSection(state: state),
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
                              _SummaryRow('Tạm tính', state.formattedSubtotal),
                              if (state.appliedVoucher != null) ...[
                                const SizedBox(height: 10),
                                _SummaryRow(
                                  'Giảm giá (${state.appliedVoucher!.code})',
                                  state.formattedDiscount,
                                  valueColor: AppColors.sageGreen,
                                ),
                              ],
                              const SizedBox(height: 10),
                              _SummaryRow('Vận chuyển', state.formattedShipping,
                                  valueColor: state.shipping == 0
                                      ? AppColors.sageGreen
                                      : null),
                              const SizedBox(height: 10),
                              _SummaryRow('Thuế', state.formattedTax),
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
                                  Text('Tổng cộng',
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
                    label: 'Tiến Hành Thanh Toán',
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

class _VoucherSection extends StatefulWidget {
  final CartState state;
  const _VoucherSection({required this.state});

  @override
  State<_VoucherSection> createState() => _VoucherSectionState();
}

class _VoucherSectionState extends State<_VoucherSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasVoucher = widget.state.appliedVoucher != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoalInk.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_outlined,
                  size: 18, color: AppColors.warmSand),
              const SizedBox(width: 8),
              Text('Mã giảm giá', style: AppTextStyles.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          if (hasVoucher)
            // ─── Applied voucher ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.sageGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.sageGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 18, color: AppColors.sageGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.state.appliedVoucher!.code} — Giảm ${widget.state.appliedVoucher!.discount.toStringAsFixed(0)}%',
                      style: AppTextStyles.titleSmall
                          .copyWith(color: AppColors.sageGreen),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<CartBloc>().add(const VoucherRemoved());
                      _controller.clear();
                    },
                    child: Text('Xóa',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.terracottaBlush)),
                  ),
                ],
              ),
            )
          else
            // ─── Input field ───
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Nhập mã giảm giá',
                      hintStyle: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.stoneGray),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: AppColors.vanillaCream,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: AppTextStyles.titleSmall,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: widget.state.voucherLoading
                      ? null
                      : () {
                          final code = _controller.text.trim();
                          if (code.isNotEmpty) {
                            context
                                .read<CartBloc>()
                                .add(VoucherApplied(code));
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.charcoalInk,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.state.voucherLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.softWhite,
                            ),
                          )
                        : Text('Áp dụng',
                            style: AppTextStyles.titleSmall
                                .copyWith(color: AppColors.softWhite)),
                  ),
                ),
              ],
            ),
          // Error message
          if (widget.state.voucherError != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.state.voucherError!,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.terracottaBlush),
            ),
          ],
        ],
      ),
    );
  }
}
