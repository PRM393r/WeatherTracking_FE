import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_tracking/core/repositories/i_auth_repository.dart';
import 'package:weather_tracking/features/auth/entities/user_entity.dart';
import 'package:weather_tracking/features/auth/providers/auth_provider.dart';

void main() {
  test('authStateProvider relays repository auth changes', () async {
    final fakeRepository = _FakeAuthRepository();
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
    );
    addTearDown(container.dispose);
    addTearDown(fakeRepository.dispose);

    final events = <UserEntity?>[];
    final subscription = container.listen<AsyncValue<UserEntity?>>(
      authStateProvider,
      (_, next) => next.whenData(events.add),
    );
    addTearDown(subscription.close);

    fakeRepository.emit(_testUser);
    await pumpEventQueue();
    fakeRepository.emit(null);
    await pumpEventQueue();

    expect(events, [_testUser, null]);
  });

  test('authController signOut emits null through auth state', () async {
    final fakeRepository = _FakeAuthRepository()..emit(_testUser);
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
    );
    addTearDown(container.dispose);
    addTearDown(fakeRepository.dispose);

    final events = <UserEntity?>[];
    final subscription = container.listen<AsyncValue<UserEntity?>>(
      authStateProvider,
      (_, next) => next.whenData(events.add),
    );
    addTearDown(subscription.close);

    await container.read(authControllerProvider.notifier).signOut();
    await pumpEventQueue();

    expect(fakeRepository.currentUser, isNull);
    expect(events.last, isNull);
  });

  test('authController exposes friendly error on failed sign in', () async {
    final fakeRepository = _FakeAuthRepository()..shouldFailSignIn = true;
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
    );
    addTearDown(container.dispose);
    addTearDown(fakeRepository.dispose);

    final success = await container
        .read(authControllerProvider.notifier)
        .signIn(email: 'wrong@example.com', password: 'wrongpass');

    expect(success, isFalse);
    expect(
      container.read(authControllerProvider).errorMessage,
      'Email hoặc mật khẩu không đúng.',
    );
  });

  test('authController explains missing Google SHA-1 config', () async {
    final fakeRepository = _FakeAuthRepository()..shouldFailGoogleSignIn = true;
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
    );
    addTearDown(container.dispose);
    addTearDown(fakeRepository.dispose);

    final success = await container
        .read(authControllerProvider.notifier)
        .signInWithGoogle();

    expect(success, isFalse);
    expect(
      container.read(authControllerProvider).errorMessage,
      'Google Sign-In chưa được cấu hình SHA-1. Hãy thêm SHA-1 vào Firebase rồi tải lại google-services.json.',
    );
  });
}

const _testUser = UserEntity(
  uid: 'uid-1',
  email: 'mai@example.com',
  displayName: 'Mai Nguyen',
  photoURL: '',
  unitPreference: 'C',
  notificationEnabled: true,
);

class _FakeAuthRepository implements IAuthRepository {
  final _controller = StreamController<UserEntity?>.broadcast();

  UserEntity? _currentUser;
  bool shouldFailSignIn = false;
  bool shouldFailGoogleSignIn = false;

  void emit(UserEntity? user) {
    _currentUser = user;
    _controller.add(user);
  }

  void dispose() {
    _controller.close();
  }

  @override
  UserEntity? get currentUser => _currentUser;

  @override
  Stream<UserEntity?> authStateChanges() => _controller.stream;

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    if (shouldFailSignIn) throw Exception('invalid-credential');
    final user = _testUser.copyWith(email: email);
    emit(user);
    return user;
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    if (shouldFailGoogleSignIn) {
      throw Exception('ApiException: 10: DEVELOPER_ERROR');
    }
    emit(_testUser);
    return _testUser;
  }

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) async {
    final user = _testUser.copyWith(email: email);
    emit(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    emit(null);
  }

  @override
  Future<void> resetPassword(String email) async {}
}
