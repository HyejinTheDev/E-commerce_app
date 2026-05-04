import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  bool _isLoading = true;
  List<dynamic> _conversations = [];
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    // Resolve current user ID from token
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    if (token != null) {
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final normalized = base64Url.normalize(payload);
          final decoded = utf8.decode(base64Url.decode(normalized));
          final map = jsonDecode(decoded) as Map<String, dynamic>;
          _currentUserId = map['sub'] as String?;
        }
      } catch (_) {}
    }
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/chat/conversations');
      if (mounted) setState(() { _conversations = response.data as List; _isLoading = false; });
    } catch (e) {
      debugPrint('❌ Chat list error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      appBar: AppBar(
        backgroundColor: AppColors.vanillaCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l.chatTitle, style: AppTextStyles.headlineMedium),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.charcoalInk))
          : _conversations.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _conversations.length,
                    separatorBuilder: (_, __) => Divider(color: AppColors.pearlMist, height: 1),
                    itemBuilder: (context, index) => _buildConversationTile(_conversations[index]),
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
          Icon(Icons.chat_bubble_outline_rounded, size: 56, color: AppColors.stoneGray),
          const SizedBox(height: 16),
          Text(l.chatEmpty, style: AppTextStyles.titleMedium),
          const SizedBox(height: 6),
          Text(l.chatEmptyDesc,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
        ],
      ),
    );
  }

  Widget _buildConversationTile(dynamic conv) {
    final map = conv as Map<String, dynamic>;
    final p1 = map['participant1'] as Map<String, dynamic>?;
    final p2 = map['participant2'] as Map<String, dynamic>?;

    // Determine the other person (not current user)
    Map<String, dynamic>? otherUser;
    if (_currentUserId != null) {
      otherUser = (p1?['id'] == _currentUserId) ? p2 : p1;
    } else {
      otherUser = p1 ?? p2;
    }
    final otherName = otherUser?['name'] as String? ?? 'Người dùng';
    final otherAvatar = otherUser?['avatar'] as String?;
    final lastMsg = map['lastMessage'] as String? ?? 'Bắt đầu trò chuyện';
    final unread = map['unreadCount'] as int? ?? 0;
    final lastAt = map['lastMessageAt'] as String?;
    final convId = map['id'] as String;

    String timeStr = '';
    if (lastAt != null) {
      final dt = DateTime.tryParse(lastAt);
      if (dt != null) {
        final now = DateTime.now();
        final diff = now.difference(dt);
        if (diff.inMinutes < 1) {
          timeStr = 'Vừa xong';
        } else if (diff.inHours < 1) {
          timeStr = '${diff.inMinutes}p';
        } else if (diff.inDays < 1) {
          timeStr = '${diff.inHours}h';
        } else {
          timeStr = '${dt.day}/${dt.month}';
        }
      }
    }

    return InkWell(
      onTap: () => context.push('/chat/$convId'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.warmSand.withValues(alpha: 0.3),
              backgroundImage: otherAvatar != null && otherAvatar.startsWith('http')
                  ? NetworkImage(otherAvatar) : null,
              child: otherAvatar == null || !otherAvatar.startsWith('http')
                  ? Text(otherName[0].toUpperCase(),
                      style: TextStyle(color: AppColors.charcoalInk, fontWeight: FontWeight.w700, fontSize: 18))
                  : null,
            ),
            const SizedBox(width: 14),
            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(otherName,
                            style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: unread > 0 ? FontWeight.w800 : FontWeight.w600),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      if (timeStr.isNotEmpty)
                        Text(timeStr, style: TextStyle(
                            fontSize: 11,
                            color: unread > 0 ? AppColors.charcoalInk : AppColors.stoneGray,
                            fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(lastMsg,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: unread > 0 ? AppColors.charcoalInk : AppColors.stoneGray,
                                fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      if (unread > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF5350),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
