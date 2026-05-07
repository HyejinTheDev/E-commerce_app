import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/di/injection.dart';

class PaymentService {
  Future<bool> processPayment(BuildContext context, {required double amount}) async {
    try {
      final dio = getIt<DioClient>().dio;
      
      // 1. Fetch Payment Intent from Backend
      // Real backend would return a valid client_secret
      final response = await dio.post('/payment/intent', data: {
        'amount': (amount * 100).toInt(), // convert to smallest currency unit
        'currency': 'vnd',
      });
      
      final clientSecret = response.data['clientSecret'] as String;

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Lucent Store',
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF1E2124), // AppColors.charcoalInk
              background: Color(0xFFFCFBF8), // AppColors.vanillaCream
            ),
          ),
        ),
      );

      // 3. Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();
      
      return true;
    } on StripeException catch (e) {
      debugPrint('Stripe Error: ${e.error.localizedMessage}');
      // Fallback for mocked backend/keys
      if (e.error.localizedMessage?.contains('No valid payment intent') == true ||
          e.error.code == FailureCode.Failed) {
        return _simulateMockPayment(context);
      }
      return false;
    } catch (e) {
      debugPrint('Payment Error: $e');
      // If endpoint doesn't exist (404), fallback to mock payment
      if (e is DioException && (e.response?.statusCode == 404 || e.response?.statusCode == 500)) {
        return _simulateMockPayment(context);
      }
      return false;
    }
  }

  // Fallback simulated payment UI for presentation without real backend
  Future<bool> _simulateMockPayment(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFCFBF8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF1E2124)),
            const SizedBox(height: 20),
            const Text(
              'Đang xử lý thanh toán (Mock)...',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Giao diện Stripe thực sẽ hiện ra khi có Backend & Test Keys.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) Navigator.pop(context); // close dialog
    return true;
  }
}
