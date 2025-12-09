import 'package:json_annotation/json_annotation.dart';

part 'payment_error_model.g.dart';

@JsonSerializable()
class PaymentErrorModel {
  final String type;
  final String title;
  final int status;
  final String detail;
  final String traceId;

  const PaymentErrorModel({
    required this.type,
    required this.title,
    required this.status,
    required this.detail,
    required this.traceId,
  });

  factory PaymentErrorModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentErrorModelToJson(this);

  // Helper methods để xử lý các loại lỗi cụ thể
  bool get isConflictError => status == 409;
  
  bool get isPendingPaymentError => 
      title.contains('ConflictPending') || 
      detail.toLowerCase().contains('pending payment');
  
  bool get isBadRequest => status == 400;
  
  bool get isUnauthorized => status == 401;
  
  bool get isNotFound => status == 404;
  
  bool get isServerError => status >= 500;

  /// Lấy error message thân thiện cho user
  String get userFriendlyMessage {
    if (isPendingPaymentError) {
      return 'Bạn đang có giao dịch thanh toán chưa hoàn thành. Vui lòng hoàn tất hoặc hủy giao dịch trước khi tạo thanh toán mới.';
    }
    
    switch (status) {
      case 400:
        return 'Thông tin thanh toán không hợp lệ. Vui lòng kiểm tra lại.';
      case 401:
        return 'Bạn cần đăng nhập để thực hiện thanh toán.';
      case 403:
        return 'Bạn không có quyền thực hiện thanh toán này.';
      case 404:
        return 'Không tìm thấy thông tin thanh toán.';
      case 409:
        return 'Có xung đột trong quá trình thanh toán. Vui lòng thử lại.';
      case 429:
        return 'Bạn đã thực hiện quá nhiều yêu cầu. Vui lòng đợi một chút.';
      case 500:
        return 'Lỗi hệ thống. Vui lòng thử lại sau.';
      case 503:
        return 'Dịch vụ thanh toán tạm thời không khả dụng. Vui lòng thử lại sau.';
      default:
        return detail.isNotEmpty ? detail : 'Đã xảy ra lỗi không xác định.';
    }
  }

  /// Lấy error title thân thiện
  String get userFriendlyTitle {
    if (isPendingPaymentError) {
      return 'Thanh toán đang chờ xử lý';
    }
    
    switch (status) {
      case 400:
        return 'Thông tin không hợp lệ';
      case 401:
        return 'Chưa đăng nhập';
      case 403:
        return 'Không có quyền';
      case 404:
        return 'Không tìm thấy';
      case 409:
        return 'Xung đột dữ liệu';
      case 429:
        return 'Quá nhiều yêu cầu';
      case 500:
      case 502:
      case 503:
        return 'Lỗi hệ thống';
      default:
        return 'Lỗi thanh toán';
    }
  }

  /// Lấy màu sắc tương ứng với loại lỗi
  String get errorColor {
    if (isPendingPaymentError) return 'orange';
    if (isServerError) return 'red';
    if (status == 401 || status == 403) return 'blue';
    return 'red';
  }

  /// Lấy icon tương ứng với loại lỗi
  String get errorIcon {
    if (isPendingPaymentError) return 'pending';
    if (status == 401 || status == 403) return 'lock';
    if (status == 404) return 'search';
    if (isServerError) return 'error';
    return 'warning';
  }

  /// Có thể retry hay không
  bool get canRetry {
    return status != 401 && status != 403 && status != 404;
  }

  /// Có thể cancel pending payment hay không
  bool get canCancelPending {
    return isPendingPaymentError;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentErrorModel &&
        other.type == type &&
        other.title == title &&
        other.status == status &&
        other.detail == detail &&
        other.traceId == traceId;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        title.hashCode ^
        status.hashCode ^
        detail.hashCode ^
        traceId.hashCode;
  }

  @override
  String toString() {
    return 'PaymentErrorModel(type: $type, title: $title, status: $status, detail: $detail, traceId: $traceId)';
  }
}