import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserEntity {
  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.unitPreference,
    required this.notificationEnabled,
  });

  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final String unitPreference;
  final bool notificationEnabled;

  factory UserEntity.fromFirebaseUser(
    firebase_auth.User user, {
    Map<String, dynamic>? userDocument,
  }) {
    return UserEntity(
      uid: user.uid,
      email: user.email ?? userDocument?['email'] as String? ?? '',
      displayName:
          user.displayName ?? userDocument?['displayName'] as String? ?? '',
      photoURL: user.photoURL ?? userDocument?['photoURL'] as String? ?? '',
      unitPreference: userDocument?['unit'] as String? ?? 'C',
      notificationEnabled:
          userDocument?['notificationEnabled'] as bool? ?? true,
    );
  }

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? unitPreference,
    bool? notificationEnabled,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      unitPreference: unitPreference ?? this.unitPreference,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}
