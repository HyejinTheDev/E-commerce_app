import 'package:dio/dio.dart';

class ErrorMapper {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Kết nối máy chủ hết hạn. Vui lòng kiểm tra lại mạng.';
        case DioExceptionType.connectionError:
          return 'Không thể kết nối đến máy chủ. Vui lòng thử lại.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final data = error.response?.data;
          
          // Ưu tiên trả về message từ backend nếu có
          if (data is Map<String, dynamic> && data['message'] != null) {
            return data['message'].toString();
          }
          
          switch (statusCode) {
            case 400: return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.';
            case 401: return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
            case 403: return 'Bạn không có quyền thực hiện thao tác này.';
            case 404: return 'Không tìm thấy dữ liệu yêu cầu.';
            case 500: return 'Máy chủ đang gặp sự cố. Vui lòng thử lại sau.';
            case 502: return 'Lỗi cổng kết nối (Bad Gateway).';
            case 503: return 'Hệ thống đang bảo trì. Vui lòng quay lại sau.';
            default: return 'Xảy ra lỗi hệ thống (Mã lỗi: $statusCode).';
          }
        default:
          return 'Đã xảy ra lỗi đường truyền kết nối. Vui lòng thử lại.';
      }
    }
    
    if (error is Exception) {
      final msg = error.toString();
      // Remove generic 'Exception: ' prefix if present
      if (msg.startsWith('Exception: ')) {
        return msg.substring(11);
      }
      return msg;
    }
    
    return 'Đã xảy ra lỗi không xác định.';
  }
}
