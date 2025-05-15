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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isVerified = false;
  String? _errorMessage;
  Penduduk? _pendudukData;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nikController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyNik() async {
    if (_nikController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'NIK tidak boleh kosong';
      });
      return;
    }
    
    final nik = _nikController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _pendudukData = null;
    });

    if (nik.length != 16) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'NIK harus 16 digit';
      });
      return;
    }

    try {
      final response = await ApiService.verifyNik(nik);
      print('API Response: ${response.data}');

      setState(() {
        if (response.data.isNotEmpty) {
          _pendudukData = response.data.first;
          _isVerified = true;
        } else {
          _errorMessage = 'NIK tidak ditemukan';
          _isVerified = false;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
        _isVerified = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Password tidak cocok';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Debugging untuk memastikan data yang dikirim
      print("Data dikirim ke API:");
      print("NIK: ${_nikController.text.trim()}");
      print("Name: ${_pendudukData?.name}");
      print("Password: ${_passwordController.text.trim()}");

      // Panggil API registrasi
      final penduduk = await ApiService.registerPenduduk(
        nik: _nikController.text.trim(),
        name: _pendudukData?.name ?? '',
        password: _passwordController.text.trim(),
      );

      // Jika berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi berhasil!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        )
      );

      // Navigasi ke halaman lain jika perlu
      // Navigator.pushReplacement(context, ...);

    } catch (e) {
      setState(() {
        _errorMessage = 'Registrasi gagal: ${e.toString().replaceAll('Exception: ', '')}';
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
      appBar: AppBar(
        title: Text('Verifikasi NIK dan Registrasi'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  if (!_isVerified) ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.verified_user,
                            size: 80,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Verifikasi NIK',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Masukkan NIK Anda untuk verifikasi data',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                  
                  // NIK input section
                  if (!_isVerified) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nikController,
                        decoration: InputDecoration(
                          labelText: 'NIK',
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                          hintText: 'Masukkan 16 digit NIK',
                          errorText: _errorMessage,
                          prefixIcon: Icon(
                            Icons.credit_card,
                            color: Theme.of(context).primaryColor,
                          ),
                          suffixIcon: _isLoading
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: EdgeInsets.all(8),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: _verifyNik,
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
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
                    ),
                    SizedBox(height: 24),
                    
                    // Tips section
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'NIK terdiri dari 16 digit angka yang tertera pada KTP Anda',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // Data verification result and registration form
                  if (_isVerified) ...[
                    // Verified user info card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verifikasi Berhasil',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    'Data ditemukan',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Data Diri',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'NIK:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _nikController.text,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Nama:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _pendudukData?.name ?? 'Tidak diketahui',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Registration form title
                    Text(
                      'Buat Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Buat password untuk akun Anda',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Registration form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Password field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                                hintText: 'Minimal 6 karakter',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukkan password';
                                }
                                if (value.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Confirm password field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Konfirmasi Password',
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                                hintText: 'Masukkan ulang password',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                              ),
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukkan konfirmasi password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Password tidak cocok';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Password requirements info
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber.shade100),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.amber.shade700,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Password harus terdiri dari minimal 6 karakter untuk keamanan akun Anda',
                                    style: TextStyle(
                                      color: Colors.amber.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          
                          // Error message display
                          if (_errorMessage != null)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 24),
                          
                          // Register button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Text(
                                      'DAFTAR',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}