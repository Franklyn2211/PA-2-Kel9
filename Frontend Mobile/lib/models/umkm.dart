// umkm_model.dart
class Umkm {
  final int id;
  final String namaUmkm;
  final String email;
  final String phone;
  final String? qrisImage;
  final bool? status;
  final String? createdAt;
  final String? updatedAt;
  final String? photoUrl;
  final String? qrisUrl;

  Umkm({
    required this.id,
    required this.namaUmkm,
    required this.email,
    required this.phone,
    this.qrisImage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.photoUrl,
    this.qrisUrl,
  });

  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      id: json['id'],
      namaUmkm: json['nama_umkm'],
      email: json['email'],
      phone: json['phone'],
      qrisImage: json['qris_image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      photoUrl: json['photo_url'],
      qrisUrl: json['qris_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_umkm': namaUmkm,
      'email': email,
      'phone': phone,
      'qris_image': qrisImage,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'photo_url': photoUrl,
      'qris_url': qrisUrl,
    };
  }
}
