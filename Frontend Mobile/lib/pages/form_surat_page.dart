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
  // Define our theme color
  final Color themeColor = const Color(0xFF3AC53E);
  
  final _formKey = GlobalKey<FormState>();
  final _telpController = TextEditingController();
  final _tujuanController = TextEditingController();
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
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
          _nikController.text = penduduk.nik;
          _namaController.text = penduduk.name;
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final apiService = ApiService();
        final baseUrl = apiService.getBaseUrl();

        // Tentukan endpoint berdasarkan jenis surat
        final endpoint = {
          'Surat Keterangan Belum Pernah Menikah': 'api/pengajuan/belum-menikah',
          'Surat Keterangan Domisili': 'api/pengajuan/surat-domisili',
          'Surat Keterangan Usaha': 'api/pengajuan/surat-usaha',
          // Tambahkan jenis surat lainnya di sini
        }[widget.jenisSurat] ?? 'api/surat-umum';

        // Data yang akan dikirim ke backend
        final requestData = {
          'resident_id': widget.pendudukId.toString(),
          'jenis_surat': widget.jenisSurat,
          'keperluan': _tujuanController.text,
          'nomor_telepon': _telpController.text,
        };

        debugPrint('Request Data: $requestData');
        debugPrint('Endpoint: $baseUrl/$endpoint');

        final response = await http.post(
          Uri.parse('$baseUrl/$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(requestData),
        );

        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pengajuan ${widget.jenisSurat} berhasil dikirim!'),
              backgroundColor: themeColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else {
          final errorMessage = responseData['message'] ?? 'Gagal mengajukan surat';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $errorMessage'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: themeColor,
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
        child: Column(
          children: [
            // Header section with curved bottom
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: themeColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getDescriptionText(),
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Main form content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section title with decoration
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            border: Border(
                              left: BorderSide(color: themeColor, width: 4),
                            ),
                          ),
                          child: const Text(
                            'Data Diri',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // NIK Field (Non-editable)
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: _nikController,
                              decoration: InputDecoration(
                                labelText: 'NIK',
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                prefixIcon: Icon(Icons.badge, color: themeColor),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ),
    
                        const SizedBox(height: 16),
    
                        // Nama Field (Non-editable)
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: _namaController,
                              decoration: InputDecoration(
                                labelText: 'Nama Lengkap',
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                prefixIcon: Icon(Icons.person, color: themeColor),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ),
    
                        const SizedBox(height: 16),
                        
                        // No. Telepon Field
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: _telpController,
                              decoration: InputDecoration(
                                labelText: 'No. Telepon',
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                hintText: 'Masukkan nomor telepon aktif',
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                prefixIcon: Icon(Icons.phone, color: themeColor),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'No. Telepon tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Tujuan Field
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: _tujuanController,
                              decoration: InputDecoration(
                                labelText: 'Tujuan Pengajuan',
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                hintText: 'Jelaskan tujuan pengajuan surat',
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                prefixIcon: Icon(Icons.description, color: themeColor),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                alignLabelWithHint: true,
                              ),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Tujuan pengajuan tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Submit Button with gradient
                        Container(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.send_rounded),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Kirim Pengajuan',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _telpController.dispose();
    _tujuanController.dispose();
    _nikController.dispose();
    _namaController.dispose();
    super.dispose();
  }
}