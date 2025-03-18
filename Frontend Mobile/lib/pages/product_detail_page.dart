import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome

class ProductDetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String location;
  final String phoneNumber;

  const ProductDetailPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.location,
    required this.phoneNumber,
  }) : super(key: key);

  // Fungsi untuk membuka WhatsApp
  Future<void> launchWhatsApp(String phoneNumber) async {
    try {
      // Format nomor telepon (hilangkan karakter selain angka)
      String formattedPhoneNumber =
          phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

      // Buat URL WhatsApp
      String url =
          "https://wa.me/$formattedPhoneNumber?text=Halo, saya ingin membeli produk $title apakah masih ada?";

      // Validasi URL sebelum membuka
      final Uri? uri = Uri.tryParse(url);
      if (uri == null || !await canLaunch(uri.toString())) {
        throw 'Tidak dapat membuka WhatsApp. URL tidak valid.';
      }

      // Buka URL
      await launch(uri.toString());
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Fungsi untuk memformat harga (contoh: "100000.00" -> "Rp 100.000")
  String formatPrice(String price) {
    try {
      double amount = double.parse(price);
      return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d)'), (Match m) => '${m[1]}.')}';
    } catch (e) {
      return price; // Jika parsing gagal, kembalikan harga asli
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tampilan foto produk
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 400,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Tampilan detail produk
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                formatPrice(price), // Format harga
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Lokasi: $location",
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
              const SizedBox(height: 24),
              // Tombol Checkout dengan ikon WhatsApp
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await launchWhatsApp(phoneNumber);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal membuka WhatsApp: $e")),
                      );
                    }
                  },
                  icon:
                      const FaIcon(FontAwesomeIcons.whatsapp), // Ikon WhatsApp
                  label: const Text("Checkout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
