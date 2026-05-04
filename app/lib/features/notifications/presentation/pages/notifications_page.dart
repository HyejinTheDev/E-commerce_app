import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/notifications');
      final data = response.data['data'] as List? ?? [];
      if (mounted) {
        setState(() {
          _notifications = data.map((n) => n as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Notifications error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllRead() async {
    try {
      final dio = getIt<DioClient>().dio;
      await dio.patch('/notifications/read-all');
      _load();
    } catch (_) {}
  }

  Future<void> _markRead(String id) async {
    try {
      final dio = getIt<DioClient>().dio;
      await dio.patch('/notifications/$id/read');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final unreadCount = _notifications.where((n) => n['isRead'] != true).length;

    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      appBar: AppBar(
        backgroundColor: AppColors.vanillaCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l.notificationsTitle, style: AppTextStyles.headlineMedium),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(l.readAll,
                  style: TextStyle(color: AppColors.charcoalInk, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.charcoalInk))
          : _notifications.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) => _buildNotifTile(_notifications[index]),
                  ),
                ),
    );
  }

  Widget _buildEmpty() {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 56, color: AppColors.stoneGray),
          const SizedBox(height: 16),
          Text(l.noNotifications, style: AppTextStyles.titleMedium),
          const SizedBox(height: 6),
          Text(l.noNotificationsDesc,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildNotifTile(Map<String, dynamic> notif) {
    final l = AppLocalizations.of(context)!;
    final isRead = notif['isRead'] == true;
    final type = notif['type'] as String? ?? 'SYSTEM';
    final title = notif['title'] as String? ?? '';
    final body = notif['body'] as String? ?? '';
    final createdAt = DateTime.tryParse(notif['createdAt'] ?? '');
    final notifId = notif['id'] as String;
    final data = notif['data'] as Map<String, dynamic>?;

    String timeStr = '';
    if (createdAt != null) {
      final now = DateTime.now();
      final diff = now.difference(createdAt);
      if (diff.inMinutes < 1) {
        timeStr = l.justNow;
      } else if (diff.inHours < 1) {
        timeStr = l.minutesAgo(diff.inMinutes);
      } else if (diff.inDays < 1) {
        timeStr = l.hoursAgo(diff.inHours);
      } else if (diff.inDays < 7) {
        timeStr = l.daysAgo(diff.inDays);
      } else {
        timeStr = '${createdAt.day}/${createdAt.month}/${createdAt.year}';
      }
    }

    return GestureDetector(
      onTap: () {
        if (!isRead) _markRead(notifId);
        // Navigate to order tracking if it's an order notification
        final orderId = data?['orderId'] as String?;
        if (orderId != null) {
          context.push('/orders/$orderId');
        }
        // Optimistically mark as read in UI
        setState(() => notif['isRead'] = true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? AppColors.softWhite : const Color(0xFFF0EDFF),
          borderRadius: BorderRadius.circular(16),
          border: isRead ? null : Border.all(color: const Color(0xFF5C6BC0).withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: _typeColor(type).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_typeIcon(type), color: _typeColor(type), size: 20),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: isRead ? FontWeight.w500 : FontWeight.w700),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      if (!isRead)
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5C6BC0),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(body,
                      style: AppTextStyles.bodySmall.copyWith(
                          color: isRead ? AppColors.stoneGray : AppColors.charcoalInk),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(timeStr, style: TextStyle(fontSize: 11, color: AppColors.stoneGray)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'ORDER_STATUS': return Icons.local_shipping_rounded;
      case 'CHAT': return Icons.chat_bubble_rounded;
      case 'PROMO': return Icons.local_offer_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'ORDER_STATUS': return const Color(0xFF26A69A);
      case 'CHAT': return const Color(0xFF42A5F5);
      case 'PROMO': return const Color(0xFFFFA726);
      default: return const Color(0xFF5C6BC0);
    }
  }
}
