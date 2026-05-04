import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/utils/currency_formatter.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;
  const OrderTrackingPage({super.key, required this.orderId});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _order;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    setState(() => _isLoading = true);
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/orders/${widget.orderId}/track');
      if (mounted) setState(() { _order = response.data; _isLoading = false; });
    } catch (e) {
      debugPrint('❌ Track error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.charcoalInk))
          : _order == null
              ? Center(child: Text('Không tìm thấy đơn hàng', style: AppTextStyles.titleMedium))
              : RefreshIndicator(onRefresh: _loadOrder, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    final status = (_order!['status'] as String? ?? 'PENDING').toUpperCase();
    final items = _order!['items'] as List<dynamic>? ?? [];
    final address = _order!['address'] as Map<String, dynamic>?;
    final shipment = _order!['shipment'] as Map<String, dynamic>?;
    final total = double.tryParse(_order!['totalAmount']?.toString() ?? '0') ?? 0;
    final createdAt = DateTime.tryParse(_order!['createdAt'] ?? '');

    return CustomScrollView(
      slivers: [
        // App bar
        SliverAppBar(
          backgroundColor: _statusGradientStart(status),
          foregroundColor: Colors.white,
          expandedHeight: 180,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [_statusGradientStart(status), _statusGradientEnd(status)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Icon(_statusIcon(status), color: Colors.white, size: 40),
                    const SizedBox(height: 12),
                    Text(_statusLabel(status),
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(_statusSubtitle(status),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Order Timeline ───
                _buildTimeline(status, createdAt, shipment),
                const SizedBox(height: 28),

                // ─── Order Items ───
                Text('Sản phẩm', style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                ...items.map((item) => _buildItemCard(item as Map<String, dynamic>)),

                // ─── Delivery Address ───
                if (address != null) ...[
                  const SizedBox(height: 24),
                  Text('Địa chỉ giao hàng', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.softWhite,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: AppColors.terracottaBlush, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${address['name']} · ${address['phone']}', style: AppTextStyles.titleSmall),
                              const SizedBox(height: 3),
                              Text('${address['street']}, ${address['ward']}, ${address['district']}, ${address['city']}',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ─── Shipment Info ───
                if (shipment != null) ...[
                  const SizedBox(height: 24),
                  Text('Thông tin giao hàng', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.softWhite,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF26A69A).withValues(alpha: 0.15),
                          child: const Icon(Icons.delivery_dining_rounded, color: Color(0xFF26A69A), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tài xế đang giao', style: AppTextStyles.titleSmall),
                              Text('Trạng thái: ${_shipmentStatusLabel(shipment['status'])}',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ─── Summary ───
                const SizedBox(height: 24),
                Text('Tóm tắt', style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softWhite,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _summaryRow('Mã đơn', '#${widget.orderId.substring(0, 8)}...'),
                      _summaryRow('Số sản phẩm', '${items.length} sản phẩm'),
                      _summaryRow('Phương thức', _order!['paymentMethod'] ?? 'COD'),
                      const Divider(height: 20),
                      _summaryRow('Tổng cộng', CurrencyFormatter.formatVnd(total), isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Timeline Widget ───
  Widget _buildTimeline(String status, DateTime? createdAt, Map<String, dynamic>? shipment) {
    final steps = [
      _TimelineStep('Đặt hàng', 'Đơn hàng đã được tạo', Icons.receipt_long_rounded, true, createdAt),
      _TimelineStep('Xác nhận', 'Người bán đã xác nhận', Icons.check_circle_rounded,
          _isStepDone(status, 'CONFIRMED'), null),
      _TimelineStep('Đang giao', 'Đang trên đường giao', Icons.local_shipping_rounded,
          _isStepDone(status, 'SHIPPING'), _parseDate(shipment?['createdAt'])),
      _TimelineStep('Hoàn tất', 'Đã giao thành công', Icons.verified_rounded,
          _isStepDone(status, 'DELIVERED'), _parseDate(shipment?['deliveredAt'])),
    ];

    final isCancelled = status == 'CANCELLED';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trạng thái đơn hàng', style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          if (isCancelled)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text('Đơn hàng đã bị huỷ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                ],
              ),
            )
          else
            ...List.generate(steps.length, (i) {
              final step = steps[i];
              final isLast = i == steps.length - 1;
              return _buildTimelineItem(step, isLast);
            }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(_TimelineStep step, bool isLast) {
    final activeColor = step.isDone ? const Color(0xFF26A69A) : AppColors.pearlMist;
    final textColor = step.isDone ? AppColors.charcoalInk : AppColors.stoneGray;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot + Line
        Column(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: step.isDone ? activeColor.withValues(alpha: 0.15) : AppColors.pearlMist,
                shape: BoxShape.circle,
              ),
              child: Icon(step.icon, size: 16, color: step.isDone ? activeColor : AppColors.stoneGray),
            ),
            if (!isLast)
              Container(
                width: 2, height: 36,
                color: step.isDone ? activeColor.withValues(alpha: 0.4) : AppColors.pearlMist,
              ),
          ],
        ),
        const SizedBox(width: 14),
        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: AppTextStyles.titleSmall.copyWith(color: textColor)),
                const SizedBox(height: 2),
                Text(step.subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
                if (step.time != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      '${step.time!.day}/${step.time!.month}/${step.time!.year} ${step.time!.hour}:${step.time!.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 11, color: AppColors.stoneGray),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    final product = item['product'] as Map<String, dynamic>?;
    final qty = item['quantity'] ?? 1;
    final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
    final images = product?['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images[0] as String : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl.startsWith('http')
                ? Image.network(imageUrl, width: 56, height: 56, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder())
                : _imagePlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product?['name'] ?? 'Sản phẩm', style: AppTextStyles.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text('x$qty', style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
              ],
            ),
          ),
          Text(CurrencyFormatter.formatVnd(price * qty), style: AppTextStyles.priceMedium),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(color: AppColors.pearlMist, borderRadius: BorderRadius.circular(10)),
      child: Icon(Icons.image_outlined, color: AppColors.stoneGray, size: 24),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
          Text(value, style: isBold ? AppTextStyles.priceMedium : AppTextStyles.titleSmall),
        ],
      ),
    );
  }

  // ─── Helpers ───
  bool _isStepDone(String status, String step) {
    const order = ['PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPING', 'DELIVERED'];
    final si = order.indexOf(step);
    final ci = order.indexOf(status);
    return ci >= si && si >= 0;
  }

  DateTime? _parseDate(String? s) => s != null ? DateTime.tryParse(s) : null;

  Color _statusGradientStart(String s) {
    switch (s) {
      case 'DELIVERED': return const Color(0xFF26A69A);
      case 'SHIPPING': return const Color(0xFF42A5F5);
      case 'CONFIRMED': case 'PROCESSING': return const Color(0xFFFFA726);
      case 'CANCELLED': return const Color(0xFFEF5350);
      default: return const Color(0xFF5C6BC0);
    }
  }

  Color _statusGradientEnd(String s) {
    switch (s) {
      case 'DELIVERED': return const Color(0xFF00897B);
      case 'SHIPPING': return const Color(0xFF1E88E5);
      case 'CONFIRMED': case 'PROCESSING': return const Color(0xFFF57C00);
      case 'CANCELLED': return const Color(0xFFC62828);
      default: return const Color(0xFF3949AB);
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case 'DELIVERED': return Icons.verified_rounded;
      case 'SHIPPING': return Icons.local_shipping_rounded;
      case 'CONFIRMED': case 'PROCESSING': return Icons.hourglass_top_rounded;
      case 'CANCELLED': return Icons.cancel_rounded;
      default: return Icons.receipt_long_rounded;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'DELIVERED': return 'Đã giao thành công';
      case 'SHIPPING': return 'Đang giao hàng';
      case 'CONFIRMED': return 'Đã xác nhận';
      case 'PROCESSING': return 'Đang xử lý';
      case 'CANCELLED': return 'Đã huỷ';
      default: return 'Chờ xác nhận';
    }
  }

  String _statusSubtitle(String s) {
    switch (s) {
      case 'DELIVERED': return 'Cảm ơn bạn đã mua hàng!';
      case 'SHIPPING': return 'Đơn hàng đang trên đường đến bạn';
      case 'CONFIRMED': return 'Người bán đang chuẩn bị hàng';
      case 'CANCELLED': return 'Đơn hàng đã bị huỷ bỏ';
      default: return 'Đang chờ người bán xác nhận';
    }
  }

  String _shipmentStatusLabel(String? s) {
    switch (s) {
      case 'ASSIGNED': return 'Đã giao cho tài xế';
      case 'PICKING_UP': return 'Đang lấy hàng';
      case 'PICKED_UP': return 'Đã lấy hàng';
      case 'IN_TRANSIT': return 'Đang vận chuyển';
      case 'DELIVERED': return 'Đã giao';
      case 'FAILED': return 'Giao thất bại';
      default: return 'Chưa rõ';
    }
  }
}

class _TimelineStep {
  final String title, subtitle;
  final IconData icon;
  final bool isDone;
  final DateTime? time;
  const _TimelineStep(this.title, this.subtitle, this.icon, this.isDone, this.time);
}
