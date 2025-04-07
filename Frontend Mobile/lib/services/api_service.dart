import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/penduduk_response.dart';
import '../models/product_model.dart';
import '../models/berita.dart';

class ApiService {
  static const String baseUrl =
      "https://fd35-103-167-217-200.ngrok-free.app/api";
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
}
