import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import 'product_detail_page.dart';
import 'layanan_surat_page.dart'; // Import halaman Layanan Surat

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.fetchProducts();
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
              beritaDesa(),
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
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navigasi ke halaman yang sesuai
          if (index == 2) { // Jika item "Layanan" diklik
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LayananSuratPage()),
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
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[800]),
      ),
    );
  }

  // Contoh widget untuk berita desa
  Widget beritaDesa() {
    return Column(
      children: [
        beritaItem("assets/festival.jpg", "Festival Desa",
            "Acara festival desa yang meriah."),
        beritaItem("assets/jalan.jpg", "Pembangunan Jalan",
            "Pembangunan jalan utama desa telah selesai."),
      ],
    );
  }

  Widget beritaItem(String imagePath, String title, String description) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar berita
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            // Keterangan berita
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
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
        // Navigasi ke halaman detail produk
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              imagePath: product.photoUrl, // Gunakan photoUrl
              title: product.productName, // Gunakan productName
              price: product.price, // Gunakan price
              location: product.location, // Gunakan location
              phoneNumber: product.phone, // Gunakan phone
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
              // Gambar produk
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.photoUrl, // Gunakan photoUrl
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              // Keterangan produk dan lokasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.productName, // Gunakan productName
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text("Harga: Rp ${product.price}", // Gunakan price
                        style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Lokasi: ${product.location}", // Gunakan location
                        style: TextStyle(color: Colors.grey[600])),
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