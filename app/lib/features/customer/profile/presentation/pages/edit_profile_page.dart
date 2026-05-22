import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/dio_client.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  bool _isSaving = false;
  bool _isUploading = false;
  String? _avatarUrl;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _phoneCtrl = TextEditingController(text: widget.phone ?? '');
    _avatarUrl = widget.avatar;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      
      if (pickedFile == null) return;
      
      setState(() => _isUploading = true);
      
      final dio = getIt<DioClient>().dio;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          pickedFile.path,
          filename: pickedFile.path.split('/').last,
        ),
      });
      
      final response = await dio.post('/upload/image', data: formData);
      final url = response.data['url'] as String;
      
      setState(() {
        _avatarUrl = url;
        _isUploading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tải ảnh lên thành công! Vui lòng lưu thay đổi.'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tải ảnh thất bại: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.nameRequired)),
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
        if (_avatarUrl != null) 'avatar': _avatarUrl,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.updateSuccess),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context, true); // return true to refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.errorLabel(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      appBar: AppBar(
        title: Text(l.editProfileTitle),
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
              child: GestureDetector(
                onTap: _isUploading ? null : _pickAndUploadImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.pearlMist,
                      backgroundImage: _avatarUrl != null && _avatarUrl!.isNotEmpty ? NetworkImage(_avatarUrl!) : null,
                      child: _avatarUrl == null || _avatarUrl!.isEmpty
                          ? Icon(Icons.person_outline_rounded, size: 50, color: AppColors.charcoalInk)
                          : null,
                    ),
                    if (_isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24, height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            ),
                          ),
                        ),
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
            ),
            const SizedBox(height: 32),

            Text(l.editProfileFullName, style: AppTextStyles.labelMedium
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

            Text(l.phoneLabel, style: AppTextStyles.labelMedium
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
                    : Text(l.saveChanges,
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
