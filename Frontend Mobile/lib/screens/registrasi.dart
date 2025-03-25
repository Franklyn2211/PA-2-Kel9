import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/penduduk.dart';
import '../services/api_service.dart';

class NikVerificationScreen extends StatefulWidget {
  @override
  _NikVerificationScreenState createState() => _NikVerificationScreenState();
}

class _NikVerificationScreenState extends State<NikVerificationScreen> {
  final _nikController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Penduduk? _pendudukData;

  @override
  void dispose() {
    _nikController.dispose();
    super.dispose();
  }

  Future<void> _verifyNik() async {
    final nik = _nikController.text.trim();

    // Reset state setiap kali verifikasi dimulai
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _pendudukData = null;
    });

    // Validasi panjang NIK
    if (nik.length != 16) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'NIK harus 16 digit';
      });
      return;
    }

    try {
      final response = await ApiService.verifyNik(nik);
      
      // Debugging: Cetak response ke console
      print('API Response: ${response.data}');

      setState(() {
        if (response.data.isNotEmpty) {
          _pendudukData = response.data.first;
        } else {
          _errorMessage = 'NIK tidak ditemukan';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verifikasi NIK')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nikController,
              decoration: InputDecoration(
                labelText: 'NIK',
                hintText: 'Masukkan 16 digit NIK',
                errorText: _errorMessage,
                suffixIcon: _isLoading
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(Icons.verified_user),
                        onPressed: _verifyNik,
                      ),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
              onChanged: (value) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
            ),
            SizedBox(height: 20),
            if (_pendudukData != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Nama: ${_pendudukData!.name}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}