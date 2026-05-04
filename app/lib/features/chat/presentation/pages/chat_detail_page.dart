import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatDetailPage extends StatefulWidget {
  final String conversationId;
  const ChatDetailPage({super.key, required this.conversationId});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _messages = [];
  String? _currentUserId;
  String _otherUserName = 'Chat';
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _initUser();
    _loadMessages();
    // Poll every 3 seconds for new messages
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _loadMessages(silent: true));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initUser() async {
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
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/chat/conversations/${widget.conversationId}/messages');
      final data = (response.data as List).map((m) => m as Map<String, dynamic>).toList();
      if (mounted) {
        final wasAtBottom = _scrollController.hasClients &&
            _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50;
        setState(() {
          _messages = data;
          _isLoading = false;
          // Resolve other user name from messages
          if (_messages.isNotEmpty && _currentUserId != null) {
            for (final m in _messages) {
              final sender = m['sender'] as Map<String, dynamic>?;
              if (sender != null && sender['id'] != _currentUserId) {
                _otherUserName = sender['name'] as String? ?? 'Chat';
                break;
              }
            }
          }
        });
        if (!silent || wasAtBottom) _scrollToBottom();
      }
    } catch (e) {
      debugPrint('❌ Chat messages error: $e');
      if (mounted && !silent) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    try {
      final dio = getIt<DioClient>().dio;
      await dio.post('/chat/conversations/${widget.conversationId}/messages', data: {'content': text});
      _loadMessages(silent: true);
    } catch (e) {
      debugPrint('❌ Send message error: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: AppColors.softWhite,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.warmSand.withValues(alpha: 0.3),
              child: Text(_otherUserName.isNotEmpty ? _otherUserName[0].toUpperCase() : '?',
                  style: TextStyle(color: AppColors.charcoalInk, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_otherUserName, style: AppTextStyles.titleSmall),
                Text('Online', style: TextStyle(fontSize: 11, color: const Color(0xFF26A69A))),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.charcoalInk))
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.waving_hand_rounded, size: 48, color: AppColors.warmSand),
                            const SizedBox(height: 12),
                            Text('Bắt đầu trò chuyện!', style: AppTextStyles.titleMedium),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) => _buildMessage(_messages[index], index),
                      ),
          ),
          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg, int index) {
    final sender = msg['sender'] as Map<String, dynamic>?;
    final isMe = sender?['id'] == _currentUserId;
    final content = msg['content'] as String? ?? '';
    final createdAt = DateTime.tryParse(msg['createdAt'] ?? '');
    final time = createdAt != null
        ? '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}'
        : '';

    // Show date separator
    Widget? dateSeparator;
    if (index == 0 || _isDifferentDay(_messages[index - 1], msg)) {
      final dateStr = createdAt != null
          ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
          : '';
      dateSeparator = Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.stoneGray.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(dateStr, style: TextStyle(fontSize: 11, color: AppColors.stoneGray)),
        ),
      );
    }

    return Column(
      children: [
        if (dateSeparator != null) dateSeparator,
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF1A1A2E) : AppColors.softWhite,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(content, style: TextStyle(
                    color: isMe ? Colors.white : AppColors.charcoalInk, fontSize: 14, height: 1.4)),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(time, style: TextStyle(
                        fontSize: 10,
                        color: isMe ? Colors.white54 : AppColors.stoneGray)),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        msg['isRead'] == true ? Icons.done_all_rounded : Icons.done_rounded,
                        size: 14,
                        color: msg['isRead'] == true ? const Color(0xFF26A69A) : Colors.white54,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isDifferentDay(Map<String, dynamic> prev, Map<String, dynamic> curr) {
    final d1 = DateTime.tryParse(prev['createdAt'] ?? '');
    final d2 = DateTime.tryParse(curr['createdAt'] ?? '');
    if (d1 == null || d2 == null) return false;
    return d1.day != d2.day || d1.month != d2.month || d1.year != d2.year;
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16, right: 8, top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pearlMist,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Nhập tin nhắn...',
                  hintStyle: TextStyle(color: AppColors.stoneGray, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A2E),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
