import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/dio_client.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/users/addresses');
      if (mounted) {
        setState(() {
          _addresses = List<Map<String, dynamic>>.from(response.data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAddress(String id) async {
    try {
      final dio = getIt<DioClient>().dio;
      await dio.delete('/users/addresses/$id');
      _loadAddresses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa địa chỉ'),
              backgroundColor: Color(0xFF4CAF50)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showAddAddress() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final wardCtrl = TextEditingController();
    final districtCtrl = TextEditingController();
    final cityCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
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
              Text('Thêm địa chỉ mới', style: AppTextStyles.titleLarge),
              const SizedBox(height: 20),
              _field('Họ tên', nameCtrl, 'Nguyễn Văn A'),
              _field('Số điện thoại', phoneCtrl, '0123456789'),
              _field('Đường/số nhà', streetCtrl, '123 Đường ABC'),
              _field('Phường/xã', wardCtrl, 'Phường 1'),
              _field('Quận/huyện', districtCtrl, 'Quận 1'),
              _field('Tỉnh/thành phố', cityCtrl, 'TP. Hồ Chí Minh'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _saveAddress(
                    nameCtrl.text.trim(), phoneCtrl.text.trim(),
                    streetCtrl.text.trim(), wardCtrl.text.trim(),
                    districtCtrl.text.trim(), cityCtrl.text.trim(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.charcoalInk,
                    foregroundColor: AppColors.vanillaCream,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Lưu địa chỉ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: AppColors.softWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.pearlMist),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.pearlMist),
          ),
        ),
      ),
    );
  }

  Future<void> _saveAddress(
    String name, String phone, String street,
    String ward, String district, String city,
  ) async {
    if (name.isEmpty || phone.isEmpty || street.isEmpty ||
        ward.isEmpty || district.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    try {
      final dio = getIt<DioClient>().dio;
      await dio.post('/users/addresses', data: {
        'name': name,
        'phone': phone,
        'street': street,
        'ward': ward,
        'district': district,
        'city': city,
      });
      if (!mounted) return;
      Navigator.pop(context);
      _loadAddresses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm địa chỉ'),
            backgroundColor: Color(0xFF4CAF50)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.charcoalInk,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAddress,
        backgroundColor: AppColors.charcoalInk,
        child: Icon(Icons.add, color: AppColors.vanillaCream),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(
              color: AppColors.charcoalInk))
          : _addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_off_outlined,
                          size: 64, color: AppColors.pearlMist),
                      const SizedBox(height: 16),
                      Text('Chưa có địa chỉ nào',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.stoneGray)),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _showAddAddress,
                        child: const Text('+ Thêm địa chỉ'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAddresses,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      final addr = _addresses[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.softWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.pearlMist),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: AppColors.charcoalInk, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(addr['name'] ?? '',
                                          style: AppTextStyles.titleSmall),
                                      const SizedBox(width: 8),
                                      Text(addr['phone'] ?? '',
                                          style: AppTextStyles.bodySmall),
                                      if (addr['isDefault'] == true) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.terracottaBlush,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('Mặc định',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${addr['street']}, ${addr['ward']}, ${addr['district']}, ${addr['city']}',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteAddress(addr['id']),
                              icon: Icon(Icons.delete_outline,
                                  size: 20, color: AppColors.stoneGray),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
