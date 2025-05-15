// models/penduduk_response.dart
import 'penduduk.dart';

class PendudukResponse {
  final List<Residents> data;

  PendudukResponse({
    required this.data,
  });

  factory PendudukResponse.fromJson(Map<String, dynamic> json) {
    return PendudukResponse(
      data: (json['data'] as List)
          .map((item) => Residents.fromJson(item))
          .toList(),
    );
  }

  // Helper getter
  bool get success => data.isNotEmpty;
  String get message => data.isNotEmpty ? 'Data ditemukan' : 'Data tidak ditemukan';
}