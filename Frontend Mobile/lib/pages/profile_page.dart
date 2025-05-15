import 'dart:developer'; // Import untuk debug log
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import '../pages/login_screen.dart';
import '../pages/order_page.dart'; // Import OrderPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color themeColor = const Color(0xFF3AC53E);
  bool isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final residentDetails = authProvider.residentDetails;
    final bool isLoggedIn = user != null || residentDetails != null;

    // Debug log untuk memeriksa data yang diterima
    log('User data: ${user?.toJson()}');
    log('Resident details: ${residentDetails != null ? residentDetails.toJson() : "null"}');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: themeColor,
        elevation: 0,
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: isRefreshing ? null : () => _refreshData(authProvider),
              tooltip: 'Segarkan Data',
            ),
        ],
      ),
      body: isRefreshing
          ? _buildLoadingState()
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(context, user, residentDetails),
                  const SizedBox(height: 16),
                  if (isLoggedIn)
                    _buildProfileDetails(context, user, residentDetails),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, authProvider, isLoggedIn),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(themeColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'Memperbarui data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, dynamic user, dynamic residentDetails) {
    final name = residentDetails?.name ?? user?.name ?? 'Nama tidak tersedia';
    final nik = residentDetails?.nik ?? user?.nik ?? 'NIK tidak tersedia';
    final bool isLoggedIn = user != null || residentDetails != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.9),
            child: Icon(
              Icons.person,
              size: 60,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isLoggedIn ? name : 'Tamu',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (isLoggedIn) ...[
            const SizedBox(height: 6),
            Text(
              nik,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            Text(
              'Silahkan login untuk melihat profil Anda',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileDetails(
      BuildContext context, dynamic user, dynamic residentDetails) {
    // Kumpulkan data profil yang tersedia
    Map<String, String> profileData = {};

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, AuthProvider authProvider, bool isLoggedIn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Order History Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final userId = authProvider.user?.id ?? 0;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(userId: userId),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Pesanan Saya'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: themeColor,
                elevation: 1,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: themeColor, width: 1),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (isLoggedIn) {
                  // Logout
                  _showLogoutConfirmation(context, authProvider);
                } else {
                  // Navigate to Login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
              label: Text(isLoggedIn ? 'Keluar' : 'Masuk'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLoggedIn ? Colors.red.shade50 : themeColor,
                foregroundColor: isLoggedIn ? Colors.red : Colors.white,
                elevation: 1,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isLoggedIn ? Colors.red : Colors.transparent,
                    width: 1,
                  ),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(
      BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Anda yakin ingin keluar dari akun ini?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              authProvider.logout();
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData(AuthProvider authProvider) async {
    setState(() {
      isRefreshing = true;
    });

    try {
      // Di sini Anda bisa menambahkan logika untuk memperbarui data pengguna
      // Misalnya memanggil API untuk mendapatkan data terbaru
      log('Fetching latest user data...');

      // Simulasi delay network request
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Implementasikan pembaruan data dari server
      // Contoh: await authProvider.refreshUserData();

      // Debug log untuk memeriksa data setelah refresh
      final user = authProvider.user;
      final residentDetails = authProvider.residentDetails;
      log('User data after refresh: ${user?.toJson()}');
      log('Resident details after refresh: ${residentDetails != null ? residentDetails.toJson() : "null"}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data profil berhasil diperbarui'),
            backgroundColor: themeColor,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
          ),
        );
      }
    } catch (e) {
      log('Error refreshing data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isRefreshing = false;
        });
      }
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
