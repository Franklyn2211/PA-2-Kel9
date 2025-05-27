import 'package:aplikasi_desa/pages/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; // Untuk format harga
import 'package:cached_network_image/cached_network_image.dart'; // Tambahkan package ini

class HalamanDetailProduk extends StatelessWidget {
  final int productId;
  final String imagePath;
  final String title;
  final String price;
  final String location;
  final String phoneNumber;
  final String? description;
  final String qrisImage; // URL gambar QRIS dari API
  final int stock; // Tambahkan properti stok

  const HalamanDetailProduk({
    Key? key,
    required this.productId,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.location,
    required this.phoneNumber,
    this.description,
    required this.qrisImage,
    required this.stock, // Tambahkan parameter stok
  }) : super(key: key);

  // Fungsi untuk membuka WhatsApp (tidak diubah)
  Future<void> bukaWhatsApp(String nomorTelepon) async {
    try {
      // Format nomor telepon (hapus karakter non-angka)
      String formattedPhoneNumber =
          nomorTelepon.replaceAll(RegExp(r'[^0-9]'), '');

      // Buat pesan WhatsApp
      final pesan = "Halo, saya ingin membeli produk $title apakah masih ada?";
      final urlWhatsApp =
          "https://wa.me/$formattedPhoneNumber?text=${Uri.encodeComponent(pesan)}";

      // Validasi URL sebelum membuka
      final Uri uri = Uri.parse(urlWhatsApp);
      if (!await canLaunchUrl(uri)) {
        throw 'Tidak dapat membuka WhatsApp. URL tidak valid.';
      }

      // Buka URL
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Fungsi untuk format harga (tidak diubah)
  String formatHarga(String harga) {
    try {
      double jumlah = double.parse(harga);
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return formatter.format(jumlah);
    } catch (e) {
      return harga; // Jika parsing gagal, kembalikan harga asli
    }
  }

  // Fungsi untuk menampilkan dialog pembayaran QRIS (diperbarui)
  void _tampilkanDialogPembayaran(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Pembayaran QRIS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Scan QR Code berikut untuk melakukan pembayaran",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                // Perbaikan tampilan QRIS image
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: qrisImage.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: qrisImage,
                          height: 250,
                          width: 250,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 250,
                            width: 250,
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code,
                                    size: 50, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  "Kode QR tidak tersedia",
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: 250,
                          width: 250,
                          color: Colors.grey[200],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code,
                                    size: 50, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  "Kode QR tidak tersedia",
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 20),
                Text(
                  formatHarga(price),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Tutup"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Tutup dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthCheckerScreen(
                              productId: productId, // Kirim productId
                            ),
                          ),
                        );
                      },
                      child: Text("Konfirmasi Pembayaran"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sisa kode tidak berubah
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   iconTheme: IconThemeData(color: Colors.white),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.favorite_border),
      //       onPressed: () {
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(content: Text("Ditambahkan ke favorit")),
      //         );
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.share),
      //       onPressed: () {
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(content: Text("Bagikan produk")),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar produk dengan efek overlay
                  Stack(
                    children: [
                      SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: Hero(
                          tag: 'produk-$title',
                          child: Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey, size: 50),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Detail produk dalam card
                  Transform.translate(
                    offset: Offset(0, -20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul dan harga
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              formatHarga(price),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.green[700],
                              ),
                            ),

                            SizedBox(height: 20),

                            // Lokasi dengan icon
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.grey[600], size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Tambahkan tampilan stok
                            Row(
                              children: [
                                Icon(Icons.inventory, color: Colors.grey[600], size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Stok: $stock",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),

                            Divider(height: 30),

                            // Deskripsi produk (jika ada)
                            if (description != null) ...[
                              Text(
                                "Deskripsi Produk",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                description!.replaceAll(RegExp(r'<\/?p>'), ''), // Hilangkan tag <p>
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],

                            // Informasi penjual
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFF3AC53E),
                                    child:
                                        Icon(Icons.person, color: Colors.white),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Penjual",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Hubungi melalui WhatsApp",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.phone_in_talk),
                                    color: Color(0xFF3AC53E),
                                    onPressed: () {
                                      try {
                                        launchUrl(
                                            Uri.parse('tel:$phoneNumber'));
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Gagal melakukan panggilan: $e")),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol aksi di bagian bawah
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Tombol Bayar Sekarang
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => _tampilkanDialogPembayaran(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Bayar Sekarang",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  // Tombol WhatsApp
                  SizedBox(
                    width: 55,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await bukaWhatsApp(phoneNumber);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Gagal membuka WhatsApp: $e")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF25D366), // Warna WhatsApp
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
