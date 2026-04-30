import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/network/dio_client.dart';

class DeliveryShellPage extends StatefulWidget {
  const DeliveryShellPage({super.key});

  @override
  State<DeliveryShellPage> createState() => _DeliveryShellPageState();
}

class _DeliveryShellPageState extends State<DeliveryShellPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isAvailable = true;
  Map<String, dynamic> _stats = {};
  Map<String, dynamic> _profile = {};
  List<dynamic> _shipments = [];
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => _isLoading = true);
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/delivery/dashboard');
      final data = response.data;
      if (mounted) {
        setState(() {
          _stats = data['stats'] ?? {};
          _profile = data['profile'] ?? {};
          _isAvailable = _profile['isAvailable'] ?? true;
          _isLoading = false;
        });
      }
      _loadShipments();
      _loadHistory();
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadShipments() async {
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/delivery/shipments');
      if (mounted) {
        setState(() => _shipments = response.data as List<dynamic>);
      }
    } catch (_) {}
  }

  Future<void> _loadHistory() async {
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/delivery/history');
      if (mounted) {
        setState(() => _history = response.data as List<dynamic>);
      }
    } catch (_) {}
  }

  Future<void> _toggleAvailability(bool value) async {
    try {
      final dio = getIt<DioClient>().dio;
      await dio.patch('/delivery/availability', data: {'isAvailable': value});
      setState(() => _isAvailable = value);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboard(),
          _buildShipments(),
          _buildHistory(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE8E2D8),
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Tổng quan',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping_rounded),
            label: 'Đơn giao',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'Lịch sử',
          ),
        ],
      ),
    );
  }

  // ─── Dashboard Tab ───
  Widget _buildDashboard() {
    return SafeArea(
      child: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.charcoalInk))
          : RefreshIndicator(
              color: AppColors.charcoalInk,
              onRefresh: _loadDashboard,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF26A69A),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.delivery_dining_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tài xế', style: AppTextStyles.titleLarge),
                            const SizedBox(height: 2),
                            Text(
                              '${_profile['vehicleType'] ?? 'Xe máy'} · ${_profile['licensePlate'] ?? ''}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded, color: AppColors.stoneGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Availability toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isAvailable
                          ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                          : AppColors.pearlMist,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isAvailable
                            ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
                            : AppColors.pearlMist,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isAvailable ? Icons.check_circle : Icons.pause_circle_outline,
                          color: _isAvailable ? Color(0xFF4CAF50) : AppColors.stoneGray,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isAvailable ? 'Đang nhận đơn' : 'Đã tắt nhận đơn',
                                style: AppTextStyles.titleSmall,
                              ),
                              Text(
                                _isAvailable
                                    ? 'Bạn sẽ nhận được đơn giao mới'
                                    : 'Bật lại để nhận đơn giao',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isAvailable,
                          onChanged: _toggleAvailability,
                          activeColor: const Color(0xFF4CAF50),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    children: [
                      _buildStatCard(
                        Icons.local_shipping_outlined,
                        'Tổng đơn',
                        '${_stats['totalShipments'] ?? 0}',
                        const Color(0xFF5C6BC0),
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        Icons.pending_actions_outlined,
                        'Đang giao',
                        '${_stats['activeShipments'] ?? 0}',
                        const Color(0xFFEF5350),
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        Icons.check_circle_outline,
                        'Hoàn thành',
                        '${_stats['completedShipments'] ?? 0}',
                        const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.softWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.pearlMist),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 12),
            Text(value, style: AppTextStyles.titleLarge.copyWith(fontSize: 22)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  // ─── Shipments Tab ───
  Widget _buildShipments() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Text('Đơn đang giao', style: AppTextStyles.titleLarge),
          ),
          Expanded(
            child: _shipments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            size: 64, color: AppColors.pearlMist),
                        const SizedBox(height: 16),
                        Text('Chưa có đơn giao nào',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.stoneGray)),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadShipments,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _shipments.length,
                      itemBuilder: (context, index) {
                        final shipment = _shipments[index] as Map<String, dynamic>;
                        return _buildShipmentCard(shipment);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ─── History Tab ───
  Widget _buildHistory() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Text('Lịch sử giao hàng', style: AppTextStyles.titleLarge),
          ),
          Expanded(
            child: _history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history_outlined,
                            size: 64, color: AppColors.pearlMist),
                        const SizedBox(height: 16),
                        Text('Chưa có lịch sử',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.stoneGray)),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadHistory,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final shipment = _history[index] as Map<String, dynamic>;
                        return _buildShipmentCard(shipment, isHistory: true);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentCard(Map<String, dynamic> shipment, {bool isHistory = false}) {
    final status = shipment['status'] ?? '';
    final order = shipment['order'] as Map<String, dynamic>? ?? {};
    final customer = order['customer'] as Map<String, dynamic>? ?? {};

    Color statusColor;
    String statusLabel;
    switch (status) {
      case 'ASSIGNED':
        statusColor = const Color(0xFFFFA726);
        statusLabel = 'Được giao';
      case 'PICKING_UP':
        statusColor = const Color(0xFF5C6BC0);
        statusLabel = 'Đang lấy hàng';
      case 'PICKED_UP':
        statusColor = const Color(0xFF26A69A);
        statusLabel = 'Đã lấy hàng';
      case 'IN_TRANSIT':
        statusColor = const Color(0xFF42A5F5);
        statusLabel = 'Đang giao';
      case 'DELIVERED':
        statusColor = const Color(0xFF4CAF50);
        statusLabel = 'Đã giao';
      case 'FAILED':
        statusColor = const Color(0xFFEF5350);
        statusLabel = 'Thất bại';
      default:
        statusColor = AppColors.stoneGray;
        statusLabel = status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.pearlMist),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đơn #${(shipment['id'] as String? ?? '').substring(0, 8)}',
                  style: AppTextStyles.titleSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusLabel,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          if (customer['name'] != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: AppColors.stoneGray),
                const SizedBox(width: 6),
                Text(customer['name'] as String, style: AppTextStyles.bodySmall),
                if (customer['phone'] != null) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.phone_outlined, size: 16, color: AppColors.stoneGray),
                  const SizedBox(width: 4),
                  Text(customer['phone'] as String, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ],
          if (!isHistory && status != 'DELIVERED' && status != 'FAILED') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (status == 'ASSIGNED')
                  _statusButton('Lấy hàng', const Color(0xFF5C6BC0), () =>
                      _updateStatus(shipment['id'], 'PICKING_UP')),
                if (status == 'PICKING_UP')
                  _statusButton('Đã lấy', const Color(0xFF26A69A), () =>
                      _updateStatus(shipment['id'], 'PICKED_UP')),
                if (status == 'PICKED_UP')
                  _statusButton('Đang giao', const Color(0xFF42A5F5), () =>
                      _updateStatus(shipment['id'], 'IN_TRANSIT')),
                if (status == 'IN_TRANSIT') ...[
                  _statusButton('Đã giao', const Color(0xFF4CAF50), () =>
                      _updateStatus(shipment['id'], 'DELIVERED')),
                  const SizedBox(width: 8),
                  _statusButton('Thất bại', const Color(0xFFEF5350), () =>
                      _updateStatus(shipment['id'], 'FAILED')),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusButton(String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Future<void> _updateStatus(String shipmentId, String status) async {
    try {
      final dio = getIt<DioClient>().dio;
      await dio.patch('/delivery/shipments/$shipmentId/status', data: {'status': status});
      _loadShipments();
      _loadHistory();
      _loadDashboard();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
