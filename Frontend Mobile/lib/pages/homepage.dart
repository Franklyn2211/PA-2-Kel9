import 'package:aplikasi_desa/pages/all_berita_page.dart';
import 'package:aplikasi_desa/pages/auth_checker.dart';
import 'package:aplikasi_desa/pages/berita.dart';
import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/berita.dart';
import '../services/api_service.dart';
import 'product_detail_page.dart';
<<<<<<< HEAD
=======
import 'package:html_unescape/html_unescape.dart'; // Tambahkan ini
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Product>> futureProducts;
  late Future<List<Berita>> futureBerita;
<<<<<<< HEAD
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
=======
  final HtmlUnescape htmlUnescape = HtmlUnescape(); // Tambahkan ini
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      futureProducts = ApiService.fetchProducts();
      futureBerita = ApiService.fetchBerita();
    });
  }

  Future<void> _refreshData() async {
    await _loadData();
    return Future.delayed(const Duration(milliseconds: 100));
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Desa Digital",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1565C0), // Colors.blue[800] dengan hex
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifikasi
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle pencarian
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1565C0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selamat Datang di",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const Text(
                      "Desa Digital Ambarita",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickAction(Icons.description_outlined, "Layanan", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  AuthCheckerScreen()),
                            );
                          }),
                          _buildQuickAction(Icons.article_outlined, "Berita", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  BeritaPage()),
                            );
                          }),
                          _buildQuickAction(Icons.store_outlined, "Produk", () {
                            // Navigate to produk page
                          }),
                          _buildQuickAction(Icons.info_outline, "Info", () {
                            // Navigate to info page
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian Berita Desa
                    _sectionTitle("📰 Berita Desa", "Lihat Semua", () {
                      futureBerita.then((berita) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllBeritaPage(allBerita: berita),
                          ),
                        );
                      });
                    }),
                    
                    FutureBuilder<List<Berita>>(
                      future: futureBerita,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            height: 150,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return _errorWidget('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _emptyStateWidget('Tidak ada berita ditemukan');
                        } else {
                          List<Berita> sortedBerita = snapshot.data!
                            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                          List<Berita> limitedBerita = sortedBerita.take(3).toList();

                          return Column(
                            children: limitedBerita
                                .map((berita) => _beritaItem(berita))
                                .toList(),
                          );
                        }
                      },
                    ),
                    
                    const SizedBox(height: 24),

                    // Bagian Informasi Desa
                    _sectionTitle("ℹ️ Informasi Desa", "Detail", () {
                      // Navigate to detail informasi desa
                    }),
                    _informasiDesa(),
                    
                    const SizedBox(height: 24),

                    // Bagian Produk Desa
                    _sectionTitle("🛒 Produk Desa", "Lihat Semua", () {
                      // Navigate to all products
                    }),
                    
                    FutureBuilder<List<Product>>(
                      future: futureProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            height: 150,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return _errorWidget('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _emptyStateWidget('Tidak ada produk ditemukan');
                        } else {
                          List<Product> products = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length > 3 ? 3 : products.length,
                            itemBuilder: (context, index) {
                              return _produkItem(products[index]);
                            },
                          );
                        }
                      },
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
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
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  BeritaPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  AuthCheckerScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: const Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget judul section dengan action button
  Widget _sectionTitle(String title, String actionText, VoidCallback onAction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          TextButton(
            onPressed: onAction,
            child: Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan item berita
  Widget _beritaItem(Berita berita) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeritaDetailPage(berita: berita),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  berita.photoUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      berita.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _removeHtmlTags(berita.description), // Gunakan fungsi untuk menghapus HTML
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700], height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(berita.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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
  Widget _informasiDesa() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[700]!, Colors.blue[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white.withOpacity(0.9),
                  size: 20,
                ),
                const SizedBox(width: 6),
                const Text(
                  "Desa Ambarita",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Desa kami memiliki sejarah panjang dan budaya yang kaya. "
              "Informasi lebih lengkap tentang sejarah, potensi, dan kearifan lokal desa kami dapat ditemukan di sini.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                // Navigate to detail informasi
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Lihat Detail"),
            ),
          ],
        ),
      ),
    );
  }

  // Widget item produk dengan navigasi ke detail produk
  Widget _produkItem(Product product) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.photoUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Rp ${_formatPrice(product.price)}",
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.location,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          product.phone,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
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
<<<<<<< HEAD

  Widget _errorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }

  Widget _emptyStateWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox,
            size: 50,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatPrice(String price) {
    if (price.isEmpty) return "0";
    
    try {
      final numPrice = int.parse(price);
      final parts = <String>[];
      String numStr = numPrice.toString();
      
      while (numStr.length > 3) {
        parts.add(numStr.substring(numStr.length - 3));
        numStr = numStr.substring(0, numStr.length - 3);
      }
      
      if (numStr.isNotEmpty) parts.add(numStr);
      
      return parts.reversed.join('.');
    } catch (e) {
      return price;
    }
  }
=======
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520
}