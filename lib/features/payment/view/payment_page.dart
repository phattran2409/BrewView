import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart';
import 'package:briewview/features/premium/viewmodel/premium_event.dart';
import 'package:briewview/features/premium/viewmodel/premium_state.dart';
import 'package:briewview/features/payment/view/widgets/payment_method_card.dart';
import 'package:briewview/features/payment/view/widgets/add_payment_method_dialog.dart';

class PaymentPage extends StatefulWidget {
  final String planId;

  const PaymentPage({super.key, required this.planId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethodId;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => getIt<PremiumBloc>()..add(LoadPremiumPlans()),
        child: BlocConsumer<PremiumBloc, PremiumState>(
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
      ),
    );
  }

  Widget _buildPaymentContent(BuildContext context, dynamic selectedPlan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan summary
          _buildPlanSummary(selectedPlan),
          const SizedBox(height: 24),

          // Payment methods
          // _buildPaymentMethodsSection(),
          const SizedBox(height: 24),

          // Add payment method button
          // _buildAddPaymentMethodButton(),
          const SizedBox(height: 32),

          // Payment button
          _buildPaymentButton(),
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildPlanSummary(dynamic plan) {
    return Container(
      padding: const EdgeInsets.all(20),
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

  // Widget _buildPaymentMethodsSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Phương thức thanh toán',
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 16),

  //       // Mock payment methods - in real app, load from API
  //       // _buildMockPaymentMethods(),
  //     ],
  //   );
  // }

  // Widget _buildAddPaymentMethodButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: OutlinedButton.icon(
  //       onPressed: () {
  //         _showAddPaymentMethodDialog();
  //       },
  //       icon: const Icon(Icons.add),
  //       label: const Text('Thêm phương thức thanh toán'),
  //       style: OutlinedButton.styleFrom(
  //         padding: const EdgeInsets.symmetric(vertical: 12),
  //         side: BorderSide(color: Colors.brown[300]!),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            selectedPaymentMethodId != null && !isProcessing
                ? () => _processPayment()
                : null,
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
                    Text('Đang xử lý...'),
                  ],
                )
                : const Text(
                  'Thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
      ),
    );
  }


  void _processPayment() async {
    if (selectedPaymentMethodId == null) return; 
    UserStorageServices userStorage = getIt<UserStorageServices>();  
    final user = await userStorage.getCurrentUser(); 
    setState(() {
      isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Create subscription
    context.read<PremiumBloc>().add(
      CreateSubscription(
        userId: user?.id ?? '', 
      ),
    );

    setState(() {
      isProcessing = false;
    });
  }
}



