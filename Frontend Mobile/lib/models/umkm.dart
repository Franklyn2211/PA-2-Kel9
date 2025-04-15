class Umkm {
  final int id;
  final String namaUmkm;
  final String email;
  final String phone;
  final String qrisImage;
  final bool status;
  final String? photoUrl;

  Umkm({
    required this.id,
    required this.namaUmkm,
    required this.email,
    required this.phone,
    required this.qrisImage,
    required this.status,
    this.photoUrl,
  });

  // Factory constructor untuk parsing dari JSON
  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      id: json['id'] as int,
      namaUmkm: json['nama_umkm'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      qrisImage: json['qris_image'] as String,
      status: json['status'] as bool,
      photoUrl: json['photo_url'] as String?,
    );
  }
}