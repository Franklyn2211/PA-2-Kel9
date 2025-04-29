import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/penduduk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormSuratPage extends StatefulWidget {
  final String jenisSurat;
  final int? pendudukId;
  

  const FormSuratPage({
    Key? key,
    required this.jenisSurat,
    this.pendudukId,
  }) : super(key: key);

  @override
  State<FormSuratPage> createState() => _FormSuratPageState();
}

class _FormSuratPageState extends State<FormSuratPage> {
  final _formKey = GlobalKey<FormState>();
  final _alamatController = TextEditingController();
  final _telpController = TextEditingController();
  final _tujuanController = TextEditingController();
  final _nikController = TextEditingController(); // Tambahkan controller untuk NIK
  final _namaController = TextEditingController(); // Tambahkan controller untuk Nama
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPendudukData();
  }

  Future<void> _fetchPendudukData() async {
    if (widget.pendudukId == null) return;

    try {
      final apiService = ApiService();
      final baseUrl = apiService.getBaseUrl();

      final response = await http.get(
        Uri.parse('$baseUrl/api/pendudukku'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pendudukList = (data['data'] as List)
            .map((item) => Residents.fromJson(item))
            .toList();

        final penduduk = pendudukList.firstWhere(
          (p) => p.id == widget.pendudukId,
          orElse: () => Residents(
            id: 0,
            nik: '',
            name: '',
            gender: '',
            address: '',
            birthDate: '',
            religion: '',
            familyCardNumber: '',
          ),
        );

        setState(() {
          _nikController.text = penduduk.nik; // Set nilai NIK ke controller
          _namaController.text = penduduk.name; // Set nilai Nama ke controller
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      debugPrint('Error saat mengambil data penduduk: $e');
      setState(() {
        _nikController.text = 'Error';
        _namaController.text = 'Error';
      });
    }
  }

  String _getDescriptionText() {
    switch (widget.jenisSurat) {
      case 'Surat Tidak Mampu':
        return 'Silakan isi data diri Anda untuk mengajukan Surat Tidak Mampu. Pastikan data sesuai dengan KTP.';
      case 'Surat Keterangan Domisili':
        return 'Silakan isi data diri Anda untuk mengajukan Surat Keterangan Domisili. Alamat harus sesuai dengan tempat tinggal saat ini.';
      case 'Surat Keterangan Usaha':
        return 'Silakan isi data diri Anda untuk mengajukan Surat Keterangan Usaha. Harap sertakan detail usaha pada kolom tujuan.';
      default:
        return 'Silakan isi data diri Anda untuk mengajukan ${widget.jenisSurat}. Pastikan data yang diisi sudah benar.';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulasi proses pengiriman data
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pengajuan ${widget.jenisSurat} berhasil dikirim!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Kembali ke halaman sebelumnya setelah berhasil
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        title: Text(
          'Form ${widget.jenisSurat}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informasi form
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getDescriptionText(),
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Data Diri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // NIK Field (Non-editable)
                  TextFormField(
                    controller: _nikController, // Gunakan controller
                    decoration: InputDecoration(
                      labelText: 'NIK',
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    readOnly: true,
                  ),

                  const SizedBox(height: 16),

                  // Nama Field (Non-editable)
                  TextFormField(
                    controller: _namaController, // Gunakan controller
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    readOnly: true,
                  ),

                  const SizedBox(height: 16),
                  // No. Telepon Field
                  TextFormField(
                    controller: _telpController,
                    decoration: InputDecoration(
                      labelText: 'No. Telepon',
                      hintText: 'Masukkan nomor telepon aktif',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'No. Telepon tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tujuan Field
                  TextFormField(
                    controller: _tujuanController,
                    decoration: InputDecoration(
                      labelText: 'Tujuan Pengajuan',
                      hintText: 'Jelaskan tujuan pengajuan surat',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tujuan pengajuan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Kirim Pengajuan',
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _alamatController.dispose();
    _telpController.dispose();
    _tujuanController.dispose();
    _nikController.dispose(); // Dispose controller NIK
    _namaController.dispose(); // Dispose controller Nama
    super.dispose();
  }
}