import 'package:aplikasi_desa/models/umkm.dart';

class Product {
  final int id;
  final String productName;
  final String description;
  final String photo;
  final String photoUrl;
  final String location;
  final String price; // Tetap gunakan string untuk price
  final int stock;
  final String phone;
  final int umkmId;
  final String? qrisUrl;
  final Umkm? umkm; // Tambahkan properti umkm
  final DateTime? createdAt; // Sudah nullable
  final DateTime? updatedAt; // Tambahkan jika diperlukan

  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.photo,
    required this.photoUrl,
    required this.location,
    required this.price,
    required this.stock,
    required this.phone,
    required this.umkmId,
    this.qrisUrl,
    this.umkm, // Tambahkan ini
    this.createdAt, // Ubah menjadi nullable
    this.updatedAt, // Tambahkan jika diperlukan
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      photoUrl: json['photo_url'] as String? ?? '',
      location: json['location'] as String? ?? '',
      price: json['price'] as String? ?? '0.00', // Tetap string
      stock: json['stock'] as int? ?? 0,
      phone: json['phone'] as String? ?? '',
      umkmId: json['umkm_id'] as int? ?? 0,
      qrisUrl: json['qris_url'] as String?,
      umkm: json['umkm'] != null ? Umkm.fromJson(json['umkm']) : null, // Parsing data UMKM
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at']) // Parsing jika tidak null
          : null, // Tetapkan null jika created_at tidak ada
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at']) // Parsing updated_at jika ada
          : null, // Tetapkan null jika updated_at tidak ada
    );
  }
}