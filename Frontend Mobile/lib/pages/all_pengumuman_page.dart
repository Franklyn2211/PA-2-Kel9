import 'package:aplikasi_desa/pages/pengumuman_detail_pengumuman.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pengumuman.dart';
import '../services/api_service.dart';

class AllPengumumanPage extends StatelessWidget {
  final Color themeColor = const Color(0xFF3AC53E);

  const AllPengumumanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Semua Pengumuman',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder<List<Pengumuman>>(
          future: ApiService.fetchPengumuman(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            } else {
              List<Pengumuman> pengumumanList = snapshot.data!;
              return _buildPengumumanList(context, pengumumanList);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: themeColor),
          const SizedBox(height: 16),
          Text(
            'Memuat pengumuman...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat pengumuman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 80,
            color: themeColor.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada pengumuman',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pengumuman terbaru akan ditampilkan di sini',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengumumanList(BuildContext context, List<Pengumuman> pengumumanList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pengumumanList.length,
      itemBuilder: (context, index) {
        final pengumuman = pengumumanList[index];
        return _pengumumanItem(context, pengumuman);
      },
    );
  }

  Widget _pengumumanItem(BuildContext context, Pengumuman pengumuman) {
    // Format tanggal jika tersedia dalam format yang sesuai
    String formattedDate = '';
    try {
      // Mencoba parse tanggal dari string createdAt
      // Catatan: Format ini perlu disesuaikan dengan format tanggal dari API
      DateTime date = DateTime.parse(pengumuman.createdAt);
      formattedDate = DateFormat('dd MMM yyyy • HH:mm').format(date);
    } catch (e) {
      // Jika format tanggal tidak sesuai, tampilkan tanggal dari API
      formattedDate = pengumuman.createdAt;
    }

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _navigateToDetail(context, pengumuman);
        },
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Konten utama
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul pengumuman
                  Text(
                    pengumuman.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  
                  // Deskripsi pengumuman
                  Text(
                    _formatDescription(_removeHtmlTags(pengumuman.description)),
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.4,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  
                  // Footer dengan tanggal dan tombol selengkapnya
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: themeColor),
                          const SizedBox(width: 6),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: themeColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Baca Selengkapnya",
                              style: TextStyle(
                                fontSize: 12,
                                color: themeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 14, color: themeColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Indikator baru (opsional, tampilkan untuk pengumuman yang baru)
            if (_isRecentPengumuman(pengumuman))
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Baru',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _removeHtmlTags(String htmlText) {
    if (htmlText.isEmpty) return '';
    
    // Menghapus semua tag HTML
    String text = htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Mengganti entitas HTML yang umum
    text = text.replaceAll('&nbsp;', ' ')
               .replaceAll('&amp;', '&')
               .replaceAll('&lt;', '<')
               .replaceAll('&gt;', '>')
               .replaceAll('&quot;', '"')
               .replaceAll('&#39;', "'");
    
    return text.trim();
  }

  String _formatDescription(String description) {
    // Memastikan deskripsi tidak terlalu pendek dan menambahkan ellipsis
    if (description.length > 150) {
      return '${description.substring(0, 150)}...';
    }
    return description;
  }

  bool _isRecentPengumuman(Pengumuman pengumuman) {
    try {
      DateTime createdAt = DateTime.parse(pengumuman.createdAt);
      DateTime now = DateTime.now();
      // Pengumuman dianggap baru jika dibuat dalam 3 hari terakhir
      return now.difference(createdAt).inDays <= 3;
    } catch (e) {
      return false;
    }
  }

  void _navigateToDetail(BuildContext context, Pengumuman pengumuman) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengumumanDetailPage(pengumuman: pengumuman),
      ),
    );
  }
}