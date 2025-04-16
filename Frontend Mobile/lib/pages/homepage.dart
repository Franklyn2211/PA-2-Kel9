import 'package:aplikasi_desa/pages/all_berita_page.dart';
import 'package:aplikasi_desa/pages/auth_checker.dart';
import 'package:aplikasi_desa/pages/berita.dart';
import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import 'package:aplikasi_desa/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/berita.dart';
import '../models/umkm.dart';
import '../services/api_service.dart';
import 'package:html_unescape/html_unescape.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Product>> futureProducts;
  late Future<List<Berita>> futureBerita;
  late Future<List<Umkm>> futureUmkm;

  final Color themeColor = const Color(0xFF3AC53E);
  final Color themeLightColor = const Color(0xFF4CDF50);
  final Color themeAccentColor = const Color(0xFF2EA232);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final HtmlUnescape htmlUnescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      futureProducts = ApiService.fetchProducts();
      futureBerita = ApiService.fetchBerita();
      futureUmkm = ApiService.fetchUmkm(); // Added UMKM fetch
    });
  }

  Future<void> _refreshData() async {
    await _loadData();
    return Future.delayed(const Duration(milliseconds: 100));
  }

  String _removeHtmlTags(String htmlText) {
    return htmlUnescape
        .convert(htmlText)
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: themeColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: themeColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [themeColor, themeAccentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
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
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickAction(
                              Icons.description_outlined, "Layanan", () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthCheckerScreen()));
                          }, themeColor),
                          _buildQuickAction(Icons.article_outlined, "Berita",
                              () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BeritaPage()));
                          }, themeColor),
                          _buildQuickAction(Icons.store_outlined, "Produk", () {
                            // Navigate to produk page
                          }, themeColor),
                          _buildQuickAction(Icons.info_outline, "Info", () {
                            // Navigate to info page
                          }, themeColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Berita Desa section
                    _sectionTitle("📰 Berita Desa", "Lihat Semua", () {
                      futureBerita.then((berita) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AllBeritaPage(allBerita: berita),
                          ),
                        );
                      });
                    }),

                    FutureBuilder<List<Berita>>(
                      future: futureBerita,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 150,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: themeColor,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return _errorWidget('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return _emptyStateWidget(
                              'Tidak ada berita ditemukan');
                        } else {
                          List<Berita> sortedBerita = snapshot.data!
                            ..sort(
                                (a, b) => b.createdAt.compareTo(a.createdAt));
                          List<Berita> limitedBerita =
                              sortedBerita.take(3).toList();

                          return Column(
                            children: limitedBerita
                                .map((berita) => _beritaItem(berita))
                                .toList(),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // Informasi Desa section
                    _sectionTitle("ℹ️ Informasi Desa", "Detail", () {
                      // Navigate to detail informasi desa
                    }),
                    _informasiDesa(),

                    const SizedBox(height: 24),

                    // Produk Desa section
                    _sectionTitle("🛒 Produk Desa", "Lihat Semua", () {
                      // Navigate to all products
                    }),

                    FutureBuilder<List<Product>>(
                      future: futureProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 150,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: themeColor,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return _errorWidget('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return _emptyStateWidget(
                              'Tidak ada produk ditemukan');
                        } else {
                          List<Product> products = snapshot.data!;
                          return FutureBuilder<List<Umkm>>(
                            future: futureUmkm,
                            builder: (context, umkmSnapshot) {
                              if (umkmSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                    color: themeColor);
                              } else if (umkmSnapshot.hasError) {
                                return _errorWidget(
                                    'Error: ${umkmSnapshot.error}');
                              } else if (!umkmSnapshot.hasData) {
                                return _emptyStateWidget(
                                    'Data UMKM tidak tersedia');
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      products.length > 3 ? 3 : products.length,
                                  itemBuilder: (context, index) {
                                    // Find corresponding UMKM for the product
                                    final umkm = umkmSnapshot.data!.firstWhere(
                                      (u) => u.id == products[index].id,
                                      orElse: () => Umkm(
                                        id: 1,
                                        namaUmkm: 'Contoh',
                                        email: 'contoh@email.com',
                                        phone: '08123456789',
                                        qrisImage: 'link_qris.png',
                                        status: true,
                                        photoUrl:
                                            'https://example.com/default-photo.jpg', // ✅ Tambahkan ini
                                      ),
                                    );
                                    return _produkItem(products[index], umkm);
                                  },
                                );
                              }
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
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 15,
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

  Widget _buildQuickAction(
      IconData icon, String label, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 30,
              color: color,
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

  Widget _sectionTitle(String title, String actionText, VoidCallback onAction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: themeColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: themeColor.withOpacity(0.1),
            ),
            child: Text(
              actionText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _beritaItem(Berita berita) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeritaDetailPage(berita: berita),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
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
                      _removeHtmlTags(berita.description),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700], height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: themeColor),
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

  Widget _informasiDesa() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [themeColor, themeAccentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Desa Ambarita",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              "Desa kami memiliki sejarah panjang dan budaya yang kaya. "
              "Informasi lebih lengkap tentang sejarah, potensi, dan kearifan lokal desa kami dapat ditemukan di sini.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () {
                // Navigate to detail informasi
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                "Lihat Detail",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _produkItem(Product product, Umkm umkm) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanDetailProduk(
                qrisImage: umkm.photoUrl ??'',
                imagePath: product.photoUrl,
                title: product.productName,
                price: product.price,
                location: product.location,
                phoneNumber: product.phone,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.photoUrl ?? 'default_image.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Rp ${_formatPrice(product.price.toString())}",
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: themeColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.location ?? 'Lokasi tidak tersedia',
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
                        Icon(Icons.store, size: 14, color: themeColor),
                        const SizedBox(width: 4),
                        Text(
                          umkm.namaUmkm,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: themeColor),
                        const SizedBox(width: 4),
                        Text(
                          product.phone ?? umkm.phone,
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
            icon: Icon(Icons.refresh, color: themeColor),
            label: Text(
              "Coba Lagi",
              style: TextStyle(color: themeColor),
            ),
            style: TextButton.styleFrom(
              backgroundColor: themeColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
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
}
