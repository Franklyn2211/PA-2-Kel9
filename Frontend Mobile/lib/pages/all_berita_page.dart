import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' show parse; // Untuk parsing HTML
import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import '../models/berita.dart';

class AllBeritaPage extends StatelessWidget {
  final List<Berita> allBerita;

  const AllBeritaPage({Key? key, required this.allBerita}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Icon back putih
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Semua Berita",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Color(0xFF3AC53E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Container(
        color: Colors.grey[100], // Background color untuk seluruh halaman
        child: allBerita.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allBerita.length,
                itemBuilder: (context, index) {
                  return _buildBeritaItem(context, allBerita[index]);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 80,
            color: Color(0xFF3AC53E),
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
          SizedBox(height: 8),
          Text(
            "Cek kembali nanti untuk informasi terbaru",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Hero(
                tag: 'berita-image-${berita.id ?? ""}',
                child: Image.network(
                  berita.photoUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    berita.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _stripHtmlTags(berita.description),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoFooter(berita),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoFooter(Berita berita) {
    final formattedDate = berita.createdAt != null
        ? DateFormat('dd MMM yyyy • HH:mm').format(berita.createdAt!)
        : 'Tanggal tidak tersedia';

    return Row(
      children: [
        Icon(Icons.calendar_today, size: 16, color: Color(0xFF3AC53E)),
        const SizedBox(width: 6),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF3AC53E).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.arrow_forward, size: 14, color: Color(0xFF3AC53E)),
              SizedBox(width: 4),
              Text(
                "Selengkapnya",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3AC53E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menghapus tag HTML dari teks
  String _stripHtmlTags(String htmlString) {
    if (htmlString == null || htmlString.isEmpty) {
      return '';
    }
    
    var document = parse(htmlString);
    String parsedString = document.body!.text;
    
    // Mengganti entitas HTML yang umum
    parsedString = parsedString.replaceAll('&nbsp;', ' ');
    parsedString = parsedString.replaceAll('&amp;', '&');
    parsedString = parsedString.replaceAll('&lt;', '<');
    parsedString = parsedString.replaceAll('&gt;', '>');
    
    return parsedString.trim();
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