import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/repositories/i_auth_repository.dart';
import '../entities/user_entity.dart';

class FirebaseAuthRepository implements IAuthRepository {
  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _auth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  UserEntity? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : UserEntity.fromFirebaseUser(user);
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _auth.authStateChanges().asyncExpand(_userWithBackendProfile);
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toEntityAfterBackendSync(credential.user);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthCancelledException();
    }

    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return _toEntityAfterBackendSync(userCredential.user);
  }

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toEntityAfterBackendSync(credential.user);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_googleSignIn.signOut(), _auth.signOut()]);
  }

  @override
  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserEntity> _toEntityAfterBackendSync(firebase_auth.User? user) async {
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'missing-user',
        message: 'Firebase Auth did not return a user.',
      );
    }

    final snapshot = await _waitForUserDocument(user.uid);
    return UserEntity.fromFirebaseUser(user, userDocument: snapshot?.data());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _waitForUserDocument(
    String uid,
  ) async {
    final docRef = _users.doc(uid);
    final immediate = await docRef.get();
    if (immediate.exists) return immediate;

    try {
      return await docRef
          .snapshots()
          .firstWhere((snapshot) => snapshot.exists)
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      return null;
    }
  }

  Stream<UserEntity?> _userWithBackendProfile(firebase_auth.User? user) async* {
    if (user == null) {
      yield null;
      return;
    }

    yield UserEntity.fromFirebaseUser(user);

    try {
      await for (final snapshot in _users.doc(user.uid).snapshots()) {
        yield UserEntity.fromFirebaseUser(user, userDocument: snapshot.data());
      }
    } on FirebaseException {
      return;
    }
  }
}

class AuthCancelledException implements Exception {
  const AuthCancelledException();
}
