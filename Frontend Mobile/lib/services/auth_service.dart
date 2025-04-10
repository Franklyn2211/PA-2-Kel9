import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _prefsKey = 'last_activity';
  static const _sessionDuration = Duration(hours: 2); // 2 jam tidak aktif

  // Simpan token login
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    _updateLastActivity();
  }

  // Dapatkan token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Hapus token (logout)
  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  // Update waktu aktivitas terakhir
  static Future<void> _updateLastActivity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Cek apakah session masih valid
  static Future<bool> isSessionValid() async {
    final token = await getToken();
    if (token == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final lastActivity = prefs.getInt(_prefsKey) ?? 0;
    final lastActiveTime = DateTime.fromMillisecondsSinceEpoch(lastActivity);
    final currentTime = DateTime.now();

    return currentTime.difference(lastActiveTime) < _sessionDuration;
  }


  static Future<void> updateLastActivity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, DateTime.now().millisecondsSinceEpoch);
  }
}
