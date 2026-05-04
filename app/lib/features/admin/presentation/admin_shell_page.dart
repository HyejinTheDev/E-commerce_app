import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/di/injection.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/currency_formatter.dart';

class AdminShellPage extends StatefulWidget {
  const AdminShellPage({super.key});
  @override
  State<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends State<AdminShellPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};
  List<dynamic> _users = [];
  List<dynamic> _shops = [];
  List<dynamic> _drivers = [];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final dio = getIt<DioClient>().dio;
      final results = await Future.wait([
        dio.get('/admin/stats'),
        dio.get('/admin/users'),
        dio.get('/admin/shops'),
        dio.get('/admin/drivers'),
      ]);
      if (mounted) {
        setState(() {
          _stats = results[0].data;
          _users = (results[1].data['data'] as List?) ?? [];
          _shops = results[2].data as List;
          _drivers = results[3].data as List;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Admin load error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/profile'),
        ),
        title: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _loadAll),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Thoát Admin',
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.charcoalInk))
          : IndexedStack(
              index: _currentIndex,
              children: [_buildDashboard(), _buildUsers(), _buildShops(), _buildDrivers()],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: AppColors.softWhite,
        indicatorColor: const Color(0xFF1A1A2E).withValues(alpha: 0.12),
        height: 65,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Tổng quan'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Users'),
          NavigationDestination(icon: Icon(Icons.store_outlined), selectedIcon: Icon(Icons.store), label: 'Shops'),
          NavigationDestination(icon: Icon(Icons.delivery_dining_outlined), selectedIcon: Icon(Icons.delivery_dining), label: 'Drivers'),
        ],
      ),
    );
  }

  // ─── Dashboard ───
  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: _loadAll,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Revenue card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng doanh thu', style: TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 8),
                Text(
                  CurrencyFormatter.formatVnd((_stats['totalRevenue'] as num?)?.toDouble() ?? 0),
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Stats grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _statCard('Người dùng', _stats['totalUsers'] ?? 0, Icons.people_rounded, const Color(0xFF5C6BC0)),
              _statCard('Đơn hàng', _stats['totalOrders'] ?? 0, Icons.receipt_long_rounded, const Color(0xFF26A69A)),
              _statCard('Sản phẩm', _stats['totalProducts'] ?? 0, Icons.inventory_2_rounded, const Color(0xFFFFA726)),
              _statCard('Cửa hàng', _stats['totalShops'] ?? 0, Icons.store_rounded, const Color(0xFFEF5350)),
              _statCard('Tài xế', _stats['totalDrivers'] ?? 0, Icons.delivery_dining_rounded, const Color(0xFF42A5F5)),
              _statCard('Chờ duyệt', _stats['pendingShops'] ?? 0, Icons.pending_actions_rounded, const Color(0xFFFF7043)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Trạng thái đơn hàng', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          ...(_buildOrderStatusBars()),
        ],
      ),
    );
  }

  List<Widget> _buildOrderStatusBars() {
    final ordersByStatus = (_stats['ordersByStatus'] as Map<String, dynamic>?) ?? {};
    final total = (_stats['totalOrders'] as int?) ?? 1;
    final statusNames = {
      'PENDING': ('Chờ xử lý', const Color(0xFFFFA726)),
      'CONFIRMED': ('Đã xác nhận', const Color(0xFF42A5F5)),
      'PROCESSING': ('Đang xử lý', const Color(0xFF5C6BC0)),
      'SHIPPING': ('Đang giao', const Color(0xFF26A69A)),
      'DELIVERED': ('Đã giao', const Color(0xFF66BB6A)),
      'CANCELLED': ('Đã hủy', const Color(0xFFEF5350)),
    };
    return statusNames.entries.map((entry) {
      final count = ordersByStatus[entry.key] ?? 0;
      final pct = total > 0 ? (count as int) / total : 0.0;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.value.$1, style: AppTextStyles.bodySmall),
                Text('$count', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: AppColors.pearlMist,
                valueColor: AlwaysStoppedAnimation(entry.value.$2),
                minHeight: 6,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _statCard(String label, dynamic value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.pearlMist),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text('$value', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800)),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
        ],
      ),
    );
  }

  // ─── Users Tab ───
  Widget _buildUsers() {
    return RefreshIndicator(
      onRefresh: _loadAll,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _users.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Quản lý người dùng (${_users.length})', style: AppTextStyles.titleLarge),
            );
          }
          final user = _users[index - 1] as Map<String, dynamic>;
          final role = user['role'] as String? ?? 'CUSTOMER';
          final roleColor = _roleColor(role);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.pearlMist),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: roleColor.withValues(alpha: 0.15),
                  child: Text((user['name'] as String? ?? '?')[0].toUpperCase(),
                      style: TextStyle(color: roleColor, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['name'] ?? '', style: AppTextStyles.titleSmall),
                      Text(user['email'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(role, style: TextStyle(color: roleColor, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'ADMIN': return const Color(0xFFEF5350);
      case 'SELLER': return const Color(0xFF5C6BC0);
      case 'DELIVERY': return const Color(0xFF26A69A);
      default: return const Color(0xFFFFA726);
    }
  }

  // ─── Shops Tab ───
  Widget _buildShops() {
    return RefreshIndicator(
      onRefresh: _loadAll,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _shops.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Quản lý cửa hàng (${_shops.length})', style: AppTextStyles.titleLarge),
            );
          }
          final shop = _shops[index - 1] as Map<String, dynamic>;
          final status = shop['status'] as String? ?? 'PENDING';
          final seller = shop['seller'] as Map<String, dynamic>?;
          final isPending = status == 'PENDING';
          final statusColor = status == 'APPROVED' ? const Color(0xFF66BB6A) :
                              status == 'REJECTED' ? const Color(0xFFEF5350) : const Color(0xFFFFA726);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.softWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isPending ? const Color(0xFFFFA726).withValues(alpha: 0.4) : AppColors.pearlMist),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.store_rounded, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(shop['name'] ?? '', style: AppTextStyles.titleSmall)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                      child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                if (seller != null) ...[
                  const SizedBox(height: 6),
                  Text('${seller['name']} · ${seller['email']}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
                ],
                if (isPending) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _approveShop(shop['id'], 'REJECTED'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                          child: const Text('Từ chối'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _approveShop(shop['id'], 'APPROVED'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66BB6A),
                            foregroundColor: Colors.white, elevation: 0,
                          ),
                          child: const Text('Duyệt'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _approveShop(String shopId, String status) async {
    try {
      await getIt<DioClient>().dio.patch('/admin/shops/$shopId/approve', data: {'status': status});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(status == 'APPROVED' ? 'Đã duyệt cửa hàng!' : 'Đã từ chối cửa hàng!')),
        );
        _loadAll();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  // ─── Drivers Tab ───
  Widget _buildDrivers() {
    return RefreshIndicator(
      onRefresh: _loadAll,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _drivers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Quản lý tài xế (${_drivers.length})', style: AppTextStyles.titleLarge),
            );
          }
          final driver = _drivers[index - 1] as Map<String, dynamic>;
          final user = driver['user'] as Map<String, dynamic>?;
          final isAvailable = driver['isAvailable'] == true;
          final shipmentCount = driver['_count']?['shipments'] ?? 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.softWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.pearlMist),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isAvailable ? const Color(0xFF66BB6A).withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
                  child: Icon(Icons.delivery_dining, color: isAvailable ? const Color(0xFF66BB6A) : Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?['name'] ?? '', style: AppTextStyles.titleSmall),
                      Text('${driver['vehicleType'] ?? ''} · $shipmentCount đơn',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.stoneGray)),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: isAvailable,
                  activeColor: const Color(0xFF66BB6A),
                  onChanged: (v) => _toggleDriver(driver['id'], v),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _toggleDriver(String driverId, bool isAvailable) async {
    try {
      await getIt<DioClient>().dio.patch('/admin/drivers/$driverId/availability', data: {'isAvailable': isAvailable});
      _loadAll();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }
}
