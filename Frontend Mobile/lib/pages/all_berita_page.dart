import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan ini
import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import '../models/berita.dart';

class AllBeritaPage extends StatelessWidget {
  final List<Berita> allBerita;

  const AllBeritaPage({Key? key, required this.allBerita}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Berita"),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: allBerita.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allBerita.length,
              itemBuilder: (context, index) {
                return _buildBeritaItem(context, allBerita[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            "Belum ada berita tersedia",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeritaItem(BuildContext context, Berita berita) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToDetail(context, berita),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBeritaImage(berita),
              const SizedBox(width: 12),
              _buildBeritaContent(berita),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeritaImage(Berita berita) {
    return Hero(
      tag: 'berita-image-${berita.id ?? ""}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          berita.photoUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBeritaContent(Berita berita) {
    // Format tanggal di sini
    final formattedDate = berita.createdAt != null
        ? DateFormat('dd MMM yyyy HH:mm').format(berita.createdAt!)
        : 'Tanggal tidak tersedia';

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            berita.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            berita.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                formattedDate, // Gunakan formattedDate yang sudah dibuat
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Berita berita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeritaDetailPage(berita: berita),
      ),
    );
  }
}