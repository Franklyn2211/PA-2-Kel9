import 'dart:convert';
import 'package:aplikasi_desa/models/penduduk.dart';
import 'package:aplikasi_desa/models/pengumuman.dart';
import 'package:aplikasi_desa/models/userpenduduk.dart';
import 'package:http/http.dart' as http;
import '../models/penduduk_response.dart';
import '../models/product_model.dart';
import '../models/berita.dart';
import '../models/umkm.dart';
import '../models/staff_model.dart'; // Import model Staff
import '../models/gallery_model.dart'; // Import model Gallery
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://c444-103-167-217-200.ngrok-free.app/api";
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true'
  };

  String getBaseUrl() {
    return 'https://c444-103-167-217-200.ngrok-free.app'; // Replace with your actual base URL
  }

  // ==================== NIK VERIFICATION ====================
  // services/api_service.dart
  static Future<PendudukResponse> verifyNik(String nik) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/resident?nik=$nik'),
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
        .toList()
        ..sort((a, b) {
            if (a.createdAt == null && b.createdAt == null) return 0;
            if (a.createdAt == null) return 1;
            if (b.createdAt == null) return -1;
            return b.createdAt!.compareTo(a.createdAt!);
        });
  }
  // ==================== PENDUDUK ====================
  static Future<List<Residents>> fetchPenduduk() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pendudukku'),
      headers: headers,
    );

    final responseData = _parseResponse(response);
    return (responseData['data'] as List)
        .map((item) => Residents.fromJson(item))
        .toList();
  }

  // ==================== UMKM ====================
  static Future<List<Umkm>> fetchUmkm() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/umkm'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Umkm.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load UMKM. Status code: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      throw Exception('Invalid JSON format: $e');
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
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
  // ==================== PENGUMUMAN ====================
  static Future<List<Pengumuman>> fetchPengumuman() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pengumuman'),
      headers: headers,
    );

    final responseData = _parseResponse(response);
    return (responseData['data'] as List)
        .map((item) => Pengumuman.fromJson(item))
        .toList();
  }

  // ==================== STAFF ====================
  static Future<List<Staff>> fetchStaff() async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff'), // Perbaiki endpoint menjadi /staff
      headers: headers,
    );

    final responseData = _parseResponse(response);
    return (responseData['data'] as List)
        .map((item) => Staff.fromJson(item))
        .toList(); // Konversi data ke List<Staff>
  }

  // ==================== GALLERY ====================
  static Future<List<Gallery>> fetchGallery() async {
    final response = await http.get(
      Uri.parse('$baseUrl/galeri'), // Endpoint untuk galeri
      headers: headers,
    );

    final responseData = _parseResponse(response);
    return (responseData['data'] as List)
        .map((item) => Gallery.fromJson(item))
        .toList(); // Konversi data ke List<Gallery>
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

  static Future<Resident> registerPenduduk({
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

      if (responseData.containsKey('resident')) {
        return Resident.fromJson(responseData['resident']);
      } else {
        return Resident.fromJson(responseData);
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

  static Future<Map<String, dynamic>> createOrder({
    required int pendudukId,
    required int productId,
    required String amount,
    required String note,
    required File buktiTransfer,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/orders'),
      );

      // Tambahkan fields
      request.fields['penduduk_id'] = pendudukId.toString();
      request.fields['product_id'] = productId.toString();
      request.fields['amount'] = amount;
      request.fields['note'] = note;
      request.fields['status'] = 'pending';

      // Add file dengan nama field yang sesuai backend
      var file = await http.MultipartFile.fromPath(
        'bukti_transfer',  // Ubah dari bukti_transfer
        buktiTransfer.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(file);

      // Kirim request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        try {
          return {
            'success': true,
            'data': json.decode(responseData),
          };
        } catch (e) {
          throw Exception('Invalid JSON format in response: $responseData');
        }
      } else {
        if (response.headers['content-type']?.contains('text/html') == true) {
          throw Exception('Unexpected HTML response: $responseData');
        }
        try {
          final errorData = json.decode(responseData);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Validation error',
          };
        } catch (e) {
          throw Exception('Unexpected response: $responseData');
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getProductById(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          // Tambahkan header authorization jika diperlukan
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Gagal mengambil data produk');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: ${e.toString()}');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Pastikan token disimpan dengan key 'auth_token'
  }

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('HTTP Status Code: ${response.statusCode}'); // Debug print
    print('Raw Response Body: ${response.body}'); // Debug print

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.body}');
    }
  }
  static Future<List<Map<String, dynamic>>> fetchUserOrders(int pendudukId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders?penduduk_id=$pendudukId'),
      headers: headers,
    );

    final responseData = _parseResponse(response);
    return List<Map<String, dynamic>>.from(responseData['data']);
  }

  static Future<Map<String, dynamic>> fetchProfilDesa() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profildesa'),
      headers: headers,
    );

    final responseData = _parseResponse(response);
    return responseData['data']; // Kembalikan data profil desa
  }
}
