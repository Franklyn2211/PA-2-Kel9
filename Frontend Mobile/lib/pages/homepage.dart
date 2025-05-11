import 'package:aplikasi_desa/models/gallery_model.dart';
import 'package:aplikasi_desa/pages/all_berita_page.dart';
import 'package:aplikasi_desa/pages/all_pengumuman_page.dart'; // Import halaman semua pengumuman
import 'package:aplikasi_desa/pages/all_product_page.dart';
import 'package:aplikasi_desa/pages/berita.dart';
import 'package:aplikasi_desa/pages/berita_detail_page.dart';
import 'package:aplikasi_desa/pages/gallery_page.dart';
import 'package:aplikasi_desa/pages/peringatan_login.dart';
import 'package:aplikasi_desa/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/berita.dart';
import '../models/umkm.dart';
import '../models/pengumuman.dart'; // Import model Pengumuman
import '../services/api_service.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart'; // Tambahkan ini untuk memproses HTML
import '../pages/profile_page.dart'; // Import halaman profil
import '../pages/profil_desa_page.dart'; // Import halaman ProfilDesaPage
import 'staff_page.dart'; // Import halaman StaffPage

// Import pages for navigation

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
  late Future<List<Pengumuman>>
      futurePengumuman; // Tambahkan ini untuk pengumuman
  int?
      _selectedPengumumanId; // Tambahkan ini untuk menyimpan ID pengumuman yang dipilih

  final Color themeColor = const Color(0xFF3AC53E);
  final Color themeLightColor = const Color(0xFF4CDF50);
  final Color themeAccentColor = const Color(0xFF2EA232);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final HtmlUnescape htmlUnescape = HtmlUnescape();

  // List of pages to navigate to
  final List<Widget> _pages = [];
  bool isPagesInitialized = false; // Tambahkan flag untuk inisialisasi _pages
  String? history; // Tambahkan variabel untuk menyimpan data history

  @override
  void initState() {
    super.initState();
    _loadData();
    _fetchProfilDesa(); // Panggil fungsi untuk memuat data profil desa

    // Initialize pages list
    _initializePages(); // Panggil metode untuk inisialisasi _pages
  }

  Future<void> _initializePages() async {
    final products = await ApiService.fetchProducts(); // Ambil produk dari API
    setState(() {
      _pages.add(buildHomeContent()); // Halaman Home (indeks 0)
      _pages.add(BeritaPage()); // Halaman Berita (indeks 1)
      _pages.add(PeringatanLogin()); // Halaman Layanan (indeks 2)
      _pages.add(AllProductPage(allProducts: products)); // Halaman Produk (indeks 3)
      _pages.add(ProfilePage()); // Halaman Akun (indeks 4)
      isPagesInitialized = true; // Tandai bahwa _pages telah diinisialisasi
    });
  }

  Future<void> _fetchProfilDesa() async {
    try {
      final data = await ApiService.fetchProfilDesa();
      setState(() {
        history = _removeHtmlTags(data['history']); // Hapus tag HTML dari history
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data sejarah desa: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _removeHtmlTags(String htmlText) {
    final document = parse(htmlText);
    return document.body?.text ?? '';
  }

  // Method to build the home content
  Widget buildHomeContent() {
    return RefreshIndicator(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Tambahkan scroll horizontal
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80, // Batasi lebar setiap tombol
                            child: _buildQuickAction(Icons.description_outlined, "Layanan", () {
                              _navigateToPage(2); // Navigate to Layanan page
                            }, themeColor),
                          ),
                          SizedBox(
                            width: 80,
                            child: _buildQuickAction(Icons.article_outlined, "Berita", () {
                              _navigateToPage(1); // Navigate to Berita page
                            }, themeColor),
                          ),
                          SizedBox(
                            width: 80,
                            child: _buildQuickAction(Icons.store_outlined, "Produk", () {
                              _navigateToPage(3); // Navigate to Produk page
                            }, themeColor),
                          ),
                          SizedBox(
                            width: 80,
                            child: _buildQuickAction(Icons.info_outline, "Info", () {
                              // Show info dialog or navigate to info page
                              _showInfoDialog();
                            }, themeColor),
                          ),
                          SizedBox(
                            width: 80,
                            child: _buildQuickAction(Icons.people_outline, "Struktur", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StaffPage(), // Navigasi ke halaman StaffPage
                                ),
                              );
                            }, themeColor),
                          ),
                          SizedBox(
                            width: 80,
                            child: _buildQuickAction(Icons.photo_library_outlined, "Galeri Desa", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GalleryPage(), // Navigasi ke GalleryPage
                                ),
                              );
                            }, themeColor),
                          ),
                        ],
                      ),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _emptyStateWidget('Tidak ada berita ditemukan');
                      } else {
                        List<Berita> sortedBerita = snapshot.data!
                          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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

                  // Pengumuman section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("📢 Pengumuman", "Lihat Semua", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllPengumumanPage(),
                            ),
                          );
                        }),
                        FutureBuilder<List<Pengumuman>>(
                          future: futurePengumuman,
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
                                  'Tidak ada pengumuman ditemukan');
                            } else {
                              List<Pengumuman> pengumumanList = snapshot.data!;
                              return Column(
                                children: pengumumanList
                                    .take(3) // Batasi hanya 3 pengumuman
                                    .map((pengumuman) =>
                                        _pengumumanItem(pengumuman))
                                    .toList(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informasi Desa section
                  _sectionTitle("ℹ️ Informasi Desa", "Detail", () {
                    // Navigate to detail informasi desa
                    _showVillageInfoDetail();
                  }),
                  _informasiDesa(),

                  const SizedBox(height: 24),

                  // Produk Desa section
                  _sectionTitle("🛒 Produk Desa", "Lihat Semua", () {
                    futureProducts.then((products) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProductPage(
                              allProducts:
                                  products), // Navigasi ke AllProductPage
                        ),
                      );
                    });
                  }),

                  FutureBuilder<List<Product>>(
                    future: futureProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _emptyStateWidget('Tidak ada produk ditemukan');
                      } else {
                        List<Product> sortedProducts = snapshot.data!
                          ..sort((a, b) {
                            // Tangani null pada createdAt
                            if (a.createdAt == null && b.createdAt == null)
                              return 0;
                            if (a.createdAt == null) return 1;
                            if (b.createdAt == null) return -1;
                            return b.createdAt!.compareTo(a.createdAt!);
                          });
                        List<Product> limitedProducts =
                            sortedProducts.take(3).toList();

                        return Column(
                          children: limitedProducts.map((product) {
                            final umkm = product.umkm; // Ambil data UMKM dari produk
                            return _produkItem(
                              product,
                              umkm ??
                                  Umkm(
                                    id: 0,
                                    namaUmkm: 'UMKM Tidak Diketahui', // Default jika UMKM null
                                    email: '',
                                    phone: '',
                                    qrisImage: '',
                                    status: false,
                                    qrisUrl: '',
                                  ),
                            );
                          }).toList(),
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
    );
  }

  Future<void> _loadData() async {
    setState(() {
      futureProducts = ApiService.fetchProducts();
      futureBerita = ApiService.fetchBerita();
      futureUmkm = ApiService.fetchUmkm();
      futurePengumuman = ApiService.fetchPengumuman(); // Tambahkan ini
    });
  }

  Future<void> _refreshData() async {
    await _loadData();
    return Future.delayed(const Duration(milliseconds: 100));
  }

  // Method to navigate to a specific page
  void _navigateToPage(int index) {
    if (!isPagesInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Halaman sedang dimuat, harap tunggu...'),
          backgroundColor: themeColor,
        ),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }
  
  // Show info dialog
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Informasi Aplikasi',
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aplikasi Desa Digital Ambarita',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Versi 1.0.0',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  'Aplikasi ini bertujuan untuk memudahkan warga desa dalam mengakses informasi, layanan, dan produk lokal desa.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: themeColor,
              ),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // Show village info detail
  void _showVillageInfoDetail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Detail Informasi Desa',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: themeColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://example.com/desa_ambarita.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Desa Ambarita',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kecamatan Simanindo, Kabupaten Samosir, Sumatera Utara',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sejarah Desa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Desa Ambarita merupakan salah satu desa yang terletak di kecamatan Simanindo, Kabupaten Samosir, Provinsi Sumatera Utara. Desa ini memiliki sejarah panjang dan kaya akan budaya Batak Toba. Salah satu daya tarik utama di desa ini adalah keberadaan situs bersejarah Batu Kursi Parsidangan yang merupakan peninggalan Raja Siallagan.',
                  style: TextStyle(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Potensi Desa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. Pariwisata: Situs bersejarah dan pemandangan alam\n'
                  '2. Pertanian: Padi, jagung, dan sayuran\n'
                  '3. Kerajinan: Ukiran kayu dan tenun ulos\n'
                  '4. Perikanan: Budidaya ikan di Danau Toba',
                  style: TextStyle(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kearifan Lokal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Desa Ambarita masih mempertahankan adat istiadat Batak Toba seperti upacara adat, musik gondang, dan tari tor-tor. Masyarakat desa juga masih memegang teguh filosofi Dalihan Na Tolu yang mengatur hubungan kekerabatan dan sosial dalam masyarakat Batak.',
                  style: TextStyle(fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
      );
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
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Show notifications
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tidak ada notifikasi baru'),
                  backgroundColor: themeColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: isPagesInitialized
          ? (_selectedIndex < _pages.length
              ? _pages[_selectedIndex] // Tampilkan halaman sesuai indeks
              : buildHomeContent()) // Default ke halaman utama jika indeks tidak valid
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon:
                  Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 1 ? Icons.article : Icons.article_outlined),
              label: 'Berita',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(_selectedIndex == 2 ? Icons.work : Icons.work_outlined),
              label: 'Layanan',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined),
              label: 'Produk',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 4 ? Icons.person : Icons.person_outlined),
              label: 'Akun',
              backgroundColor: Colors.white,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: themeColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: _navigateToPage,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
        ),
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
      )
      );
  }

  Widget _pengumumanItem(Pengumuman pengumuman) {
    final isSelected = _selectedPengumumanId ==
        pengumuman.id; // Cek apakah pengumuman ini dipilih
    final fullDescription = _removeHtmlTags(pengumuman.description);
    final description = isSelected
        ? fullDescription
        : (fullDescription.length > 20
            ? fullDescription.substring(0, 20) + '...'
            : fullDescription); // Potong deskripsi jika tidak dipilih

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPengumumanId =
              isSelected ? null : pengumuman.id; // Toggle detail pengumuman
        });
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pengumuman.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                maxLines: isSelected ? null : 3,
                overflow:
                    isSelected ? TextOverflow.visible : TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700], height: 1.3),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: themeColor),
                  const SizedBox(width: 4),
                  Text(
                    pengumuman.createdAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
              ],
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
            Text(
              history ?? "Memuat sejarah desa...", // Tampilkan data history
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilDesaPage(), // Navigasi ke ProfilDesaPage
                  ),
                );
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
    final qrisUrl = product.qrisUrl ?? umkm.qrisUrl ?? '';
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
                productId: product.id,
                imagePath: product.photoUrl,
                title: product.productName,
                price: product.price,
                location: product.location,
                phoneNumber: product.phone,
                description: product.description,
                qrisImage: qrisUrl,
                stock: product.stock, // Tambahkan parameter stok
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
                  product.photoUrl,
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
