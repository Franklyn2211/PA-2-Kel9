import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; // For better price formatting

class ProductDetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String location;
  final String phoneNumber;
  final String? description; // Added description field

  const ProductDetailPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.location,
    required this.phoneNumber,
    this.description,
  }) : super(key: key);

  // Function to open WhatsApp
  Future<void> launchWhatsApp(String phoneNumber) async {
    try {
      // Format phone number (remove non-numeric characters)
      String formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

      // Create WhatsApp URL
      final message = "Halo, saya ingin membeli produk $title apakah masih ada?";
      final whatsappUrl = "https://wa.me/$formattedPhoneNumber?text=${Uri.encodeComponent(message)}";

      // Validate URL before opening
      final Uri uri = Uri.parse(whatsappUrl);
      if (!await canLaunchUrl(uri)) {
        throw 'Tidak dapat membuka WhatsApp. URL tidak valid.';
      }

      // Open URL
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Function to format price (e.g., "100000.00" -> "Rp 100.000")
  String formatPrice(String price) {
    try {
      double amount = double.parse(price);
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    } catch (e) {
      return price; // If parsing fails, return original price
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ditambahkan ke favorit")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Bagikan produk")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero product image with gradient overlay
                  Stack(
                    children: [
                      SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: Hero(
                          tag: 'product-$title',
                          child: Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
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
                  
                  // Product details card
                  Transform.translate(
                    offset: const Offset(0, -20),
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
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and price
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              formatPrice(price),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.green[700],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Location with icon
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                                const SizedBox(width: 8),
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
                            
                            const Divider(height: 30),
                            
                            // Description section (if available)
                            if (description != null) ...[
                              const Text(
                                "Deskripsi Produk",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                description!,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                            
                            // Seller information
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue[800],
                                    child: const Icon(Icons.person, color: Colors.white),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Penjual",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
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
                                    icon: const Icon(Icons.phone_in_talk),
                                    color: Colors.blue[800],
                                    onPressed: () {
                                      try {
                                        launchUrl(Uri.parse('tel:$phoneNumber'));
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Gagal melakukan panggilan: $e")),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Fixed checkout button at bottom
          Container(
            padding: const EdgeInsets.all(16),
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
              child: SizedBox(
                width: double.infinity,
                height: 55,
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
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                  label: const Text("Hubungi Penjual"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // WhatsApp green
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}