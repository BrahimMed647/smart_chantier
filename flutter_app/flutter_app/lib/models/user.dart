class AppUser {
  final int id;
  final String email;
  final String name;
  final String role;
  final String? phone;
  final int? organization;
  final String? organizationName;

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.organization,
    this.organizationName,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json["id"] as int,
        email: json["email"] as String,
        name: json["name"] as String,
        role: json["role"] as String,
        phone: json["phone"] as String?,
        organization: json["organization"] as int?,
        organizationName: json["organization_name"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "role": role,
        "phone": phone,
        "organization": organization,
        "organization_name": organizationName,
      };

  String get initials {
    final parts = name.split(" ");
    if (parts.length >= 2) return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : "?";
  }
}
