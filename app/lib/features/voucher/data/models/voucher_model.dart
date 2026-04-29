import '../../domain/entities/voucher.dart';

/// Voucher data model — Data Layer
class VoucherModel {
  static Voucher fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'] as String,
      code: json['code'] as String,
      discount: (json['discount'] as num).toDouble(),
      minOrder: (json['minOrder'] as num?)?.toDouble() ?? 0,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }
}
