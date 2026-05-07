import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../main.dart' show localeProvider;
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../auth/bloc/auth_bloc.dart';
import '../../../../auth/bloc/auth_event.dart';

class ProfileModals {
  static void onSellerCenterTap(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/seller/status');
      final data = response.data;

      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      if (data['isSeller'] == true && context.mounted) {
        context.push('/seller');
      } else if (context.mounted) {
        showSellerRegistrationDialog(context);
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      final isAuthError = e.toString().contains('401');
      if (context.mounted) {
        if (isAuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.sessionExpired)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.connectionError(e.toString()))),
          );
        }
      }
    }
  }

  static void showSellerRegistrationDialog(BuildContext context) {
    final shopNameCtrl = TextEditingController();
    final shopDescCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.softWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 24, 24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.pearlMist,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.charcoalInk,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.storefront_rounded,
                      color: AppColors.vanillaCream, size: 22),
                ),
                const SizedBox(width: 14),
                Text(AppLocalizations.of(context)!.startSelling, style: AppTextStyles.titleLarge),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.openShopFree,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.stoneGray),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.shopNameLabel,
                style: AppTextStyles.labelMedium
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: shopNameCtrl,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.shopNameHint,
                filled: true,
                fillColor: AppColors.softWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.pearlMist),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.pearlMist),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.descriptionOptional,
                style: AppTextStyles.labelMedium
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: shopDescCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.shopDescHint,
                filled: true,
                fillColor: AppColors.softWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.pearlMist),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.pearlMist),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _registerSeller(
                    context, shopNameCtrl.text.trim(), shopDescCtrl.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.charcoalInk,
                  foregroundColor: AppColors.vanillaCream,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(AppLocalizations.of(context)!.openShop,
                    style: AppTextStyles.button
                        .copyWith(color: AppColors.vanillaCream)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _registerSeller(
      BuildContext context, String shopName, String shopDesc) async {
    if (shopName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.shopNameRequired)),
      );
      return;
    }

    try {
      final dio = getIt<DioClient>().dio;
      await dio.post('/seller/register', data: {
        'shopName': shopName,
        if (shopDesc.isNotEmpty) 'shopDescription': shopDesc,
      });

      if (!context.mounted) return;
      Navigator.pop(context);

      context.read<AuthBloc>().add(const AuthCheckRequested());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.shopCreatedSuccess),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        context.push('/seller');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorLabel(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }

  static void onDeliveryCenterTap(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/delivery/status');
      final data = response.data;

      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      if (data['isDriver'] == true && context.mounted) {
        context.push('/delivery');
      } else if (context.mounted) {
        showDeliveryRegistrationDialog(context);
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      final isAuthError = e.toString().contains('401');
      if (context.mounted) {
        if (isAuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.sessionExpired)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.connectionError(e.toString()))),
          );
        }
      }
    }
  }

  static void showDeliveryRegistrationDialog(BuildContext context) {
    final vehicleCtrl = TextEditingController(text: 'Xe máy');
    final plateCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.softWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 24, 24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.pearlMist,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF26A69A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delivery_dining_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Text(AppLocalizations.of(context)!.registerDelivery, style: AppTextStyles.titleLarge),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.deliveryRegistrationDesc,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.stoneGray),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.vehicleTypeLabel,
                style: AppTextStyles.labelMedium
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: vehicleCtrl,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.vehicleTypeHint,
                filled: true,
                fillColor: AppColors.softWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.pearlMist),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.pearlMist),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.licensePlateOptional,
                style: AppTextStyles.labelMedium
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: plateCtrl,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.licensePlateHint,
                filled: true,
                fillColor: AppColors.softWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.pearlMist),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.pearlMist),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _registerDriver(
                    context, vehicleCtrl.text.trim(), plateCtrl.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(AppLocalizations.of(context)!.startDelivery,
                    style: AppTextStyles.button.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _registerDriver(
      BuildContext context, String vehicleType, String licensePlate) async {
    if (vehicleType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.vehicleRequired)),
      );
      return;
    }

    try {
      final dio = getIt<DioClient>().dio;
      await dio.post('/delivery/register', data: {
        'vehicleType': vehicleType,
        if (licensePlate.isNotEmpty) 'licensePlate': licensePlate,
      });

      if (!context.mounted) return;
      Navigator.pop(context);

      context.read<AuthBloc>().add(const AuthCheckRequested());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.deliveryRegisteredSuccess),
          backgroundColor: const Color(0xFF26A69A),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        context.push('/delivery');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorLabel(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }

  static void showPaymentMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.softWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.pearlMist,
                  borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.paymentMethodsTitle, style: AppTextStyles.titleLarge),
            const SizedBox(height: 20),
            _paymentTile(Icons.money, AppLocalizations.of(context)!.codLabel, true),
            _paymentTile(Icons.account_balance_wallet_outlined, AppLocalizations.of(context)!.ewalletLabel, false),
            _paymentTile(Icons.credit_card_outlined, AppLocalizations.of(context)!.creditCardLabel, false),
            _paymentTile(Icons.account_balance_outlined, AppLocalizations.of(context)!.bankTransferLabel, false),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Widget _paymentTile(IconData icon, String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive ? AppColors.charcoalInk : AppColors.softWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? AppColors.charcoalInk : AppColors.pearlMist),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22,
              color: isActive ? Colors.white : AppColors.charcoalInk),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(
            color: isActive ? Colors.white : AppColors.charcoalInk,
            fontWeight: FontWeight.w500,
          ))),
          if (isActive)
            const Icon(Icons.check_circle, size: 20, color: Color(0xFF4CAF50)),
        ],
      ),
    );
  }

  static void showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.softWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.pearlMist,
                borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(AppLocalizations.of(context)!.notifMenuTitle, style: AppTextStyles.titleLarge),
            ),
            const SizedBox(height: 20),
            _notifTile('🛒', 'Đơn hàng đã xác nhận',
                'Đơn hàng #ABC123 đã được xác nhận', '2 phút trước'),
            _notifTile('🚚', 'Đang giao hàng',
                'Đơn hàng #DEF456 đang trên đường giao', '1 giờ trước'),
            _notifTile('🎉', 'Ưu đãi đặc biệt',
                'Giảm 20% cho đơn hàng tiếp theo!', '3 giờ trước'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Widget _notifTile(String emoji, String title, String desc, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                const SizedBox(height: 2),
                Text(desc, style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(
                    fontSize: 11, color: AppColors.stoneGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.softWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.pearlMist,
                  borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.helpAndSupport, style: AppTextStyles.titleLarge),
            const SizedBox(height: 20),
            _helpTile(Icons.chat_bubble_outline, AppLocalizations.of(context)!.helpChatSupport),
            _helpTile(Icons.email_outlined, AppLocalizations.of(context)!.helpEmail),
            _helpTile(Icons.phone_outlined, AppLocalizations.of(context)!.helpHotline),
            _helpTile(Icons.article_outlined, AppLocalizations.of(context)!.helpFaq),
            _helpTile(Icons.privacy_tip_outlined, AppLocalizations.of(context)!.helpPrivacy),
            _helpTile(Icons.description_outlined, AppLocalizations.of(context)!.helpTerms),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Widget _helpTile(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(icon, color: AppColors.charcoalInk, size: 22),
        title: Text(label, style: AppTextStyles.titleSmall),
        trailing: Icon(Icons.chevron_right, color: AppColors.stoneGray, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: AppColors.softWhite,
        onTap: () {},
      ),
    );
  }
}
