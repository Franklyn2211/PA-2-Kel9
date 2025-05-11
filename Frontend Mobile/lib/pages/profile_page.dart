import 'dart:developer'; // Import untuk debug log
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import '../pages/login_screen.dart';
import '../pages/order_page.dart'; // Import OrderPage

class ProfilePage extends StatelessWidget {
  final Color themeColor = const Color(0xFF3AC53E);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final residentDetails = authProvider.residentDetails;

    // Debug log untuk memeriksa data yang diterima
    log('User data: ${user?.toJson()}');
    log('Resident details: ${residentDetails != null ? residentDetails.toJson() : "null"}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: themeColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              log('Refreshing profile data...');
              // Simulasikan refresh data
              await _refreshData(authProvider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Icon
            CircleAvatar(
              radius: 50,
              backgroundColor: themeColor.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 60,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 16),

            // User Name
            Text(
              residentDetails?.name ?? user?.name ?? 'Nama tidak tersedia',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // User Email or Placeholder
            Text(
              residentDetails?.nik ?? user?.nik ?? 'NIK tidak tersedia',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // User Details
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Alamat', residentDetails?.address ?? 'Tidak tersedia'),
                    const Divider(),
                    _buildDetailRow('Tanggal Lahir', residentDetails?.birthDate ?? 'Tidak tersedia'),
                    const Divider(),
                    _buildDetailRow('Agama', residentDetails?.religion ?? 'Tidak tersedia'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logout or Login Button
            ElevatedButton(
              onPressed: () {
                if (user != null || residentDetails != null) {
                  // Logout
                  authProvider.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  // Navigate to Login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                user != null || residentDetails != null ? 'Logout' : 'Login',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // View Orders Button
            ElevatedButton(
              onPressed: () {
                final userId = Provider.of<AuthProvider>(context, listen: false).user?.id ?? 0; // Ambil userId dari AuthProvider
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(userId: userId), // Kirim userId ke OrderPage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lihat Pesanan Saya',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData(AuthProvider authProvider) async {
    // Simulasikan refresh data
    log('Fetching latest user data...');
    final user = authProvider.user;
    final residentDetails = authProvider.residentDetails;

    // Debug log untuk memeriksa data setelah refresh
    log('User data after refresh: ${user?.toJson()}');
    log('Resident details after refresh: ${residentDetails != null ? residentDetails.toJson() : "null"}');
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
