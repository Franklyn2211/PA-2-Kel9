class Staff {
  final int id;
  final String name;
  final String position;
  final String photoUrl; // Perbarui ke photoUrl
  final String phone;
  final String email;
  final String npsnActive;
  final String createdAt;
  final String updatedAt;

  Staff({
    required this.id,
    required this.name,
    required this.position,
    required this.photoUrl, // Gunakan photoUrl
    required this.phone,
    required this.email,
    required this.npsnActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      photoUrl: json['photo_url'], // Gunakan photo_url dari API
      phone: json['phone'],
      email: json['email'],
      npsnActive: json['npsn_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
