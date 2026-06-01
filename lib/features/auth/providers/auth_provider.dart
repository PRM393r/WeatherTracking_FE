import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/repositories/i_auth_repository.dart';
import '../entities/user_entity.dart';
import '../repositories/firebase_auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthControllerState>((ref) {
      return AuthController(ref.watch(authRepositoryProvider));
    });

class AuthControllerState {
  const AuthControllerState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  AuthControllerState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthControllerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthControllerState> {
  AuthController(this._authRepository) : super(const AuthControllerState());

  final IAuthRepository _authRepository;

  Future<bool> signIn({required String email, required String password}) {
    return _runAuthAction(
      () => _authRepository.signIn(email: email, password: password),
    );
  }

  Future<bool> signInWithGoogle() {
    return _runAuthAction(_authRepository.signInWithGoogle);
  }

  Future<bool> signUp({required String email, required String password}) {
    return _runAuthAction(
      () => _authRepository.signUp(email: email, password: password),
    );
  }

  Future<bool> resetPassword(String email) {
    return _runAuthAction(() => _authRepository.resetPassword(email));
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _authRepository.signOut();
      state = const AuthControllerState();
    } on Exception catch (error) {
      state = AuthControllerState(errorMessage: _friendlyError(error));
    }
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await action();
      state = const AuthControllerState();
      return true;
    } on AuthCancelledException {
      state = const AuthControllerState();
      return false;
    } on Exception catch (error) {
      state = AuthControllerState(errorMessage: _friendlyError(error));
      return false;
    }
  }

  String _friendlyError(Object error) {
    final raw = error.toString();
    if (raw.contains('user-not-found') ||
        raw.contains('wrong-password') ||
        raw.contains('invalid-credential')) {
      return 'Email hoặc mật khẩu không đúng.';
    }
    if (raw.contains('email-already-in-use')) {
      return 'Email này đã được đăng ký.';
    }
    if (raw.contains('weak-password')) return 'Mật khẩu quá yếu.';
    if (raw.contains('invalid-email')) return 'Email không hợp lệ.';
    if (raw.contains('too-many-requests')) {
      return 'Quá nhiều lần thử. Vui lòng thử lại sau.';
    }
    if (raw.contains('ApiException: 10') || raw.contains('DEVELOPER_ERROR')) {
      return 'Google Sign-In chưa được cấu hình SHA-1. Hãy thêm SHA-1 vào Firebase rồi tải lại google-services.json.';
    }
    if (raw.contains('network')) return 'Lỗi kết nối mạng.';
    return 'Thao tác thất bại. Vui lòng thử lại.';
  }
}
