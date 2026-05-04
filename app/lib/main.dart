import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import 'core/di/injection.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'core/l10n/locale_provider.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/check_auth_usecase.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/customer/cart/bloc/cart_bloc.dart';
import 'features/voucher/domain/usecases/validate_voucher_usecase.dart';

/// Global theme notifier — accessible from anywhere
final themeNotifier = ThemeNotifier();

/// Global locale provider — accessible from anywhere
final localeProvider = LocaleProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await configureDependencies();
  runApp(const LucentApp());
}

class LucentApp extends StatelessWidget {
  const LucentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global AuthBloc — check auth status on startup
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            loginUseCase: getIt<LoginUseCase>(),
            registerUseCase: getIt<RegisterUseCase>(),
            logoutUseCase: getIt<LogoutUseCase>(),
            checkAuthUseCase: getIt<CheckAuthUseCase>(),
            authRepository: getIt<AuthRepository>(),
          )..add(const AuthCheckRequested()),
          lazy: false,
        ),
        // Global CartBloc — shared across all screens
        BlocProvider<CartBloc>(create: (_) => CartBloc(
          validateVoucher: getIt<ValidateVoucherUseCase>(),
        )),
      ],
      // BlocListener bridges AuthBloc → GoRouter redirect
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          AppRouter.authNotifier.update(state);
          // Wire up 401 force-logout
          DioClient.onForceLogout = () {
            context.read<AuthBloc>().add(const AuthLogoutRequested());
          };
        },
        child: ListenableBuilder(
          listenable: Listenable.merge([themeNotifier, localeProvider]),
          builder: (context, _) => MaterialApp.router(
            title: 'Lucent',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeNotifier.themeMode,
            // ─── Localization ───
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('vi'),
              Locale('en'),
            ],
            routerConfig: AppRouter.router,
          ),
        ),
      ),
    );
  }
}
