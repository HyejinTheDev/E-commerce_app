import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../auth/bloc/auth_bloc.dart';
import '../../../../auth/bloc/auth_event.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_bloc_types.dart';

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
                          child: const Icon(Icons.settings_outlined,
                              size: 22, color: AppColors.charcoalInk),
                        ),
                      ],
                    ),
                  ),

                  const CircleAvatar(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.pearlMist,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child:
                        Text('Sửa hồ sơ', style: AppTextStyles.titleSmall),
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
                            onTap: () {}),
                        _MenuItem(
                            icon: Icons.credit_card_outlined,
                            label: 'Phương thức thanh toán',
                            onTap: () {}),
                        _MenuItem(
                            icon: Icons.notifications_none_rounded,
                            label: 'Thông báo',
                            badge: '3 new',
                            onTap: () {}),
                        _MenuItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Trợ giúp & Hỗ trợ',
                            onTap: () {},
                            showDivider: false),
                      ],
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
                            onChanged: (v) => context
                                .read<ProfileBloc>()
                                .add(ProfilePreferenceToggled('darkMode', v))),
                        const Divider(
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
                        const Divider(
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
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.stoneGray),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
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
