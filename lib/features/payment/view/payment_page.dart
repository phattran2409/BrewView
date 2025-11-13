import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/core/utils/priceFormatter.dart';
import 'package:briewview/features/payment/viewModel/payment_bloc.dart';
import 'package:briewview/features/payment/viewModel/payment_event.dart';
import 'package:briewview/features/payment/viewModel/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_event.dart';
import 'package:briewview/features/premium/viewmodel/premium_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String planId;

  const PaymentPage({super.key, required this.planId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethodId;
  bool isProcessing = false;
  UserStorageServices userStorage = getIt<UserStorageServices>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PremiumBloc>()..add(LoadPremiumPlans()),
        ),
        BlocProvider(create: (context) => getIt<PaymentBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thanh toán'),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<PremiumBloc, PremiumState>(
              listener: (context, state) {
                if (state is PremiumError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is PremiumSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop(); // Go back to premium plans
                }
              },
            ),
            BlocListener<PaymentBloc, PaymentState>(
              listener: (context, state) {
                if (state is PaymentError) {
                  setState(() {
                    isProcessing = false;
                  });

                  // Xử lý pending payment error đặc biệt
                  // if (state.isPendingPaymentError) {

                  //   _showPendingPaymentDialog(state, context);
                  // } else {
                  //   // Hiển thị error dialog thông thường
                  //
                  // }
                  _showErrorDialog(state, context);
                } else if (state is PaymentStatusChecked) {
                  context.goNamed('payment-success');
                } else if (state is PaymentPending) {
                  setState(() {
                    isProcessing = false;
                  });
                  _showPendingPaymentDialog(state, context);
                } else if (state is PaymentLinkCreated) {
                  // Hiển thị payment result dialog
                  _showPaymentDialog(state.paymentResult, context);
                } else if (state is PaymentVerified) {
                  setState(() {
                    isProcessing = false;
                  });
                  if (state.isVerified) {
                    // Payment thành công, tạo subscription
                    _createSubscription();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Xác thực thanh toán thất bại'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else if (state is PaymentCancelled) {
                  setState(() {
                    isProcessing = false;
                  });
                  if (state.isCancelled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Đã hủy thanh toán thành công'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Không thể hủy thanh toán'),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
            ),
          ],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<PremiumBloc, PremiumState>(
                    builder: (context, state) {
                      if (state is PremiumLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PremiumLoaded) {
                        final selectedPlan = state.plans.firstWhere(
                          (plan) => plan.id == widget.planId,
                          orElse: () => state.plans.first,
                        );
                        return _buildPaymentContent(context, selectedPlan);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<PaymentBloc, PaymentState>(
                      builder: (context, state) {
                        if (state is PaymentLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildPaymentButton(context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentContent(BuildContext context, dynamic selectedPlan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan summary
          _buildPlanSummary(selectedPlan),
          const SizedBox(height: 24),
          // Add payment method button
          // _buildAddPaymentMethodButton(),
          // const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPlanSummary(dynamic plan) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tóm tắt đơn hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    plan.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              Text(
                PriceFormatter.format(
                  int.parse(plan.formattedPrice),
                  currency: "VND",
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Thời hạn: ${plan.formattedDuration}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !isProcessing ? () => _processPayment(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            isProcessing
                ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Đang xử lý thanh toán...'),
                  ],
                )
                : const Text(
                  'Thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
      ),
    );
  }

  void _processPayment(BuildContext context) async {
    final user = await userStorage.getCurrentUser();
    if (user?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể xác định người dùng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    // Gọi API tạo payment link qua PaymentBloc
    context.read<PaymentBloc>().add(CreatePaymentLinkEvent(userId: user!.id));
  }

  void _createSubscription() async {
    final user = await userStorage.getCurrentUser();

    // Tạo subscription sau khi payment thành công
    context.read<PremiumBloc>().add(CreateSubscription(userId: user?.id ?? ''));
  }

  void _showPaymentDialog(dynamic paymentResult, BuildContext _context) {
    // Lấy PaymentBloc trước khi show dialog để tránh context issue
    final paymentBloc = _context.read<PaymentBloc>();

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông tin thanh toán'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Payment link đã được tạo thành công!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Mã đơn hàng:', paymentResult.displayOrderCode),
                _buildInfoRow('Subscription ID:', paymentResult.subscriptionId),
                const SizedBox(height: 16),

                // QR Code Section
                if (paymentResult.hasQrCode) ...[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.brown.shade200,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Quét mã QR để thanh toán',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.brown,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // QR Code Widget với kích thước cố định
                          Container(
                            width: 200,
                            height: 200,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: QrImageView(
                              data: paymentResult.qrCode,
                              version: QrVersions.auto,
                              size: 184.0,
                              backgroundColor: Colors.white,
                              errorCorrectionLevel: QrErrorCorrectLevel.H,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Quét mã bằng ứng dụng ngân hàng',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider với text "hoặc"
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'HOẶC',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment URL:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // URL text với scroll horizontal
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            paymentResult.paymentUrl,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Action buttons
                      Row(
                        children: [
                          // Nút mở browser
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _launchPaymentURL(paymentResult.paymentUrl);
                              },
                              icon: const Icon(Icons.open_in_browser, size: 16),
                              label: const Text('Mở trang thanh toán'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Hướng dẫn:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('1. Nhấn "Mở trang thanh toán" để thanh toán'),
                const Text('2. Hoặc quét mã QR bằng ứng dụng ngân hàng'),
                const Text('3. Sau khi thanh toán, nhấn "Xác nhận thanh toán"'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                paymentBloc.add(
                  CancelPaymentEvent(
                    orderCode: int.parse(
                      paymentResult.orderCode?.toString() ?? '0',
                    ),
                  ),
                );
                Navigator.of(context).pop();
                setState(() {
                  isProcessing = false;
                });
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                paymentBloc.add(
                  CheckPaymentStatusEvent(
                    orderCode: int.parse(
                      paymentResult.orderCode?.toString() ?? '0',
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xác nhận thanh toán'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showPendingPaymentDialog(
    PaymentPending pendingState,
    BuildContext _context,
  ) {
    // Lấy PaymentBloc trước khi show dialog để tránh context issue
    final paymentBloc = _context.read<PaymentBloc>();

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: paymentBloc,
          child: AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Thanh toán đang chờ xử lý",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mã đơn hàng: ${pendingState.orderCode?.toString() ?? 'Không có'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Trạng thái: Đang chờ thanh toán',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bạn có một thanh toán chưa hoàn tất. Để tạo thanh toán mới, bạn cần hủy thanh toán hiện tại.',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Bạn có thể:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Tiếp tục hoàn tất thanh toán hiện tại',
                        style: TextStyle(fontSize: 13),
                      ),
                      const Text(
                        '• Hủy thanh toán này để tạo thanh toán mới',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  setState(() {
                    isProcessing = false;
                  });
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
                child: const Text('Đóng'),
              ),
              if (pendingState.orderCode != null) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    // Gọi dialog xác nhận hủy với nhiều thông tin cảnh báo hơn
                    _showCancelPendingPaymentDialog(
                      pendingState.orderCode!,
                      _context,
                    );
                  },
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Hủy và tạo mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(PaymentError errorState, BuildContext _context) {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              Text(errorState.userFriendlyTitle),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorState.userFriendlyMessage,
                style: const TextStyle(fontSize: 16),
              ),
              if (errorState.paymentError != null) ...[
                const SizedBox(height: 16),
                ExpansionTile(
                  title: const Text('Chi tiết lỗi'),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildErrorDetailRow('Status:', 'Payment Failed'),
                          _buildErrorDetailRow(
                            'Type:',
                            errorState.paymentError!.type,
                          ),
                          _buildErrorDetailRow(
                            'Detail:',
                            errorState.paymentError!.detail,
                          ),
                          _buildErrorDetailRow(
                            'Trace ID:',
                            errorState.paymentError!.traceId,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            if (errorState.canRetry) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _processPayment(_context); // Thử lại
                },
                child: const Text('Thử lại'),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showCancelPendingPaymentDialog(int orderCode, BuildContext _context) {
    // Lấy PaymentBloc trước khi show dialog để tránh context issue
    final paymentBloc = _context.read<PaymentBloc>();

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Hủy thanh toán chưa hoàn thành',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã đơn hàng: $orderCode',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Trạng thái: Đang chờ thanh toán',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bạn chưa hoàn tất thanh toán cho đơn hàng này.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Lưu ý khi hủy:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Thanh toán hiện tại sẽ bị hủy hoàn toàn',
                      style: TextStyle(fontSize: 13),
                    ),
                    const Text(
                      '• Bạn cần tạo thanh toán mới để tiếp tục',
                      style: TextStyle(fontSize: 13),
                    ),
                    const Text(
                      '• Nếu đã chuyển khoản, vui lòng KHÔNG hủy',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Sau khi hủy, nhấn nút "Thanh toán" để tạo thanh toán mới',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Bạn có chắc chắn muốn hủy thanh toán này?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
              child: const Text('Quay lại'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                // Dispatch event để hủy payment
                paymentBloc.add(CancelPaymentEvent(orderCode: orderCode));

                // Hiển thị loading
                ScaffoldMessenger.of(_context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Đang hủy thanh toán...'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.cancel, size: 18),
              label: const Text('Xác nhận hủy'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Future<void> _launchPaymentURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Mở trong browser
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể mở trang thanh toán'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi mở trang thanh toán: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
