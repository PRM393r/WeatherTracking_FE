import '../../features/auth/entities/user_entity.dart';

abstract interface class IAuthRepository {
  Stream<UserEntity?> authStateChanges();

  UserEntity? get currentUser;

  Future<UserEntity> signIn({required String email, required String password});

  Future<UserEntity> signInWithGoogle();

  Future<UserEntity> signUp({required String email, required String password});

  Future<void> signOut();

  Future<void> resetPassword(String email);
}
