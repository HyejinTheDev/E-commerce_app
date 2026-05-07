import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoadingCredentials = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final repo = getIt<AuthRepository>();
      final credentials = await repo.getSavedCredentials();
      if (credentials != null && mounted) {
        _emailController.text = credentials['email'] ?? '';
        _passwordController.text = credentials['password'] ?? '';
        setState(() {
          _rememberMe = true;
          _isLoadingCredentials = false;
        });
      } else {
        if (mounted) setState(() => _isLoadingCredentials = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingCredentials = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Save or clear credentials based on toggle
          _handleRememberMe();
          context.go('/home');
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? l.loginFailed),
              backgroundColor: AppColors.terracottaBlush,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.vanillaCream,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Back button
                GestureDetector(
                  onTap: () => context.canPop() ? context.pop() : context.go('/home'),
                  child: Icon(Icons.arrow_back, color: AppColors.charcoalInk),
                ),
                const SizedBox(height: 40),
                // Header
                Text(l.welcomeBack, style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 36,
                  height: 1.2,
                )),
                const SizedBox(height: 8),
                Text(
                  l.loginSubtitle,
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 48),
                // Email field
                _buildLabel(l.email),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hint: 'your@email.com',
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 24),
                // Password field
                _buildLabel(l.password),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hint: '••••••••',
                  obscure: _obscurePassword,
                  icon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.stoneGray,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),

                // ─── Remember Me & Forgot Password ───
                Row(
                  children: [
                    // Remember Me toggle
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _rememberMe
                                  ? AppColors.charcoalInk
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _rememberMe
                                    ? AppColors.charcoalInk
                                    : AppColors.warmSand,
                                width: 1.5,
                              ),
                            ),
                            child: _rememberMe
                                ? Icon(Icons.check,
                                    size: 15,
                                    color: AppColors.vanillaCream)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l.rememberMe,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.charcoalInk,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Forgot Password
                    GestureDetector(
                      onTap: () {
                        context.push('/forgot-password');
                      },
                      child: Text(
                        l.forgotPassword,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.terracottaBlush,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                // Login button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.status == AuthStatus.loading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.charcoalInk,
                          foregroundColor: AppColors.vanillaCream,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.vanillaCream,
                                ),
                              )
                            : Text(l.loginBtn, style: AppTextStyles.button.copyWith(
                                color: AppColors.vanillaCream,
                              )),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Register link
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/register'),
                    child: RichText(
                      text: TextSpan(
                        text: '${l.dontHaveAccount} ',
                        style: AppTextStyles.bodyMedium,
                        children: [
                          TextSpan(
                            text: l.registerBtn,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.terracottaBlush,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: AppTextStyles.labelMedium.copyWith(
      color: AppColors.charcoalInk,
      fontWeight: FontWeight.w600,
    ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.pearlMist),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.charcoalInk),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.warmSand),
          prefixIcon: Icon(icon, color: AppColors.stoneGray, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  void _onLogin() {
    final l = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.fillAllFields)),
      );
      return;
    }

    context.read<AuthBloc>().add(AuthLoginRequested(email, password));
  }

  /// Save or clear credentials after successful login
  Future<void> _handleRememberMe() async {
    try {
      final repo = getIt<AuthRepository>();
      if (_rememberMe) {
        await repo.saveCredentials(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await repo.clearCredentials();
      }
    } catch (_) {
      // Silently ignore storage errors
    }
  }
}
