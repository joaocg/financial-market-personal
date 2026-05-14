import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String familyId;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.familyId,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      familyId: json['family_id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'member',
    );
  }

  @override
  List<Object?> get props => [id, name, email, familyId, role];
}
