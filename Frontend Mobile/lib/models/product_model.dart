import 'package:aplikasi_desa/models/umkm.dart';

class Product {
  final int id;
  final String productName;
  final String description;
  final String photo;
  final String photoUrl;
  final String location;
  final String price;
  final int stock;
  final String phone;
  final int umkmId;
  final String? qrisUrl;
  final Umkm? umkm;

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
    this.umkm,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      photoUrl: json['photo_url'] as String? ?? '',
      location: json['location'] as String? ?? '',
      price: json['price'] as String? ?? '0',
      stock: json['stock'] as int? ?? 0,
      phone: json['phone'] as String? ?? '',
      umkmId: json['umkm_id'] as int? ?? 0,
      qrisUrl: json['qris_url'] as String?,
      umkm: json['umkm'] != null ? Umkm.fromJson(json['umkm']) : null,
    );
  }
}