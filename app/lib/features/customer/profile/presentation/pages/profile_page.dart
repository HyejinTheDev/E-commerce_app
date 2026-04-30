import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../auth/bloc/auth_bloc.dart';
import '../../../../auth/bloc/auth_event.dart';
import '../../../../auth/bloc/auth_state.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_bloc_types.dart';
import 'address_page.dart';
import 'edit_profile_page.dart';
import '../../../../../main.dart' show themeNotifier;

void _onSellerCenterTap(BuildContext context) async {
  // Check if user is already a seller
  try {
    final dio = getIt<DioClient>().dio;
    final response = await dio.get('/seller/status');
    final data = response.data;

    if (data['isSeller'] == true && context.mounted) {
      // Already a seller → go to seller dashboard
      context.push('/seller');
    } else if (context.mounted) {
      // Not yet → show registration dialog
      _showSellerRegistrationDialog(context);
    }
  } catch (e) {
    if (context.mounted) {
      _showSellerRegistrationDialog(context);
    }
  }
}

void _showSellerRegistrationDialog(BuildContext context) {
  final shopNameCtrl = TextEditingController();
  final shopDescCtrl = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
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
              Text('Bắt đầu bán hàng', style: AppTextStyles.titleLarge),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Mở cửa hàng miễn phí, bắt đầu kinh doanh ngay!',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.stoneGray),
          ),
          const SizedBox(height: 24),
          Text('Tên cửa hàng *',
              style: AppTextStyles.labelMedium
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: shopNameCtrl,
            decoration: InputDecoration(
              hintText: 'VD: Fashion Store ABC',
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
          Text('Mô tả (tuỳ chọn)',
              style: AppTextStyles.labelMedium
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: shopDescCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Chuyên thời trang cao cấp...',
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
              child: Text('Mở cửa hàng',
                  style: AppTextStyles.button
                      .copyWith(color: AppColors.vanillaCream)),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _registerSeller(
    BuildContext context, String shopName, String shopDesc) async {
  if (shopName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vui lòng nhập tên cửa hàng')),
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
    Navigator.pop(context); // close bottom sheet

    // Update auth role in local storage
    context.read<AuthBloc>().add(const AuthCheckRequested());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Mở cửa hàng thành công!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );

    // Navigate to seller dashboard
    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) {
      context.push('/seller');
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

// ─── Delivery Center Functions ───

void _onDeliveryCenterTap(BuildContext context) async {
  try {
    final dio = getIt<DioClient>().dio;
    final response = await dio.get('/delivery/status');
    final data = response.data;

    if (data['isDriver'] == true && context.mounted) {
      context.push('/delivery');
    } else if (context.mounted) {
      _showDeliveryRegistrationDialog(context);
    }
  } catch (e) {
    if (context.mounted) {
      _showDeliveryRegistrationDialog(context);
    }
  }
}

void _showDeliveryRegistrationDialog(BuildContext context) {
  final vehicleCtrl = TextEditingController(text: 'Xe máy');
  final plateCtrl = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
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
              Text('Đăng ký giao hàng', style: AppTextStyles.titleLarge),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Nhận đơn giao hàng, kiếm thu nhập thêm!',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.stoneGray),
          ),
          const SizedBox(height: 24),
          Text('Loại xe *',
              style: AppTextStyles.labelMedium
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: vehicleCtrl,
            decoration: InputDecoration(
              hintText: 'VD: Xe máy, Ô tô',
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
          Text('Biển số xe (tuỳ chọn)',
              style: AppTextStyles.labelMedium
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: plateCtrl,
            decoration: InputDecoration(
              hintText: 'VD: 59A1-12345',
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
              child: Text('Bắt đầu giao hàng',
                  style: AppTextStyles.button.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _registerDriver(
    BuildContext context, String vehicleType, String licensePlate) async {
  if (vehicleType.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vui lòng nhập loại xe')),
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
    Navigator.pop(context); // close bottom sheet

    context.read<AuthBloc>().add(const AuthCheckRequested());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚀 Đăng ký giao hàng thành công!'),
        backgroundColor: Color(0xFF26A69A),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) {
      context.push('/delivery');
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

// ─── Payment Methods Bottom Sheet ───
void _showPaymentMethods(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
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
          Text('Phương thức thanh toán', style: AppTextStyles.titleLarge),
          const SizedBox(height: 20),
          _paymentTile(Icons.money, 'Thanh toán khi nhận hàng (COD)', true),
          _paymentTile(Icons.account_balance_wallet_outlined, 'Ví điện tử', false),
          _paymentTile(Icons.credit_card_outlined, 'Thẻ tín dụng / ghi nợ', false),
          _paymentTile(Icons.account_balance_outlined, 'Chuyển khoản ngân hàng', false),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget _paymentTile(IconData icon, String label, bool isActive) {
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

// ─── Notifications Bottom Sheet ───
void _showNotifications(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
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
            child: Text('Thông báo', style: AppTextStyles.titleLarge),
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

Widget _notifTile(String emoji, String title, String desc, String time) {
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

// ─── Help & Support Bottom Sheet ───
void _showHelp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
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
          Text('Trợ giúp & Hỗ trợ', style: AppTextStyles.titleLarge),
          const SizedBox(height: 20),
          _helpTile(Icons.chat_bubble_outline, 'Chat với hỗ trợ'),
          _helpTile(Icons.email_outlined, 'Gửi email: support@lucent.vn'),
          _helpTile(Icons.phone_outlined, 'Hotline: 1900 1234'),
          _helpTile(Icons.article_outlined, 'Câu hỏi thường gặp'),
          _helpTile(Icons.privacy_tip_outlined, 'Chính sách bảo mật'),
          _helpTile(Icons.description_outlined, 'Điều khoản sử dụng'),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget _helpTile(IconData icon, String label) {
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.isSignedOut) {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go('/login');
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hồ Sơ',
                            style: AppTextStyles.displayLarge
                                .copyWith(fontSize: 28)),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.pearlMist,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.settings_outlined,
                              size: 22, color: AppColors.charcoalInk),
                        ),
                      ],
                    ),
                  ),

                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.pearlMist,
                    child: Icon(Icons.person_outline_rounded,
                        size: 44, color: AppColors.charcoalInk),
                  ),
                  const SizedBox(height: 14),
                  Text(state.name, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(state.email, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(
                            name: state.name,
                            email: state.email,
                          ),
                        ),
                      );
                      if (result == true && context.mounted) {
                        context.read<ProfileBloc>().add(const ProfileLoaded());
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.pearlMist,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child:
                          Text('Sửa hồ sơ', style: AppTextStyles.titleSmall),
                    ),
                  ),

                  // Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Row(
                      children: [
                        _StatCard(
                            count: '${state.orderCount}',
                            label: 'Đơn hàng',
                            icon: Icons.shopping_bag_outlined),
                        const SizedBox(width: 14),
                        _StatCard(
                            count: '${state.addressCount}',
                            label: 'Địa chỉ',
                            icon: Icons.location_on_outlined),
                      ],
                    ),
                  ),

                  // Menu
                  Container(
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
                      children: [
                        _MenuItem(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Đơn hàng của tôi',
                            onTap: () => context.push('/orders')),
                        _MenuItem(
                            icon: Icons.location_on_outlined,
                            label: 'Địa chỉ giao hàng',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddressPage()),
                            )),
                        _MenuItem(
                            icon: Icons.credit_card_outlined,
                            label: 'Phương thức thanh toán',
                            onTap: () => _showPaymentMethods(context)),
                        _MenuItem(
                            icon: Icons.notifications_none_rounded,
                            label: 'Thông báo',
                            onTap: () => _showNotifications(context)),
                        _MenuItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Trợ giúp & Hỗ trợ',
                            onTap: () => _showHelp(context),
                            showDivider: false),
                      ],
                    ),
                  ),

                  // ─── Dịch vụ ───
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Dịch vụ',
                          style: AppTextStyles.titleMedium),
                    ),
                  ),
                  // Kênh Người Bán
                  GestureDetector(
                    onTap: () => _onSellerCenterTap(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.storefront_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kênh Người Bán',
                                    style: AppTextStyles.titleSmall
                                        .copyWith(color: Colors.white)),
                                const SizedBox(height: 3),
                                Text(
                                  'Quản lý cửa hàng & đơn hàng',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: Colors.white54),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Kênh Giao Hàng
                  GestureDetector(
                    onTap: () => _onDeliveryCenterTap(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF00897B), Color(0xFF00695C)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delivery_dining_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kênh Giao Hàng',
                                    style: AppTextStyles.titleSmall
                                        .copyWith(color: Colors.white)),
                                const SizedBox(height: 3),
                                Text(
                                  'Nhận đơn giao & kiếm thu nhập',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: Colors.white54),
                        ],
                      ),
                    ),
                  ),

                  // Preferences
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Tuỳ chỉnh',
                          style: AppTextStyles.titleMedium),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.softWhite,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _ToggleItem(
                            label: 'Chế độ tối',
                            value: state.darkMode,
                            onChanged: (v) {
                              context
                                  .read<ProfileBloc>()
                                  .add(ProfilePreferenceToggled('darkMode', v));
                              themeNotifier.toggleTheme(v);
                            }),
                        Divider(
                            height: 0,
                            indent: 16,
                            endIndent: 16,
                            color: AppColors.pearlMist),
                        _ToggleItem(
                            label: 'Thông báo đẩy',
                            value: state.pushNotifications,
                            onChanged: (v) => context
                                .read<ProfileBloc>()
                                .add(ProfilePreferenceToggled(
                                    'pushNotifications', v))),
                        Divider(
                            height: 0,
                            indent: 16,
                            endIndent: 16,
                            color: AppColors.pearlMist),
                        _ToggleItem(
                            label: 'Cập nhật qua email',
                            value: state.emailUpdates,
                            onChanged: (v) => context
                                .read<ProfileBloc>()
                                .add(ProfilePreferenceToggled(
                                    'emailUpdates', v))),
                      ],
                    ),
                  ),

                  // Sign Out
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: GestureDetector(
                      onTap: () => context
                          .read<ProfileBloc>()
                          .add(const ProfileSignedOut()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.pearlMist,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text('Đăng Xuất',
                            style: AppTextStyles.titleSmall
                                .copyWith(color: AppColors.stoneGray)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
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
  final String count;
  final String label;
  final IconData icon;
  const _StatCard(
      {required this.count, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
          children: [
            Icon(icon, size: 24, color: AppColors.charcoalInk),
            const SizedBox(height: 8),
            Text(count, style: AppTextStyles.titleLarge),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;
  final bool showDivider;
  const _MenuItem(
      {required this.icon,
      required this.label,
      this.badge,
      required this.onTap,
      this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 22, color: AppColors.charcoalInk),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: AppTextStyles.titleSmall)),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.terracottaBlush,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(badge!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.stoneGray),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
              height: 0, indent: 16, endIndent: 16, color: AppColors.pearlMist),
      ],
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleItem(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.titleSmall),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.sageGreen,
            inactiveTrackColor: AppColors.pearlMist,
          ),
        ],
      ),
    );
  }
}
