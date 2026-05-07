import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../bloc/seller_bloc.dart';
import '../../bloc/seller_event.dart';
import '../../data/datasources/seller_remote_datasource.dart';
import '../widgets/product_image_picker.dart';
import '../widgets/product_form_fields.dart';
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
  List<ProductImageModel> _images = [];
  List<Map<String, dynamic>> _categories = [];
  String? _selectedCategoryId;

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
        title: Text(AppLocalizations.of(context)!.addProductTitle, style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // ─── Product Images ───
            SectionTitle(title: AppLocalizations.of(context)!.productImages),
            const SizedBox(height: 8),
            ProductImagePicker(
              initialImages: _images,
              onImagesChanged: (images) {
                setState(() {
                  _images = images;
                });
              },
            ),
            const SizedBox(height: 24),

            // ─── Basic Info ───
            SectionTitle(title: AppLocalizations.of(context)!.basicInfo),
            const SizedBox(height: 12),
            ProductTextField(
              controller: _nameCtrl,
              label: AppLocalizations.of(context)!.productNameLabel,
              hint: AppLocalizations.of(context)!.productNameHint,
              icon: Icons.label_outline,
              validator: (v) => v == null || v.isEmpty ? AppLocalizations.of(context)!.nameRequired : null,
            ),
            const SizedBox(height: 16),
            ProductTextField(
              controller: _descCtrl,
              label: AppLocalizations.of(context)!.productDescLabel,
              hint: AppLocalizations.of(context)!.productDescHint,
              icon: Icons.description_outlined,
              maxLines: 3,
              validator: (v) => v == null || v.isEmpty ? AppLocalizations.of(context)!.nameRequired : null,
            ),
            const SizedBox(height: 16),
            // Category dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.categoryLabel,
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
                    hint: Text(AppLocalizations.of(context)!.selectCategory,
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
                        v == null || v.isEmpty ? AppLocalizations.of(context)!.selectCategory : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── Pricing ───
            SectionTitle(title: AppLocalizations.of(context)!.priceAndStock),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ProductTextField(
                    controller: _priceCtrl,
                    label: AppLocalizations.of(context)!.originalPrice,
                    hint: '500000',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return AppLocalizations.of(context)!.nameRequired;
                      if (double.tryParse(v) == null) return AppLocalizations.of(context)!.invalidNumber;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProductTextField(
                    controller: _salePriceCtrl,
                    label: AppLocalizations.of(context)!.salePrice,
                    hint: '399000',
                    icon: Icons.sell_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ProductTextField(
              controller: _stockCtrl,
              label: AppLocalizations.of(context)!.stockQuantity,
              hint: '100',
              icon: Icons.inventory_outlined,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return AppLocalizations.of(context)!.nameRequired;
                if (int.tryParse(v) == null) return AppLocalizations.of(context)!.invalidNumber;
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
                          Text(AppLocalizations.of(context)!.publishProduct,
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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.waitForUpload),
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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.productPublished),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorLabel(e.toString())), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

