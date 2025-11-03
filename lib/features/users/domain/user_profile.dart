class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String role; // 'user' or 'admin'
  final String status; // 'pending', 'active', 'inactive'
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? identificationNumber;
  final String? whatsappNumber;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.identificationNumber,
    this.whatsappNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      identificationNumber: json['identification_number'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'identification_number': identificationNumber,
      'whatsapp_number': whatsappNumber,
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? identificationNumber,
    String? whatsappNumber,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get isInactive => status == 'inactive';
}
