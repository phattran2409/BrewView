import 'dart:async';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/core/widgets/wave_clipper.dart';
import 'package:briewview/features/auth/viewModel/Bloc/Otp_Bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:briewview/app/router/route_paths.dart';

class OtpPage extends StatefulWidget {
  final String? uid; // email/số điện thoại (nếu muốn hiển thị)
  final String? email; // từ query parameter (nếu cần)
  const OtpPage({super.key, this.uid, this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());
  bool _submitting = false;

  // Thêm biến đếm ngược OTP
  int _secondsLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startOtpTimer();
  }

  void _startOtpTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    setState(() {}); // enable/disable button
  }

  Future<void> _submit(BuildContext context) async {
    print('Length: ${_otp.length}, OTP: $_otp');
    if (_otp.length == 6 || _otp.contains(RegExp(r'[^0-9]'))) {
      
      context.read<OtpBloc>().add(
        OtpVerifyRequested(otp: _otp, userId: widget.uid!),
      );
      setState(() => _submitting = true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter 6-digit OTP')));
      return;
    }

    // Listen for OTP verification result
    // final otpVerificationResult = context.read<OtpBloc>().stream;
    // otpVerificationResult.listen((state) {
    //   if (state is OtpVerificationSuccess) {
    //     // Navigate to home on success
    //     context.go(RoutePaths.home);
    //   } else if (state is OtpVerificationFailure) {
    //     // Show error message on failure
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Xác thực OTP thất bại: ${state.message}')),
    //     );
    //   }
    // });
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: _controllers[index],
        focusNode: _nodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Color(0xFFF3F3F3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (v) => _onChanged(index, v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _otp.length == 6 && !_otp.contains(RegExp(r'[^0-9]'));
    return BlocProvider(
      create: (context) => getIt<OtpBloc>(),
      child: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccess) {
            // Navigate to home on success
            context.go(RoutePaths.home);
          } else if (state is OtpVerificationFailure) {
            // Show error message on failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xác thực OTP thất bại: ${state.message}'),
              ),
            );
          }
        },
      
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              // Background
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 172, 89, 1),
                ),
              ),

              // Wave ClipPath
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF763C0C), // Màu trên
                        Color(0xFF5A2D09), // Màu transition
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (widget.uid != null)
                            Text(
                              'Mã xác thực đã gửi đến ${widget.email ?? ''}',
                              textAlign: TextAlign.center,
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 8),
                              const Text(
                                'Enter OTP',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.lock, color: Colors.white),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, _otpBox),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: enabled && !_submitting
                                ? () => _submit(context)
                                : null,
                            child:
                                _submitting
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Confirm'),
                          ),
                          const SizedBox(height: 12),
                          // Bộ đếm và nút resend
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _secondsLeft > 0
                                    ? 'Gửi lại mã sau $_secondsLeft giây'
                                    : 'Bạn chưa nhận được mã?',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed:
                                    (_submitting || _secondsLeft > 0)
                                        ? null
                                        : () async {
                                          // TODO: gọi API gửi lại OTP
                                          _startOtpTimer();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Đã gửi lại OTP'),
                                            ),
                                          );
                                        },
                                child: const Text(
                                  'Resend code',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    )
    );
  }
}
