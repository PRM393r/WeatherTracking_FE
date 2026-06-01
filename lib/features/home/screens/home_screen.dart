import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../location/providers/location_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    final authState = ref.watch(authControllerProvider);
    final locationAsync = ref.watch(currentLocationProvider);
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Auth error: $error')),
        data: (user) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.blockSky,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🌤️',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.displayName.isNotEmpty == true
                            ? 'Xin chào,\n${user!.displayName}'
                            : 'Xin chào!',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(height: 1.1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.email ?? 'Người dùng',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.ink.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                locationAsync.when(
                  loading: () => _LocationStatusCard(
                    title: 'Đang lấy vị trí',
                    body: 'Kiểm tra GPS và quyền truy cập vị trí...',
                    color: AppColors.blockRain,
                  ),
                  error: (error, _) => _LocationStatusCard(
                    title: 'Chưa lấy được vị trí',
                    body: _locationErrorMessage(error),
                    color: AppColors.blockCoral,
                  ),
                  data: (location) => _LocationStatusCard(
                    title: location.displayName,
                    body:
                        '${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}',
                    color: AppColors.blockRain,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.blockMint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Firebase Auth đã kết nối',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'UID: ${user?.uid ?? "N/A"}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unit: ${user?.unitPreference ?? "C"} · Notifications: ${user?.notificationEnabled == false ? "off" : "on"}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () =>
                            ref.read(authControllerProvider.notifier).signOut(),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Đăng xuất'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _locationErrorMessage(Object error) {
    final raw = error.toString();
    if (raw.contains('serviceDisabled')) return 'Dịch vụ vị trí đang tắt.';
    if (raw.contains('permissionPermanentlyDenied')) {
      return 'Quyền vị trí đã bị chặn trong cài đặt.';
    }
    if (raw.contains('permissionDenied')) {
      return 'Ứng dụng chưa được cấp quyền vị trí.';
    }
    if (raw.contains('timeout')) return 'Không lấy được vị trí trong 10 giây.';
    return 'Không thể xác định vị trí hiện tại.';
  }
}

class _LocationStatusCard extends StatelessWidget {
  const _LocationStatusCard({
    required this.title,
    required this.body,
    required this.color,
  });

  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
