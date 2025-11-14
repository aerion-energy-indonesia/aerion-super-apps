class AuthEntity {
  final String uid;
  final String email;

  AuthEntity({required this.uid, required this.email});

  @override
  String toString() => 'AuthEntity(uid: $uid, email: $email)';
}
