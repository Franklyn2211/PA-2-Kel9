import 'package:aplikasi_desa/auth/auth_provider.dart';
import 'package:aplikasi_desa/pages/pembayaran_berhasil.dart';
import 'package:aplikasi_desa/pages/layanan_surat_page.dart';
import 'package:aplikasi_desa/screens/registrasi.dart';
import 'package:aplikasi_desa/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  final int? productId; // Add productId parameter
  final String? redirectTo;

  const LoginScreen({
    Key? key,
    this.productId,
    this.redirectTo = 'layanan-surat',
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  

  @override
  void dispose() {
    _nikController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.loginPenduduk(
        nik: _nikController.text,
        password: _passwordController.text,
      );

      if (response['success']) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.setUser(response['data']);
        print('Data respons login: ${response['data']}');
        print('User setelah login: ${authProvider.user?.toJson()}');
        print('User ID: ${authProvider.user?.id}');

        // Navigasi setelah login berhasil
        if (mounted) {
          if (widget.productId != null) {
            // Jika ada productId, langsung navigasi ke PaymentProofScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentProofScreen(
                  productId: widget.productId!,
                  pendudukId: authProvider.user?.id,
                ),
              ),
            );
          } else {
            // Jika tidak ada productId, navigasi ke LayananSuratPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LayananSuratPage()),
            );
          }
        }
      } else {
        // Handle login failure
        setState(() {
          _errorMessage =
              response['message'] ?? 'Login gagal. Silakan coba lagi.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ProductID yang diterima: ${widget.productId}'); // Debug
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.2),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'Silakan login untuk melanjutkan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 40),

                    // NIK Field
                    TextFormField(
                      controller: _nikController,
                      decoration: InputDecoration(
                        labelText: 'NIK',
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIK harus diisi';
                        }
                        if (value.length != 16) {
                          return 'NIK harus 16 digit';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                                () => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password harus diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('MASUK'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NikVerificationScreen(),
                          ),
                        );
                      },
                      child: Text('Belum punya akun? Daftar sekarang'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
