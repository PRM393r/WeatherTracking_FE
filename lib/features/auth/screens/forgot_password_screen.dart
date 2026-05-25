import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/theme.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Nhập email hợp lệ');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authProvider).resetPassword(email);
      if (mounted) setState(() => _sent = true);
    } on Exception catch (_) {
      setState(() => _error = 'Gửi thất bại. Kiểm tra lại email.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.canvas,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.blockSunset,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🔑', style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(height: 12),
                    Text(
                      'Quên mật\nkhẩu?',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(height: 1.1),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nhập email — chúng tôi gửi link đặt lại',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.ink.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              if (_sent)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.blockMint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text('✅', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(
                        'Email đã được gửi!\nKiểm tra hộp thư của bạn.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Quay lại đăng nhập'),
                      ),
                    ],
                  ),
                )
              else ...[
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.blockCoral,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_error!, style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _send,
                    child: _loading
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.canvas),
                          )
                        : const Text('Gửi link đặt lại'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
