import 'package:aplikasi_desa/pages/pilih_jenis_surat_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';

class LayananSuratPage extends StatelessWidget {
  const LayananSuratPage({Key? key}) : super(key: key);

  // Theme color constant
  static const Color themeColor = Color(0xFF3AC53E);

  @override
  Widget build(BuildContext context) {
    final pendudukId = Provider.of<AuthProvider>(context, listen: false).pendudukId;
    print('PendudukId yang diterima: $pendudukId');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: themeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kembali',
          style: TextStyle(
            color: themeColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleSpacing: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE8F8E9)], // Light green gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul dan ikon utama
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Layanan Surat',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Urus surat kependudukan dengan mudah',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Progress Indicator
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StepWidget(
                    number: '1',
                    label: 'Pilih',
                    isActive: true,
                    description: 'Jenis Surat',
                  ),
                  StepDivider(isActive: false),
                  StepWidget(
                    number: '2',
                    label: 'Isi',
                    isActive: false,
                    description: 'Formulir',
                  ),
                  StepDivider(isActive: false),
                  StepWidget(
                    number: '3',
                    label: 'Kirim',
                    isActive: false,
                    description: 'Pengajuan',
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // List Langkah
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Langkah-langkah:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    StepDetailWidget(
                      icon: Icons.article_outlined,
                      text: 'Pilih jenis surat yang ingin diurus',
                      number: '1',
                    ),
                    StepDetailWidget(
                      icon: Icons.edit_document,
                      text: 'Isi formulir dengan lengkap',
                      number: '2',
                    ),
                    StepDetailWidget(
                      icon: Icons.task_alt,
                      text: 'Tinjau dan kirim pengajuan',
                      number: '3',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Informasi tambahan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: themeColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: themeColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pastikan data Anda sudah terdaftar di sistem kependudukan desa.',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Mulai
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (pendudukId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PilihJenisSuratPage(
                            pendudukId: pendudukId,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Penduduk ID tidak ditemukan.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mulai Sekarang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk langkah-langkah
class StepWidget extends StatelessWidget {
  final String number;
  final String label;
  final String description;
  final bool isActive;
  static const Color themeColor = Color(0xFF3AC53E);

  const StepWidget({
    Key? key,
    required this.number,
    required this.label,
    required this.isActive,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive ? themeColor : Colors.grey.shade300,
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: themeColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
            ),
            Text(
              number,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? themeColor : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? themeColor : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// Widget untuk garis antara langkah
class StepDivider extends StatelessWidget {
  final bool isActive;
  static const Color themeColor = Color(0xFF3AC53E);

  const StepDivider({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? themeColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// Widget untuk daftar langkah dengan ikon
class StepDetailWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String number;
  static const Color themeColor = Color(0xFF3AC53E);

  const StepDetailWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                color: themeColor,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}