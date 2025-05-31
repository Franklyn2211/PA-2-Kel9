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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      productName: json['product_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      photoUrl: json['photo_url'] as String? ?? '',
      location: json['location'] as String? ?? '',
      price: json['price']?.toString() ?? '0',
      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      phone: json['phone'] as String? ?? '',
      umkmId: json['umkm_id'] is int
          ? json['umkm_id']
          : int.tryParse(json['umkm_id']?.toString() ?? '0') ?? 0,
      qrisUrl: json['qris_url'] as String?,
      umkm: json['umkm'] != null ? Umkm.fromJson(json['umkm']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}