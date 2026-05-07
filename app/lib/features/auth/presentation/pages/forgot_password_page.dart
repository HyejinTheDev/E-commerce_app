import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.fillAllFields)), // Reuse fillAllFields
      );
      return;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.invalidEmail)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = getIt<AuthRepository>();
      await repo.forgotPassword(email);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.resetLinkSent),
          backgroundColor: AppColors.sageGreen,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.error),
          backgroundColor: AppColors.terracottaBlush,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.vanillaCream,
      appBar: AppBar(
        backgroundColor: AppColors.vanillaCream,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.charcoalInk),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                l.forgotPasswordTitle,
                style: AppTextStyles.displayLarge.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 12),
              Text(
                l.forgotPasswordDesc,
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 48),
              
              Text(l.email, style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.charcoalInk,
                fontWeight: FontWeight.w600,
              )),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.softWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.pearlMist),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.charcoalInk),
                  decoration: InputDecoration(
                    hintText: 'your@email.com',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.warmSand),
                    prefixIcon: Icon(Icons.mail_outline, color: AppColors.stoneGray, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
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
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.vanillaCream,
                          ),
                        )
                      : Text(l.sendResetLink, style: AppTextStyles.button.copyWith(
                          color: AppColors.vanillaCream,
                        )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
