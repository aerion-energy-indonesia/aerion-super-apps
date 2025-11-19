class AuthEntity {
  final String uid;
  final String email;
  final String? username;
  final String? role;
  // Tambahkan field lain dari Firestore jika diperlukan

  AuthEntity({
    required this.uid,
    required this.email,
    this.username,
    this.role,
  });

  // Helper untuk membuat entity dari data gabungan (Auth + Firestore)
  factory AuthEntity.fromMap(Map<String, dynamic> map) {
    return AuthEntity(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'] as String?,
      role: map['role'] as String?,
    );
  }
}
