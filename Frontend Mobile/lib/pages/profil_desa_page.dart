import 'package:flutter/material.dart';
import 'package:aplikasi_desa/services/api_service.dart';
import 'package:html/parser.dart';

class ProfilDesaPage extends StatefulWidget {
  const ProfilDesaPage({Key? key}) : super(key: key);

  @override
  _ProfilDesaPageState createState() => _ProfilDesaPageState();
}

class _ProfilDesaPageState extends State<ProfilDesaPage> {
  Map<String, dynamic>? profilDesa;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfilDesa();
  }

  Future<void> _fetchProfilDesa() async {
    try {
      final data = await ApiService.fetchProfilDesa();
      setState(() {
        profilDesa = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat profil desa: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _removeHtmlTags(String htmlText) {
    final document = parse(htmlText);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Desa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF3AC53E),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF3AC53E)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Memuat data...',
                    style: TextStyle(
                      color: Color(0xFF3AC53E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : profilDesa == null
              ? _buildErrorState()
              : _buildProfilContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Profil desa tidak tersedia',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _fetchProfilDesa();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3AC53E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            icon: Icons.history,
            title: 'Sejarah Desa',
            content: _removeHtmlTags(profilDesa!['history'] ?? 'Tidak tersedia'),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            icon: Icons.visibility,
            title: 'Visi',
            content: _removeHtmlTags(profilDesa!['visi'] ?? 'Tidak tersedia'),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            icon: Icons.assignment,
            title: 'Misi',
            content: _removeHtmlTags(profilDesa!['misi'] ?? 'Tidak tersedia'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF3AC53E).withOpacity(0.2),
                  child: Icon(
                    icon,
                    color: const Color(0xFF3AC53E),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}