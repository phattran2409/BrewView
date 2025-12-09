// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import '../viewModel/payment_bloc.dart';
// import '../viewModel/payment_event.dart';
// import '../viewModel/payment_state.dart';

// class PaymentDemoPage extends StatelessWidget {
//   final String userId;

//   const PaymentDemoPage({
//     Key? key,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => GetIt.instance<PaymentBloc>(),
//       child: PaymentDemoView(userId: userId),
//     );
//   }
// }

// class PaymentDemoView extends StatefulWidget {
//   final String userId;

//   const PaymentDemoView({
//     Key? key,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   State<PaymentDemoView> createState() => _PaymentDemoViewState();
// }

// class _PaymentDemoViewState extends State<PaymentDemoView> {
//   @override
//   void initState() {
//     super.initState();
//     // Tự động tạo payment link khi vào page
//     context.read<PaymentBloc>().add(
//       CreatePaymentLinkEvent(userId: widget.userId),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Demo Payment API'),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<PaymentBloc, PaymentState>(
//         listener: (context, state) {
//           if (state is PaymentError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           } else if (state is PaymentSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildApiStatus(state),
//                 const SizedBox(height: 20),
//                 _buildPaymentContent(context, state),
//                 const SizedBox(height: 20),
//                 _buildActionButtons(context, state),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildApiStatus(PaymentState state) {
//     String status = 'Unknown';
//     Color statusColor = Colors.grey;

//     if (state is PaymentInitial) {
//       status = 'Chưa bắt đầu';
//       statusColor = Colors.grey;
//     } else if (state is PaymentLoading) {
//       status = 'Đang gọi API...';
//       statusColor = Colors.orange;
//     } else if (state is PaymentLinkCreated) {
//       status = 'API tạo payment link thành công';
//       statusColor = Colors.green;
//     } else if (state is PaymentStatusChecked) {
//       status = 'API kiểm tra trạng thái thành công';
//       statusColor = Colors.green;
//     } else if (state is PaymentVerified) {
//       status = state.isVerified ? 'API verify thành công' : 'API verify thất bại';
//       statusColor = state.isVerified ? Colors.green : Colors.orange;
//     } else if (state is PaymentError) {
//       status = 'API lỗi';
//       statusColor = Colors.red;
//     }

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Trạng thái API',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Container(
//                   width: 12,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: statusColor,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   status,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _buildPaymentContent(BuildContext context, PaymentState state) {
//   //   if (state is PaymentLoading) {
//   //     return const Expanded(
//   //       child: Center(
//   //         child: Column(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             CircularProgressIndicator(),
//   //             SizedBox(height: 16),
//   //             Text('Đang gọi API...'),
//   //           ],
//   //         ),
//   //       ),
//   //     );
//   //   }

//   //   if (state is PaymentLinkCreated) {
//   //     return _buildPaymentResult(context, state);
//   //   }

//   //   if (state is PaymentStatusChecked) {
//   //     return _buildStatusResult(context, state);
//   //   }

//   //   if (state is PaymentVerified) {
//   //     return _buildVerifyResult(context, state);
//   //   }

//   //   if (state is PaymentError) {
//   //     return _buildErrorWidget(context);
//   //   }

//   //   return const Expanded(
//   //     child: Center(
//   //       child: Text('Nhấn "Tạo Payment Link" để bắt đầu'),
//   //     ),
//   //   );
//   // }

//   Widget _buildPaymentResult(BuildContext context, PaymentLinkCreated state) {
//     return Expanded(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Kết quả API tạo Payment Link',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     _buildDataRow('Subscription ID:', state.paymentResult.subscriptionId),
//                     _buildDataRow('Order Code:', state.paymentResult.orderCode.toString()),
//                     _buildDataRow('Payment URL:', state.paymentResult.paymentUrl, isUrl: true),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'QR Code Data:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: SelectableText(
//                         state.paymentResult.qrCode,
//                         style: const TextStyle(
//                           fontFamily: 'monospace',
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _buildStatusResult(BuildContext context, PaymentStatusChecked state) {
//   //   return Expanded(
//   //     child: Card(
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             const Text(
//   //               'Kết quả API kiểm tra trạng thái',
//   //               style: TextStyle(
//   //                 fontSize: 16,
//   //                 fontWeight: FontWeight.bold,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 12),
//   //             Expanded(
//   //               child: SingleChildScrollView(
//   //                 child: Text(
//   //                   state.statusData.toString(),
//   //                   style: const TextStyle(fontFamily: 'monospace'),
//   //                 ),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildVerifyResult(BuildContext context, PaymentVerified state) {
//     return Expanded(
//       child: Center(
//         child: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(32.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   state.isVerified ? Icons.check_circle : Icons.error,
//                   size: 64,
//                   color: state.isVerified ? Colors.green : Colors.red,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   state.isVerified ? 'Verify thành công!' : 'Verify thất bại!',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: state.isVerified ? Colors.green : Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget(BuildContext context) {
//     return Expanded(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               size: 64,
//               color: Colors.red,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Có lỗi xảy ra khi gọi API',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDataRow(String label, String value, {bool isUrl = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: isUrl
//                 ? GestureDetector(
//                     onTap: () => _copyToClipboard(value),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade50,
//                         borderRadius: BorderRadius.circular(4),
//                         border: Border.all(color: Colors.blue.shade200),
//                       ),
//                       child: Text(
//                         value,
//                         style: const TextStyle(
//                           color: Colors.blue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   )
//                 : SelectableText(value),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, PaymentState state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             context.read<PaymentBloc>().add(
//               CreatePaymentLinkEvent(userId: widget.userId),
//             );
//           },
//           child: const Text('1. Tạo Payment Link'),
//         ),
//         const SizedBox(height: 8),
//         if (state is PaymentLinkCreated) ...[
//           ElevatedButton(
//             onPressed: () {
//               context.read<PaymentBloc>().add(
//                 CheckPaymentStatusEvent(
//                   orderCode: state.paymentResult.orderCode,
//                 ),
//               );
//             },
//             child: const Text('2. Kiểm tra trạng thái'),
//           ),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: () {
//               context.read<PaymentBloc>().add(
//                 VerifyPaymentEvent(
//                   orderCode: state.paymentResult.orderCode,
//                   subscriptionId: state.paymentResult.subscriptionId,
//                 ),
//               );
//             },
//             child: const Text('3. Verify Payment'),
//           ),
//           const SizedBox(height: 8),
//           OutlinedButton(
//             onPressed: () {
//               context.read<PaymentBloc>().add(
//                 CancelPaymentEvent(orderCode: state.paymentResult.orderCode),
//               );
//             },
//             child: const Text('Hủy Payment'),
//           ),
//         ],
//         const SizedBox(height: 8),
//         TextButton(
//           onPressed: () {
//             context.read<PaymentBloc>().add(const ResetPaymentEvent());
//           },
//           child: const Text('Reset'),
//         ),
//       ],
//     );
//   }

//   Future<void> _copyToClipboard(String text) async {
//     await Clipboard.setData(ClipboardData(text: text));
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Đã copy vào clipboard'),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }
//   }
// }