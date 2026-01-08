class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String role;
  final bool isVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    required this.role,
    this.isVerified = false,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isInvestor => role.toLowerCase() == 'investor';
  bool get isCustomer => role.toLowerCase() == 'customer';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? json['phoneNumber'] ?? '',
      role: json['role'] ?? 'Customer',
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static User mock() {
    return User(
      id: 1,
      firstName: 'محمد',
      lastName: 'العبدالله',
      email: 'mohammed@example.com',
      phone: '0501234567',
      role: 'Customer',
      isVerified: true,
      createdAt: DateTime.now(),
    );
  }
}
