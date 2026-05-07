import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';

class ProductImageModel {
  String path; // local path or remote URL
  bool isLocal;
  bool isUploading;
  String? uploadedUrl; // set after successful upload

  ProductImageModel({
    required this.path,
    this.isLocal = false,
    this.isUploading = false,
    this.uploadedUrl,
  });
}

class ProductImagePicker extends StatefulWidget {
  final List<ProductImageModel> initialImages;
  final Function(List<ProductImageModel> images) onImagesChanged;

  const ProductImagePicker({
    super.key,
    required this.initialImages,
    required this.onImagesChanged,
  });

  @override
  State<ProductImagePicker> createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  final ImagePicker _picker = ImagePicker();
  late List<ProductImageModel> _images;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
  }

  void _notifyParent() {
    widget.onImagesChanged(_images);
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
            final img = ProductImageModel(path: file.path, isLocal: true);
            setState(() => _images.add(img));
            _notifyParent();
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
          final img = ProductImageModel(path: picked.path, isLocal: true);
          setState(() => _images.add(img));
          _notifyParent();
          _uploadImage(img);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.imagePickError(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ─── Upload a single image to server ───
  Future<void> _uploadImage(ProductImageModel img) async {
    setState(() {
      img.isUploading = true;
      _isUploading = true;
    });
    _notifyParent();

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
          SnackBar(content: Text(AppLocalizations.of(context)!.uploadFailed(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      // Check if all done
      if (!_images.any((i) => i.isUploading)) {
        setState(() => _isUploading = false);
      }
      _notifyParent();
    }
  }

  // ─── URL dialog (fallback) ───
  void _showUrlDialog() {
    final urlCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context)!.addImageFromUrl),
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
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final url = urlCtrl.text.trim();
              if (url.isNotEmpty) {
                setState(() => _images.add(
                    ProductImageModel(path: url, isLocal: false, uploadedUrl: url)));
                _notifyParent();
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.charcoalInk,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(AppLocalizations.of(context)!.addAction),
          ),
        ],
      ),
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
              Text(AppLocalizations.of(context)!.selectProductImage,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                title: Text(AppLocalizations.of(context)!.photoLibrary),
                subtitle: Text(AppLocalizations.of(context)!.chooseFromCollection),
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
                title: Text(AppLocalizations.of(context)!.takePhoto),
                subtitle: Text(AppLocalizations.of(context)!.useCamera),
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
                title: Text(AppLocalizations.of(context)!.enterUrl),
                subtitle: Text(AppLocalizations.of(context)!.pasteImageUrl),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                          onTap: () {
                            setState(() => _images.removeAt(entry.key));
                            _notifyParent();
                          },
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
                        _isUploading ? AppLocalizations.of(context)!.uploading : AppLocalizations.of(context)!.addPhoto,
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
              AppLocalizations.of(context)!.nPhotosHint(_images.length),
              style: TextStyle(fontSize: 12, color: AppColors.stoneGray),
            ),
          ),
      ],
    );
  }
}
