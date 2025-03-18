import 'package:aplikasi_desa/pages/pilih_jenis_surat_page.dart';
import 'package:flutter/material.dart';

class LayananSuratPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Back', style: TextStyle(color: Colors.green, fontSize: 14)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul dan ikon utama
            Center(
              child: Column(
                children: [
                  Icon(Icons.article, size: 80, color: Colors.black),
                  SizedBox(height: 10),
                  Text(
                    'Layanan Surat',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StepWidget(number: '1', label: 'Memilih'),
                StepDivider(),
                StepWidget(number: '2', label: 'Mengisi'),
                StepDivider(),
                StepWidget(number: '3', label: 'Kirim'),
              ],
            ),
            SizedBox(height: 40),

            // List Langkah
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StepDetailWidget(icon: Icons.chat_bubble_outline, text: 'Memilih jenis surat yang ingin diurus'),
                StepDetailWidget(icon: Icons.add, text: 'Mengisi Form'),
                StepDetailWidget(icon: Icons.check_box, text: 'Review Form yang di isi'),
              ],
            ),

            Spacer(),

            // Tombol Mulai
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Pilih Jenis Surat
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PilihJenisSuratPage(),
                    ),
                  );
                },
                child: Text('Mulai', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Widget untuk langkah-langkah
class StepWidget extends StatelessWidget {
  final String number;
  final String label;

  const StepWidget({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          child: Text(number, style: TextStyle(fontSize: 18, color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
} 

// Widget untuk garis antara langkah
class StepDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 3,
      color: Colors.green,
    );
  }
}

// Widget untuk daftar langkah dengan ikon
class StepDetailWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const StepDetailWidget({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 40),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
