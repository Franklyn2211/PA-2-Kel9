import 'package:flutter/material.dart';
import 'package:aplikasi_desa/pages/product_detail_page.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class AllProductPage extends StatefulWidget {
  final List<Product> allProducts;

  const AllProductPage({Key? key, required this.allProducts}) : super(key: key);

  @override
  _AllProductPageState createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  late List<Product> products;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    products = widget.allProducts;
  }

  Future<void> _refreshProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final refreshedProducts = await ApiService.fetchProducts();
      setState(() {
        products = refreshedProducts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat ulang produk: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Produk'),
        backgroundColor: const Color(0xFF3AC53E),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        color: const Color(0xFF3AC53E),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF3AC53E)),
                ),
              )
            : products.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada produk tersedia',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
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
                            product.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Rp ${product.price}",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.photoUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
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
                                  qrisImage: product.qrisUrl ?? '',
                                  stock: product.stock,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
