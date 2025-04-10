import 'package:aplikasi_desa/pages/all_berita_page.dart';
import 'package:aplikasi_desa/pages/auth_checker.dart';
import 'package:aplikasi_desa/pages/berita.dart';
import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/berita.dart';
import '../services/api_service.dart';
import 'product_detail_page.dart';
import 'package:html_unescape/html_unescape.dart'; // Tambahkan ini

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Product>> futureProducts;
  late Future<List<Berita>> futureBerita;
  final HtmlUnescape htmlUnescape = HtmlUnescape(); // Tambahkan ini

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.fetchProducts();
    futureBerita = ApiService.fetchBerita();
  }

  // Fungsi untuk menghapus tag HTML
  String _removeHtmlTags(String htmlText) {
    return htmlUnescape.convert(htmlText)
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Desa Digital"),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Berita Desa
              sectionTitle("📰 Berita Desa"),
              FutureBuilder<List<Berita>>(
                future: futureBerita,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada berita ditemukan'));
                  } else {
                    List<Berita> sortedBerita = snapshot.data!
                      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                    List<Berita> limitedBerita = sortedBerita.take(2).toList();

                    return Column(
                      children: [
                        Column(
                          children: limitedBerita
                              .map((berita) => beritaItem(berita))
                              .toList(),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllBeritaPage(allBerita: snapshot.data!),
                              ),
                            );
                          },
                          child: Text(
                            "Lihat Lebih Banyak",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 20),

              // Bagian Informasi Desa
              sectionTitle("ℹ️ Informasi Desa"),
              informasiDesa(),
              SizedBox(height: 20),

              // Bagian Produk Desa
              sectionTitle("🛒 Produk Desa"),
              FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada produk ditemukan'));
                  } else {
                    return produkDesa(snapshot.data!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Berita'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Layanan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BeritaPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthCheckerScreen()),
            );
          }
        },
      ),
    );
  }

  // Widget judul section
  Widget sectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  // Widget untuk menampilkan item berita
  Widget beritaItem(Berita berita) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BeritaDetailPage(berita: berita),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  berita.photoUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      berita.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _removeHtmlTags(berita.description), // Gunakan fungsi untuk menghapus HTML
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget informasi desa
  Widget informasiDesa() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Desa kami memiliki sejarah panjang dan budaya yang kaya. "
        "Informasi lebih lengkap tentang sejarah, potensi, dan kearifan lokal desa kami dapat ditemukan di sini.",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  // Widget produk desa
  Widget produkDesa(List<Product> products) {
    return Column(
      children: products.map((product) => produkItem(product)).toList(),
    );
  }

  // Widget item produk dengan navigasi ke detail produk
  Widget produkItem(Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              imagePath: product.photoUrl,
              title: product.productName,
              price: product.price,
              location: product.location,
              phoneNumber: product.phone,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.photoUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Harga: Rp ${product.price}",
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Lokasi: ${product.location}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}