// models/app_user.dart

enum UserRole { parent,  child }

UserRole roleFromString(String? s) =>
    (s == 'child') ? UserRole.child : UserRole.parent;

String roleToString(UserRole r) =>
    (r == UserRole.child) ? 'child' : 'parent';

class AppUser {
  final String uid;                 // /users/{uid}
  final UserRole role;              // "parent" | "child"
  final String name;
  final String email;

  /// Only if role == parent
  final Map<String, bool> childIds; // { childId: true, ... }

  AppUser({
    required this.uid,
    required this.role,
    required this.name,
    required this.email,
    Map<String, bool>? childIds,
  }) : childIds = childIds ?? const {};

  factory AppUser.fromJson(Map<dynamic, dynamic>? json, String uid) {
    final j = (json ?? {});
    return AppUser(
      uid: uid,
      role: roleFromString(j['role'] as String?),
      name: (j['name'] ?? '') as String,
      email: (j['email'] ?? '') as String,
      childIds: Map<String, bool>.from(j['childIds'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'role': roleToString(role),
    'name': name,
    'email': email,
    if (childIds.isNotEmpty) 'childIds': childIds,
  };

  AppUser copyWith({
    UserRole? role,
    String? name,
    String? email,
    Map<String, bool>? childIds,
  }) {
    return AppUser(
      uid: uid,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      childIds: childIds ?? this.childIds,
    );
  }
  /// 👇 Add this
  @override
  String toString() {
    return 'AppUser('
        'uid: $uid, '
        'role: ${roleToString(role)}, '
        'name: $name, '
        'email: $email, '
        'childIds: $childIds'
        ')';
  }
}
