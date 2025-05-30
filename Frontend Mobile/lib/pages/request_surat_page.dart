import 'package:aplikasi_desa/pages/homepage.dart'; // Import HomePage
import 'package:aplikasi_desa/pages/layanan_surat_page.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_desa/services/api_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class RequestSuratPage extends StatefulWidget {
  final int userId;

  const RequestSuratPage({Key? key, required this.userId}) : super(key: key);

  @override
  _RequestSuratPageState createState() => _RequestSuratPageState();
}

class _RequestSuratPageState extends State<RequestSuratPage> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;
  final Color themeColor = const Color(0xFF3AC53E);

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final response = await ApiService.post('/user/requests', {
        'user_id': widget.userId,
      });
      setState(() {
        requests = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching requests: $e');
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'processed':
        return 'Diproses';
      case 'completed':
        return 'Selesai';
      case 'rejected':
        return 'Ditolak';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processed':
        return Colors.blue;
      case 'completed':
        return themeColor;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _downloadPDF(int requestId) async {
    final url = '${ApiService.baseUrl}/pengajuan/$requestId/download';
    print('Download URL: $url'); // Debug print

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/surat_$requestId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('File disimpan di: $filePath'); // Debug print
        OpenFile.open(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh file: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error saat mengunduh file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat mengunduh file'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Request Surat'),
        backgroundColor: themeColor,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()), // Navigasi ke HomePage
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _fetchRequests();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            )
          : requests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_rounded,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada request surat',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LayananSuratPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Buat Request Baru',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchRequests,
                  color: themeColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      final status = request['status'] as String;
                      final jenisSurat = request['template'] != null
                          ? request['template']['jenis_surat']
                          : request['jenis_surat']; // Gunakan 'jenis_surat' jika 'template' null

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          title: Text(
                            jenisSurat, // Gunakan 'jenisSurat' yang sudah divalidasi
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getStatusColor(status),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(status),
                                  style: TextStyle(
                                    color: _getStatusColor(status),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.description,
                              color: themeColor,
                              size: 28,
                            ),
                          ),
                          trailing: status.toLowerCase() == 'disetujui'
                              ? IconButton(
                                  icon: Icon(
                                    Icons.download,
                                    color: themeColor,
                                    size: 24,
                                  ),
                                  onPressed: () => _downloadPDF(request['id']),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LayananSuratPage()),
          ).then((_) => _fetchRequests()); // Refresh after returning
        },
        backgroundColor: themeColor,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Request Baru',
      ),
    );
  }
}