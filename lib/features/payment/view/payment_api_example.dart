// import 'package:flutter/material.dart';
// import '../view/payment_demo_page.dart';

// /// Example widget để demo toàn bộ luồng Payment API
// /// 
// /// Usage:
// /// ```dart
// /// Navigator.push(
// ///   context,
// ///   MaterialPageRoute(
// ///     builder: (context) => const PaymentApiExample(),
// ///   ),
// /// );
// /// ```
// class PaymentApiExample extends StatelessWidget {
//   const PaymentApiExample({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment API Demo'),
//       ),
//       body: const Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Luồng API Payment',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Text('1. Service Layer: PaymentService - gọi API endpoint'),
//                     Text('2. Repository Layer: PaymentRepository - quản lý data'),
//                     Text('3. ViewModel Layer: PaymentBloc - quản lý state'),
//                     Text('4. View Layer: PaymentDemoPage - hiển thị UI'),
//                     SizedBox(height: 12),
//                     Text(
//                       'Các API được demo:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text('• POST /api/subscriptions/create-payment-link/{userId}'),
//                     Text('• GET /api/payment/status/{orderCode}'),
//                     Text('• POST /api/payment/verify'),
//                     Text('• POST /api/payment/cancel'),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             _DemoButton(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _DemoButton extends StatelessWidget {
//   const _DemoButton();

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const PaymentDemoPage(
//               userId: 'demo-user-123', // Fake user ID for demo
//             ),
//           ),
//         );
//       },
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//       ),
//       child: const Text(
//         'Bắt đầu Demo Payment API',
//         style: TextStyle(fontSize: 16),
//       ),
//     );
//   }
// }

// /// Extension để thêm vào router nếu cần
// /// 
// /// Example trong go_router:
// /// ```dart
// /// GoRoute(
// ///   path: '/payment-demo',
// ///   builder: (context, state) => const PaymentApiExample(),
// /// ),
// /// ```