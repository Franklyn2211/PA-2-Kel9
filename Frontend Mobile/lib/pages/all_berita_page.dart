import 'package:flutter/material.dart';
import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import '../models/berita.dart'; // Sesuaikan dengan lokasi model Berita

class AllBeritaPage extends StatelessWidget {
  final List<Berita> allBerita;

  AllBeritaPage({required this.allBerita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Berita"),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: allBerita.length,
        itemBuilder: (context, index) {
          Berita berita = allBerita[index];
          return beritaItem(context, berita); // Kirim context agar bisa navigasi
        },
      ),
    );
  }

  // Widget untuk menampilkan item berita dengan navigasi
  Widget beritaItem(BuildContext context, Berita berita) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman BeritaDetailPage saat item ditekan
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
                    Text(
                      berita.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      berita.description,
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
