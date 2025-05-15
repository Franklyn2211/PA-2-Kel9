import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pengumuman.dart';
import 'package:share_plus/share_plus.dart';

class PengumumanDetailPage extends StatelessWidget {
  final Pengumuman pengumuman;
  final Color themeColor = const Color(0xFF3AC53E);

  const PengumumanDetailPage({Key? key, required this.pengumuman}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format tanggal jika tersedia
    String formattedDate = '';
    try {
      DateTime date = DateTime.parse(pengumuman.createdAt);
      formattedDate = DateFormat('dd MMMM yyyy • HH:mm').format(date);
    } catch (e) {
      formattedDate = pengumuman.createdAt;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar dengan efek scroll
          _buildAppBar(context),
          
          // Konten utama
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge kategori (jika ada)
                  // Judul pengumuman
                  Text(
                    pengumuman.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Informasi waktu publikasi
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: themeColor),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  
                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.grey[300], thickness: 1),
                  ),
                  
                  // Isi pengumuman
                  Text(
                    _removeHtmlTags(pengumuman.description),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  // Tombol aksi di bagian bawah
                  _buildActionButtons(context),
                  
                  // Tambahan space di bawah untuk scroll lebih nyaman
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      // Floating Action Button untuk share
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: () => _sharePengumuman(context),
        child: const Icon(Icons.share, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: themeColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Detail Pengumuman',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeColor,
                themeColor.withGreen(themeColor.green - 40),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Elemen dekoratif (opsional)
              Positioned(
                right: -30,
                bottom: -30,
                child: Icon(
                  Icons.campaign,
                  size: 150,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // Tombol favorite/bookmark (opsional)
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Pengumuman disimpan'),
                backgroundColor: themeColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lampiran',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              // Implementasi untuk membuka lampiran
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.attach_file,
                      color: themeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dokumen Lampiran', // Atau nama file asli jika tersedia
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap untuk membuka',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.download,
                    color: themeColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _sharePengumuman(context),
            icon: const Icon(Icons.share),
            label: const Text('Bagikan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Menampilkan pengumuman terkait (opsional)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Menampilkan pengumuman terkait'),
                  backgroundColor: themeColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context); // Kembali ke daftar pengumuman
            },
            icon: const Icon(Icons.list_alt),
            label: const Text('Pengumuman Lain'),
            style: OutlinedButton.styleFrom(
              foregroundColor: themeColor,
              side: BorderSide(color: themeColor),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _sharePengumuman(BuildContext context) {
    final String shareText = 'Pengumuman: ${pengumuman.title}\n\n${_removeHtmlTags(pengumuman.description)}\n\nTanggal: ${pengumuman.createdAt}';
    
    Share.share(shareText, subject: pengumuman.title);
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
}