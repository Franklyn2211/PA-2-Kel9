import 'package:aplikasi_desa/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_desa/auth/auth_provider.dart';
import 'package:aplikasi_desa/pages/layanan_surat_page.dart';
import 'package:aplikasi_desa/pages/pembayaran_berhasil.dart';
import 'package:provider/provider.dart';

class AuthCheckerScreen extends StatefulWidget {
  final int productId;
  final String redirectTo;

  const AuthCheckerScreen({
    Key? key,
    required this.productId,
    this.redirectTo = 'pembayaran', // Ubah default ke 'pembayaran' karena kita punya productId
  }) : super(key: key);

  @override
  _AuthCheckerScreenState createState() => _AuthCheckerScreenState();
}

class _AuthCheckerScreenState extends State<AuthCheckerScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      // Delay untuk memastikan auth provider sudah diinisialisasi
      await Future.delayed(Duration(milliseconds: 300));

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      // Cek apakah user sudah login
      if (authProvider.user != null) {
        // User sudah login, navigasi sesuai dengan redirectTo dan productId
        _navigateBasedOnParams();
      } else {
        // User belum login, tampilkan login screen
        final bool? success = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              productId: widget.productId,
              redirectTo: widget.redirectTo,
            ),
          ),
        );

        // Jika login berhasil dan hasil navigasi adalah true
        if (success == true && mounted) {
          _navigateBasedOnParams();
        }
      }
    } catch (e) {
      debugPrint('Error in _checkAuth: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Tampilkan pesan error jika diperlukan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateBasedOnParams() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userData = authProvider.user;

    // Jika ada productId, prioritaskan navigasi ke PaymentProofScreen
    if (widget.productId > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentProofScreen(
            productId: widget.productId,
            pendudukId: userData?.id,
          ),
        ),
      );
    } 
    // Jika redirectTo adalah 'pembayaran', navigasi ke PaymentProofScreen
    else if (widget.redirectTo == 'pembayaran') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentProofScreen(
            productId: widget.productId,
            pendudukId: userData?.id,
          ),
        ),
      );
    }
    // Default: navigasi ke LayananSuratPage
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LayananSuratPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Text('Memeriksa status login...'),
      ),
    );
  }
}