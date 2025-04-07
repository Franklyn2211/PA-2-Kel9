import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/berita.dart';
import '../services/api_service.dart';
import 'all_berita_page.dart';
import 'package:html_unescape/html_unescape.dart'; // Import package html_unescape

class BeritaPage extends StatefulWidget {
  @override
  _BeritaPageState createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  late Future<List<Berita>> futureBerita;
  final HtmlUnescape htmlUnescape = HtmlUnescape(); // Buat instance HtmlUnescape

  @override
  void initState() {
    super.initState();
    futureBerita = ApiService.fetchBerita();
  }

  // Fungsi untuk menghapus tag HTML dari teks
  String _removeHtmlTags(String htmlText) {
    return htmlUnescape.convert(htmlText)
        .replaceAll(RegExp(r'<[^>]*>'), '') // Hapus tag HTML
        .replaceAll(RegExp(r'\s+'), ' ') // Ganti multiple spasi dengan satu spasi
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Berita Desa"),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<List<Berita>>(
        future: futureBerita,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada berita ditemukan'));
          } else {
            List<Berita> sortedBerita = snapshot.data!..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            List<Berita> limitedBerita = sortedBerita.take(5).toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: limitedBerita.length,
                    itemBuilder: (context, index) {
                      Berita berita = limitedBerita[index];
                      return beritaItem(berita);
                    },
                  ),
                ),
                if (sortedBerita.length > 5)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllBeritaPage(
                              allBerita: sortedBerita,
                            ),
                          ),
                        );
                      },
                      child: Text("Lihat Semua Berita",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget beritaItem(Berita berita) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BeritaDetailPage(berita: berita),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  berita.photoUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(berita.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text(
                      _removeHtmlTags(berita.description), // Gunakan fungsi untuk menghapus HTML
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}