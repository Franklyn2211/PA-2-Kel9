class Umkm {
  final int id;
  final String namaUmkm;
  final String email;
  final String phone;
  final String qrisImage;
  final bool status;
  final String qrisUrl;

  Umkm({
    required this.id,
    required this.namaUmkm,
    required this.email,
    required this.phone,
    required this.qrisImage,
    required this.status,
    required this.qrisUrl,
  });

  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      id: json['id'] as int? ?? 0,
      namaUmkm: json['nama_umkm'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      qrisImage: json['qris_image'] as String? ?? '',
      status: json['status'] as bool? ?? false,
      qrisUrl: json['qris_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama_umkm': namaUmkm,
        'email': email,
        'phone': phone,
        'qris_image': qrisImage,
        'status': status,
        'qris_url': qrisUrl,
      };
}