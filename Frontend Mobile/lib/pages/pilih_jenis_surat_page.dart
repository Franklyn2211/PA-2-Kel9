import 'package:flutter/material.dart';
import 'form_surat_page.dart'; // Import halaman form

class PilihJenisSuratPage extends StatefulWidget {
  @override
  _PilihJenisSuratPageState createState() => _PilihJenisSuratPageState();
}

class _PilihJenisSuratPageState extends State<PilihJenisSuratPage> {
  String? selectedSurat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text('Layanan Surat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Surat apaan nih yang mau kamu urus?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedSurat,
              hint: Text('Pilih'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSurat = newValue;
                });
                if (newValue != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormSuratPage(jenisSurat: newValue),
                    ),
                  );
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'Surat Tidak Mampu',
                  child: Text('Surat Tidak Mampu'),
                ),
                DropdownMenuItem(
                  value: 'Surat Keterangan Domisili',
                  child: Text('Surat Keterangan Domisili'),
                ),
                // Tambahkan jenis surat lainnya di sini
              ],
            ),
          ],
        ),
      ),
    );
  }
}