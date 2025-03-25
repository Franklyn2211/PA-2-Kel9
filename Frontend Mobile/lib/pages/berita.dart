import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/berita.dart'; // Sesuaikan dengan lokasi model Berita
import '../services/api_service.dart'; // Sesuaikan dengan lokasi ApiService
import 'all_berita_page.dart'; // Halaman untuk menampilkan semua berita

class BeritaPage extends StatefulWidget {
  @override
  _BeritaPageState createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  late Future<List<Berita>> futureBerita;

  @override
  void initState() {
    super.initState();
    futureBerita = ApiService.fetchBerita(); // Panggil API untuk mendapatkan data berita
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
            // Urutkan berita berdasarkan createdAt (terbaru di atas, terlama di bawah)
            List<Berita> sortedBerita = snapshot.data!..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            // Ambil hanya 5 berita pertama setelah diurutkan
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
                        // Navigasi ke halaman AllBeritaPage
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
                      style: TextStyle(color: Colors.white),),
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

  // Widget untuk menampilkan item berita
  // Widget untuk menampilkan item berita
Widget beritaItem(Berita berita) {
  return InkWell(
    onTap: () {
      // Navigasi ke halaman BeritaDetailPage
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
            // Gambar berita
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
            // Keterangan berita
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(berita.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(berita.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700])),
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