import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/userpenduduk.dart';

class AuthProvider with ChangeNotifier {
  Penduduk? _user;

  Penduduk? get user => _user;

  // Getter untuk pendudukId
  int? get pendudukId => _user?.id;

  // Method untuk menyimpan data user dari response API
  // Method setUser yang diperbaiki
  Future<void> setUser(Map<String, dynamic> userData) async {
  debugPrint('Raw user data: $userData');
  
  // Cari ID di berbagai kemungkinan field
  final dynamic id = userData['id'] ?? 
                   userData['penduduk_id'] ??
                   userData['data']['id'] ??
                   userData['penduduk']['id'];

  if (id == null) {
    throw Exception('Tidak bisa menemukan ID dalam response');
  }

  _user = Penduduk(
    id: int.parse(id.toString()), // Pastikan konversi ke int
    nik: userData['nik'] ?? userData['data']['nik'] ?? '',
    name: userData['name'] ?? userData['nama'] ?? userData['data']['name'] ?? '',
    password: userData['password'] ?? '',
  );

  await _saveUserToPrefs();
  notifyListeners();
}

  // Method private untuk menyimpan data ke SharedPreferences
  Future<void> _saveUserToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_user != null) {
        await prefs.setString('nik', _user!.nik);
        await prefs.setString('name', _user!.name);

        // Simpan id dengan pengecekan null
        if (_user!.id != null) {
          await prefs.setInt('id', _user!.id!);
          debugPrint('Saved user ID to prefs: ${_user!.id}');
        } else {
          debugPrint('WARNING: Cannot save null user ID to prefs');
        }

        // Simpan password jika ada
        if (_user!.password != null) {
          await prefs.setString('password', _user!.password!);
        }
      }
    } catch (e) {
      debugPrint('Error saving to SharedPreferences: $e');
    }
  }

  // Load user dari SharedPreferences
  Future<bool> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final nik = prefs.getString('nik');
      final name = prefs.getString('name');
      final id = prefs.getInt('id');
      final password = prefs.getString('password');

      debugPrint('Loading user from prefs: nik=$nik, name=$name, id=$id');

      if (nik != null && name != null && id != null) {
        _user = Penduduk(
          nik: nik,
          name: name,
          password: password,
          id: id,
        );

        debugPrint('User loaded from prefs: $_user');
        debugPrint('User ID from prefs: ${_user?.id}');

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error loading from SharedPreferences: $e');
      return false;
    }
  }

  // Login dengan objek Penduduk
  Future<void> login(Penduduk penduduk) async {
    try {
      _user = penduduk;
      debugPrint('Login with user: $_user');
      debugPrint('Login user ID: ${_user?.id}');

      await _saveUserToPrefs();
      notifyListeners();
    } catch (e) {
      debugPrint('Error during login: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _user = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      notifyListeners();
      debugPrint('User logged out and prefs cleared');
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }

  // Method untuk debugging
  void printUserInfo() {
    debugPrint('Current user: $_user');
    if (_user != null) {
      debugPrint('User details:');
      debugPrint('ID: ${_user!.id}');
      debugPrint('NIK: ${_user!.nik}');
      debugPrint('Name: ${_user!.name}');
    } else {
      debugPrint('No user logged in');
    }
  }
}
