import 'package:flutter/material.dart';
import '../models/berita.dart'; // Sesuaikan dengan lokasi model Berita

class BeritaDetailPage extends StatelessWidget {
  final Berita berita;

  BeritaDetailPage({required this.berita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Hilangkan shadow di AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          "Detail Berita",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul berita
            Center(
              child: Text(
                berita.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),

            SizedBox(height: 10),

            // Tanggal berita
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  "Diterbitkan pada: ${berita.createdAt.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Gambar berita dengan shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  berita.photoUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 7),
            Text(
              berita.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.5, // Tinggi baris untuk keterbacaan yang lebih baik
              ),
            ),
          ],
        ),
      ),
    );
  }
}
