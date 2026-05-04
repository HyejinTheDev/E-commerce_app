import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../bloc/seller_bloc.dart';
import '../../bloc/seller_event.dart';
import '../../data/datasources/seller_remote_datasource.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '100');

  bool _isLoading = false;
  bool _isUploading = false;

  // Stores local file paths (before upload) and remote URLs (after upload)
  final List<_ProductImage> _images = [];
  List<Map<String, dynamic>> _categories = [];
  String? _selectedCategoryId;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final ds = getIt<SellerRemoteDataSource>();
      final data = await ds.getCategories();
      if (mounted) {
        setState(() {
          _categories =
              data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          if (_categories.isNotEmpty) {
            _selectedCategoryId = _categories.first['id'] as String;
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _salePriceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      appBar: AppBar(
        backgroundColor: AppColors.vanillaCream,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.charcoalInk),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Thêm sản phẩm', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // ─── Product Images ───
            _SectionTitle(title: 'Hình ảnh sản phẩm'),
            const SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._images.asMap().entries.map((entry) {
                    final img = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: img.isLocal
                                ? Image.file(File(img.path),
                                    width: 100, height: 100, fit: BoxFit.cover)
                                : Image.network(img.path,
                                    width: 100, height: 100, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _imgPlaceholder()),
                          ),
                          // Upload indicator
                          if (img.isUploading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24, height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          // Uploaded checkmark
                          if (img.uploadedUrl != null && !img.isUploading)
                            Positioned(
                              bottom: 4, right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, size: 12, color: Colors.white),
                              ),
                            ),
                          // Remove button
                          Positioned(
                            top: 4, right: 4,
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _images.removeAt(entry.key)),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  // Add image button
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.softWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.pearlMist),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isUploading
                                ? Icons.hourglass_top_rounded
                                : Icons.add_photo_alternate_outlined,
                            size: 28,
                            color: AppColors.stoneGray,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isUploading ? 'Đang tải...' : 'Thêm ảnh',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.stoneGray),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${_images.length} ảnh · chạm để thêm',
                  style: TextStyle(fontSize: 12, color: AppColors.stoneGray),
                ),
              ),
            const SizedBox(height: 24),

            // ─── Basic Info ───
            _SectionTitle(title: 'Thông tin cơ bản'),
            const SizedBox(height: 12),
            _buildField(
              controller: _nameCtrl,
              label: 'Tên sản phẩm *',
              hint: 'Áo thun nam cao cấp',
              icon: Icons.label_outline,
              validator: (v) => v == null || v.isEmpty ? 'Bắt buộc' : null,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _descCtrl,
              label: 'Mô tả sản phẩm *',
              hint: 'Chất liệu cotton 100%...',
              icon: Icons.description_outlined,
              maxLines: 3,
              validator: (v) => v == null || v.isEmpty ? 'Bắt buộc' : null,
            ),
            const SizedBox(height: 16),
            // Category dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Danh mục *',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.charcoalInk,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.softWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.pearlMist),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined,
                          color: AppColors.stoneGray, size: 20),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    hint: Text('Chọn danh mục',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.warmSand)),
                    items: _categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat['id'] as String,
                        child: Text(cat['name'] as String? ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCategoryId = value),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Chọn danh mục' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── Pricing ───
            _SectionTitle(title: 'Giá & Kho'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller: _priceCtrl,
                    label: 'Giá gốc (₫) *',
                    hint: '500000',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Bắt buộc';
                      if (double.tryParse(v) == null) return 'Số không hợp lệ';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    controller: _salePriceCtrl,
                    label: 'Giá sale (₫)',
                    hint: '399000',
                    icon: Icons.sell_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _stockCtrl,
              label: 'Số lượng kho *',
              hint: '100',
              icon: Icons.inventory_outlined,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Bắt buộc';
                if (int.tryParse(v) == null) return 'Số không hợp lệ';
                return null;
              },
            ),
            const SizedBox(height: 36),

            // ─── Submit ───
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.charcoalInk,
                  foregroundColor: AppColors.vanillaCream,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.vanillaCream),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.publish_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text('Đăng sản phẩm',
                              style: AppTextStyles.button
                                  .copyWith(color: AppColors.vanillaCream)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build Form Field ───
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.charcoalInk,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.charcoalInk),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.warmSand),
            prefixIcon: Icon(icon, color: AppColors.stoneGray, size: 20),
            filled: true,
            fillColor: AppColors.softWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.pearlMist),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.pearlMist),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  BorderSide(color: AppColors.charcoalInk, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _imgPlaceholder() {
    return Container(
      width: 100, height: 100,
      decoration: BoxDecoration(
        color: AppColors.pearlMist,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.broken_image_outlined, color: AppColors.stoneGray),
    );
  }

  // ─── Image Source Dialog ───
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.softWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
              const Text('Chọn ảnh sản phẩm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C6BC0).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_outlined,
                      color: Color(0xFF5C6BC0)),
                ),
                title: const Text('Thư viện ảnh'),
                subtitle: const Text('Chọn từ bộ sưu tập'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF26A69A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_outlined,
                      color: Color(0xFF26A69A)),
                ),
                title: const Text('Chụp ảnh'),
                subtitle: const Text('Dùng camera để chụp'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF5350).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.link, color: Color(0xFFEF5350)),
                ),
                title: const Text('Nhập URL'),
                subtitle: const Text('Dán đường dẫn ảnh online'),
                onTap: () {
                  Navigator.pop(context);
                  _showUrlDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Pick from gallery/camera ───
  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final pickedFiles = await _picker.pickMultiImage(
          imageQuality: 80,
          maxWidth: 1200,
        );
        if (pickedFiles.isNotEmpty) {
          for (final file in pickedFiles) {
            final img = _ProductImage(path: file.path, isLocal: true);
            setState(() => _images.add(img));
            _uploadImage(img);
          }
        }
      } else {
        final picked = await _picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1200,
        );
        if (picked != null) {
          final img = _ProductImage(path: picked.path, isLocal: true);
          setState(() => _images.add(img));
          _uploadImage(img);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi chọn ảnh: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ─── Upload a single image to server ───
  Future<void> _uploadImage(_ProductImage img) async {
    setState(() {
      img.isUploading = true;
      _isUploading = true;
    });

    try {
      final dio = getIt<DioClient>().dio;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(img.path,
            filename: img.path.split('/').last),
      });
      final response = await dio.post('/upload/image', data: formData);
      final url = response.data['url'] as String;
      setState(() {
        img.uploadedUrl = url;
        img.isUploading = false;
      });
    } catch (e) {
      setState(() => img.isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload thất bại: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      // Check if all done
      if (!_images.any((i) => i.isUploading)) {
        setState(() => _isUploading = false);
      }
    }
  }

  // ─── URL dialog (fallback) ───
  void _showUrlDialog() {
    final urlCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Thêm ảnh từ URL'),
        content: TextField(
          controller: urlCtrl,
          decoration: InputDecoration(
            hintText: 'https://example.com/image.jpg',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final url = urlCtrl.text.trim();
              if (url.isNotEmpty) {
                setState(() => _images.add(
                    _ProductImage(path: url, isLocal: false, uploadedUrl: url)));
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.charcoalInk,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  // ─── Generate Slug ───
  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
  }

  // ─── Submit ───
  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Wait for any pending uploads
    if (_images.any((i) => i.isUploading)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang upload ảnh, vui lòng chờ...'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final slug =
          '${_generateSlug(_nameCtrl.text.trim())}-${DateTime.now().millisecondsSinceEpoch}';
      final imageUrls = _images
          .where((i) => i.uploadedUrl != null)
          .map((i) => i.uploadedUrl!)
          .toList();

      final data = {
        'name': _nameCtrl.text.trim(),
        'slug': slug,
        'description': _descCtrl.text.trim(),
        'price': double.parse(_priceCtrl.text.trim()),
        'stock': int.parse(_stockCtrl.text.trim()),
        'images': imageUrls,
        if (_salePriceCtrl.text.trim().isNotEmpty)
          'salePrice': double.parse(_salePriceCtrl.text.trim()),
        if (_selectedCategoryId != null) 'categoryId': _selectedCategoryId,
      };

      final ds = getIt<SellerRemoteDataSource>();
      await ds.createProduct(data);

      if (!mounted) return;

      // Refresh seller data
      try {
        context.read<SellerBloc>().add(const SellerProductsLoaded());
        context.read<SellerBloc>().add(const SellerDashboardLoaded());
      } catch (_) {}

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Đăng sản phẩm thành công!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// ─── Image model ───
class _ProductImage {
  String path; // local path or remote URL
  bool isLocal;
  bool isUploading;
  String? uploadedUrl; // set after successful upload

  _ProductImage({
    required this.path,
    this.isLocal = false,
    this.isUploading = false,
    this.uploadedUrl,
  });
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.titleLarge.copyWith(fontSize: 18));
  }
}
