import 'package:flutter/material.dart';
import 'form_surat_page.dart'; // Import halaman form

class PilihJenisSuratPage extends StatefulWidget {
  const PilihJenisSuratPage({Key? key}) : super(key: key);

  @override
  State<PilihJenisSuratPage> createState() => _PilihJenisSuratPageState();
}

class _PilihJenisSuratPageState extends State<PilihJenisSuratPage> {
  String? selectedSurat;
  
  final List<Map<String, String>> jenisSurat = [
    {'value': 'Surat Tidak Mampu', 'label': 'Surat Tidak Mampu'},
    {'value': 'Surat Keterangan Domisili', 'label': 'Surat Keterangan Domisili'},
    {'value': 'Surat Keterangan Usaha', 'label': 'Surat Keterangan Usaha'},
    {'value': 'Surat Pengantar', 'label': 'Surat Pengantar'},
    {'value': 'Surat Keterangan Kelahiran', 'label': 'Surat Keterangan Kelahiran'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Layanan Surat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Surat apaan nih yang mau kamu urus?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih jenis surat yang kamu butuhkan dari daftar di bawah',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            
            // Dropdown dengan dekorasi
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200]!,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSurat,
                  isExpanded: true,
                  hint: const Text('Pilih jenis surat'),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  borderRadius: BorderRadius.circular(8),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSurat = newValue;
                    });
                  },
                  items: jenisSurat
                      .map<DropdownMenuItem<String>>((Map<String, String> item) {
                    return DropdownMenuItem<String>(
                      value: item['value'],
                      child: Text(item['label']!),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Tombol lanjutkan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedSurat == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormSuratPage(jenisSurat: selectedSurat!),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  disabledBackgroundColor: Colors.blue[200],
                ),
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}