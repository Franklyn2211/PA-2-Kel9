import 'package:aplikasi_desa/auth/auth_provider.dart';
import 'package:aplikasi_desa/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:aplikasi_desa/services/api_service.dart';

class PaymentProofScreen extends StatefulWidget {
  final int productId;
  final int? pendudukId;

  const PaymentProofScreen({
    Key? key,
    required this.productId,
    this.pendudukId,
  }) : super(key: key);

  @override
  _PaymentProofScreenState createState() => _PaymentProofScreenState();
}

class _PaymentProofScreenState extends State<PaymentProofScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint('PaymentProofScreen initialized with:');
    debugPrint('productId: ${widget.productId}');
    debugPrint('pendudukId: ${widget.pendudukId}');
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitPaymentProof() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      debugPrint('Form validation failed or form state is null.');
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon unggah bukti pembayaran')),
      );
      debugPrint('Image file is null.');
      return;
    }

    debugPrint('Submitting payment proof');
    debugPrint('Product ID: ${widget.productId}');
    debugPrint('Penduduk ID from widget: ${widget.pendudukId}');

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    debugPrint('AuthProvider pendudukId before load: ${authProvider.pendudukId}');

    if (authProvider.pendudukId == null) {
      final loaded = await authProvider.loadUser();
      debugPrint('User loaded status: $loaded');
      debugPrint('AuthProvider pendudukId after load: ${authProvider.pendudukId}');
    }

    final int? actualPendudukId = widget.pendudukId ?? authProvider.pendudukId;

    debugPrint('Actual Penduduk ID: $actualPendudukId');

    if (actualPendudukId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Data pengguna tidak ditemukan, silakan login kembali')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            productId: widget.productId,
            redirectTo: 'pembayaran',
          ),
        ),
      );
      debugPrint('Penduduk ID is null, redirecting to login.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.createOrder(
        pendudukId: actualPendudukId,
        productId: widget.productId,
        amount: _amountController.text,
        note: _noteController.text,
        buktiTransfer: _imageFile!,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bukti pembayaran berhasil diunggah')),
          );

          _formKey.currentState?.reset();
          _amountController.clear();
          _noteController.clear();
          setState(() {
            _imageFile = null;
          });

          debugPrint('Payment proof submitted successfully, returning to previous page.');
          Navigator.pop(context); // Simply pop to return to the previous page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    response['message'] ?? 'Terjadi kesalahan saat mengunggah')),
          );
          debugPrint('API response failed: ${response['message']}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        debugPrint('Error during API call: $e');
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unggah Bukti Pembayaran'),
        backgroundColor: Color(0xFF3AC53E),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Card(
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.white, size: 30),
                            SizedBox(height: 8),
                            Text(
                              'Silakan unggah bukti pembayaran Anda berupa struk/screenshot transaksi',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Pembayaran (Rp)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan jumlah pembayaran';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Catatan (Opsional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _showImageSourceSelection,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _imageFile != null
                            ? Stack(
                                children: [
                                  Image.file(
                                    _imageFile!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 18,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.white, size: 18),
                                        onPressed: () {
                                          setState(() {
                                            _imageFile = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.cloud_upload,
                                      size: 50, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap untuk mengunggah bukti pembayaran',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '(Foto/Gambar dari galeri)',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitPaymentProof,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'KIRIM BUKTI PEMBAYARAN',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}