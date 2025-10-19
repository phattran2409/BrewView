import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/network/user_storage_services.dart';
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
                  if (state.isPendingPaymentError) {
                    _showPendingPaymentDialog(state);
                  } else {
                    // Hiển thị error dialog thông thường
                    _showErrorDialog(state);
                  }
                } else if (state is PaymentLinkCreated) {
                  // Hiển thị payment result dialog
                  _showPaymentDialog(state.paymentResult);
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
                plan.formattedPrice,
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

  void _showPaymentDialog(dynamic paymentResult) {
    showDialog(
      context: context,
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
                                padding: const EdgeInsets.symmetric(vertical: 8),
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
                Navigator.of(context).pop();
                setState(() {
                  isProcessing = false;
                });
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Verify payment
                context.read<PaymentBloc>().add(
                  VerifyPaymentEvent(
                    orderCode: paymentResult.orderCode,
                    subscriptionId: paymentResult.subscriptionId,
                  ),
                );
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

  void _showPendingPaymentDialog(PaymentError errorState) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.pending_actions,
                color: Colors.orange,
                size: 24,
              ),
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
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bạn có thể:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Hoàn tất thanh toán hiện tại'),
                    const Text('• Hủy thanh toán để tạo thanh toán mới'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            if (errorState.canCancelPending) ...[
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showCancelPendingPaymentDialog();
                },
                child: const Text('Hủy thanh toán cũ'),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showErrorDialog(PaymentError errorState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24,
              ),
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
                          _buildErrorDetailRow('Status:', '${errorState.paymentError!.status}'),
                          _buildErrorDetailRow('Type:', errorState.paymentError!.type),
                          _buildErrorDetailRow('Detail:', errorState.paymentError!.detail),
                          _buildErrorDetailRow('Trace ID:', errorState.paymentError!.traceId),
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
                  _processPayment(context); // Thử lại
                },
                child: const Text('Thử lại'),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showCancelPendingPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hủy thanh toán cũ'),
          content: const Text(
            'Bạn có chắc chắn muốn hủy thanh toán đang chờ xử lý không?\n\n'
            'Sau khi hủy, bạn có thể tạo thanh toán mới.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement cancel pending payment
                // Cần thêm API endpoint để lấy pending payment info và cancel
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng hủy thanh toán cũ đang được phát triển'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hủy thanh toán'),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
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
