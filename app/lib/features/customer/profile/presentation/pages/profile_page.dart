import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../main.dart' show localeProvider;
import '../../../../auth/bloc/auth_bloc.dart';
import '../../../../auth/bloc/auth_event.dart';
import '../../../../auth/bloc/auth_state.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_bloc_types.dart';
import 'address_page.dart';
import 'edit_profile_page.dart';
import '../../../../../main.dart' show themeNotifier;

import '../widgets/profile_modals.dart';

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
                        Text(AppLocalizations.of(context)!.profileTitle,
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
                    backgroundImage: state.avatar != null && state.avatar!.isNotEmpty ? NetworkImage(state.avatar!) : null,
                    child: state.avatar == null || state.avatar!.isEmpty ? Icon(Icons.person_outline_rounded,
                        size: 44, color: AppColors.charcoalInk) : null,
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
                            avatar: state.avatar,
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
                          Text(AppLocalizations.of(context)!.editProfileTitle, style: AppTextStyles.titleSmall),
                    ),
                  ),

                  // Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Row(
                      children: [
                        _StatCard(
                            count: '${state.orderCount}',
                            label: AppLocalizations.of(context)!.ordersCount,
                            icon: Icons.shopping_bag_outlined),
                        const SizedBox(width: 14),
                        _StatCard(
                            count: '${state.addressCount}',
                            label: AppLocalizations.of(context)!.addressesCount,
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
                            label: AppLocalizations.of(context)!.myOrders,
                            onTap: () => context.push('/orders')),
                        _MenuItem(
                            icon: Icons.location_on_outlined,
                            label: AppLocalizations.of(context)!.shippingAddresses,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddressPage()),
                            )),
                        _MenuItem(
                            icon: Icons.credit_card_outlined,
                            label: AppLocalizations.of(context)!.paymentMethods2,
                            onTap: () => ProfileModals.showPaymentMethods(context)),
                        _MenuItem(
                            icon: Icons.notifications_none_rounded,
                            label: AppLocalizations.of(context)!.notifMenuTitle,
                            onTap: () => context.push('/notifications')),
                        _MenuItem(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: AppLocalizations.of(context)!.messagesMenu,
                            onTap: () => context.push('/chat')),
                        _MenuItem(
                            icon: Icons.help_outline_rounded,
                            label: AppLocalizations.of(context)!.helpAndSupport,
                            onTap: () => ProfileModals.showHelp(context)),
                        _MenuItem(
                            icon: Icons.language_rounded,
                            label: AppLocalizations.of(context)!.languageMenu,
                            trailing: Text(
                              localeProvider.isVietnamese ? '🇻🇳 Tiếng Việt' : '🇺🇸 English',
                              style: TextStyle(fontSize: 13, color: AppColors.stoneGray),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.softWhite,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40, height: 4,
                                        decoration: BoxDecoration(
                                          color: AppColors.pearlMist,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(AppLocalizations.of(context)!.chooseLanguage,
                                          style: AppTextStyles.titleMedium),
                                      const SizedBox(height: 20),
                                      _LangOption(
                                        flag: '🇻🇳',
                                        label: 'Tiếng Việt',
                                        selected: localeProvider.isVietnamese,
                                        onTap: () {
                                          localeProvider.setLocale(const Locale('vi'));
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      _LangOption(
                                        flag: '🇺🇸',
                                        label: 'English',
                                        selected: !localeProvider.isVietnamese,
                                        onTap: () {
                                          localeProvider.setLocale(const Locale('en'));
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 12),
                                    ],
                                  ),
                                ),
                              );
                            },
                            showDivider: false),
                      ],
                    ),
                  ),

                  // ─── Dịch vụ ───
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppLocalizations.of(context)!.services,
                          style: AppTextStyles.titleMedium),
                    ),
                  ),
                  // Kênh Người Bán
                  GestureDetector(
                    onTap: () => ProfileModals.onSellerCenterTap(context),
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
                                Text(AppLocalizations.of(context)!.sellerChannel,
                                    style: AppTextStyles.titleSmall
                                        .copyWith(color: Colors.white)),
                                const SizedBox(height: 3),
                                Text(
                                  AppLocalizations.of(context)!.sellerChannelDesc,
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
                    onTap: () => ProfileModals.onDeliveryCenterTap(context),
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
                                Text(AppLocalizations.of(context)!.deliveryChannel,
                                    style: AppTextStyles.titleSmall
                                        .copyWith(color: Colors.white)),
                                const SizedBox(height: 3),
                                Text(
                                  AppLocalizations.of(context)!.deliveryChannelDesc,
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

                  // Admin Panel — only visible for ADMIN role
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      debugPrint('🔑 Admin check: userRole=${authState.userRole}');
                      if (authState.userRole != 'ADMIN') return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: GestureDetector(
                          onTap: () => context.push('/admin'),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
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
                                  child: const Icon(Icons.admin_panel_settings_rounded,
                                      color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Admin Panel',
                                          style: AppTextStyles.titleSmall
                                              .copyWith(color: Colors.white)),
                                      const SizedBox(height: 3),
                                      Text(
                                        AppLocalizations.of(context)!.adminPanelDesc,
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
                      );
                    },
                  ),

                  // Preferences
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppLocalizations.of(context)!.preferences,
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
                            label: AppLocalizations.of(context)!.darkModeToggle,
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
                            label: AppLocalizations.of(context)!.pushNotifToggle,
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
                            label: AppLocalizations.of(context)!.emailUpdatesToggle,
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
                        child: Text(AppLocalizations.of(context)!.signOut,
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
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showDivider;
  const _MenuItem(
      {required this.icon,
      required this.label,
      this.trailing,
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
                if (trailing != null) trailing!,
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

class _LangOption extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangOption({required this.flag, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0EDFF) : AppColors.pearlMist,
          borderRadius: BorderRadius.circular(16),
          border: selected ? Border.all(color: const Color(0xFF5C6BC0), width: 1.5) : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.titleSmall)),
            if (selected) Icon(Icons.check_circle_rounded, color: const Color(0xFF5C6BC0), size: 22),
          ],
        ),
      ),
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
            activeTrackColor: AppColors.sageGreen,
            inactiveTrackColor: AppColors.pearlMist,
          ),
        ],
      ),
    );
  }
}
