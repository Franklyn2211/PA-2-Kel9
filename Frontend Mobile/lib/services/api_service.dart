import 'dart:convert';
import 'package:aplikasi_desa/models/userpenduduk.dart';
import 'package:http/http.dart' as http;
import '../models/penduduk_response.dart';
import '../models/product_model.dart';
import '../models/berita.dart';

class ApiService {
<<<<<<< HEAD
  static const String baseUrl = "https://fecb-114-5-147-224.ngrok-free.app/api";
=======
  static const String baseUrl =
      "https://fd35-103-167-217-200.ngrok-free.app/api";
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true'
  };

  // ==================== NIK VERIFICATION ====================
  // services/api_service.dart
  static Future<PendudukResponse> verifyNik(String nik) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/penduduk?nik=$nik'),
        headers: headers,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return PendudukResponse.fromJson(responseData);
      } else {
        throw Exception(responseData['message'] ?? 'Gagal memverifikasi NIK');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== PRODUCTS ====================
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: headers,
    );

    final responseData = _parseResponse(response);
    return (responseData['data'] as List)
        .map((item) => Product.fromJson(item))
        .toList();
  }

  // ==================== NEWS ====================
  static Future<List<Berita>> fetchBerita() async {
    final response = await http.get(
      Uri.parse('$baseUrl/news'),
      headers: headers,
    );

    final responseData = _parseResponse(response);
    return (responseData['data'] as List)
        .map((item) => Berita.fromJson(item))
        .toList();
  }

  // ==================== HELPER METHOD ====================
  static dynamic _parseResponse(http.Response response) {
    final responseData = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      final errorMsg = responseData['message'] ??
          'Request failed with status ${response.statusCode}';
      throw Exception(errorMsg);
    }
  }

  static Future<Penduduk> registerPenduduk({
    required String nik,
    required String name,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: json.encode({
          'nik': nik,
          'name': name,
          'password': password,
        }),
      );

      final responseData = _parseResponse(response);

      // Jika backend mengembalikan token (sesuai solusi sebelumnya)
      if (responseData.containsKey('penduduk')) {
        return Penduduk.fromJson(responseData['penduduk']);
      } else {
        return Penduduk.fromJson(responseData);
      }
    } catch (e) {
      throw Exception('Gagal mendaftar: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> loginPenduduk({
    required String nik,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: json.encode({
          'nik': nik,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      throw Exception('Error saat login: $e');
    }
  }
}
