import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/dio_client.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String? phone;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    this.phone,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _phoneCtrl = TextEditingController(text: widget.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tên không được để trống')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final dio = getIt<DioClient>().dio;
      await dio.patch('/users/profile', data: {
        'name': _nameCtrl.text.trim(),
        if (_phoneCtrl.text.trim().isNotEmpty)
          'phone': _phoneCtrl.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thành công!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context, true); // return true to refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      appBar: AppBar(
        title: const Text('Sửa hồ sơ'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.charcoalInk,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.pearlMist,
                    child: Icon(Icons.person_outline_rounded,
                        size: 50, color: AppColors.charcoalInk),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalInk,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.vanillaCream, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_outlined,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('Họ và tên', style: AppTextStyles.labelMedium
                .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildField(_nameCtrl, 'Nguyễn Văn A', Icons.person_outline),
            const SizedBox(height: 20),

            Text('Email', style: AppTextStyles.labelMedium
                .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.pearlMist.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.pearlMist),
              ),
              child: Row(
                children: [
                  Icon(Icons.mail_outline, size: 20, color: AppColors.stoneGray),
                  const SizedBox(width: 12),
                  Text(widget.email,
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.stoneGray)),
                  const Spacer(),
                  Icon(Icons.lock_outline, size: 16, color: AppColors.stoneGray),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('Số điện thoại', style: AppTextStyles.labelMedium
                .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildField(_phoneCtrl, '0123456789', Icons.phone_outlined),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.charcoalInk,
                  foregroundColor: AppColors.vanillaCream,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isSaving
                    ? SizedBox(width: 24, height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.vanillaCream))
                    : Text('Lưu thay đổi',
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.vanillaCream)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.pearlMist),
      ),
      child: TextField(
        controller: ctrl,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.charcoalInk),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.warmSand),
          prefixIcon: Icon(icon, color: AppColors.stoneGray, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
