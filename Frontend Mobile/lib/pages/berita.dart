import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/berita.dart';
import '../services/api_service.dart';
import 'all_berita_page.dart';
<<<<<<< HEAD
=======
import 'package:html_unescape/html_unescape.dart'; // Import package html_unescape
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520

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
<<<<<<< HEAD
=======
  }

  // Fungsi untuk menghapus tag HTML dari teks
  String _removeHtmlTags(String htmlText) {
    return htmlUnescape.convert(htmlText)
        .replaceAll(RegExp(r'<[^>]*>'), '') // Hapus tag HTML
        .replaceAll(RegExp(r'\s+'), ' ') // Ganti multiple spasi dengan satu spasi
        .trim();
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Berita Desa",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Berita>>(
        future: futureBerita,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
<<<<<<< HEAD
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[700],
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    color: Colors.grey[500],
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada berita ditemukan',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
=======
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
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520
                    ),
                  ),
                ],
              ),
            );
          } else {
            List<Berita> sortedBerita = snapshot.data!
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            List<Berita> limitedBerita = sortedBerita.take(5).toList();

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[50]!, Colors.white],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.article,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Berita Terbaru",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: limitedBerita.length,
                      itemBuilder: (context, index) {
                        Berita berita = limitedBerita[index];
                        return beritaItem(berita);
                      },
                    ),
                  ),
                  if (sortedBerita.length > 5)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Lihat Semua Berita",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget beritaItem(Berita berita) {
<<<<<<< HEAD
    // Format date for display
    final DateTime date = berita.createdAt;
    final String formattedDate = "${date.day}/${date.month}/${date.year}";
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeritaDetailPage(berita: berita),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar berita
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                berita.photoUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            // Keterangan berita
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    berita.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    berita.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BeritaDetailPage(berita: berita),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue[800],
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Baca Selengkapnya",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
=======
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
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520
              ),
            ],
          ),
        ),
      ),
    );
  }
}