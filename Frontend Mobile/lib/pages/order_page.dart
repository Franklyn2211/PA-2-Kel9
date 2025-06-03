import 'package:flutter/material.dart';
import 'package:aplikasi_desa/services/api_service.dart';

class OrderPage extends StatefulWidget {
  final int userId; // Pastikan parameter adalah userId

  const OrderPage({Key? key, required this.userId}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  final Color themeColor = const Color(0xFF3AC53E);

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
        final response = await ApiService.get('/orders?user_id=${widget.userId}');
        setState(() {
            orders = List<Map<String, dynamic>>.from(response['data']);
            isLoading = false;
        });
    } catch (e) {
        setState(() {
            isLoading = false;
        });
        print('Error fetching orders: $e');
    }
  }

  String _getStatusText(bool? status) {
    if (status == null) {
        return 'Menunggu Konfirmasi'; // Status default jika null
    }
    return status ? 'Diterima' : 'Pending'; // Gunakan nilai bool langsung
  }

  Color _getStatusColor(bool? status) {
    if (status == null) {
        return Colors.orange; // Warna default untuk status null
    }
    return status ? Colors.green : Colors.red; // Gunakan nilai bool langsung
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
        backgroundColor: themeColor,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _fetchOrders();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            )
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_rounded,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pesanan',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchOrders,
                  color: themeColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final bool? status = order['status'] as bool?;
                      final String price = order['product']['price']; // Ambil price dari API
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
                            order['product']['product_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                "Harga: Rp $price", // Tampilkan harga
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getStatusColor(status),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(status),
                                  style: TextStyle(
                                    color: _getStatusColor(status),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_cart,
                              color: themeColor,
                              size: 28,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
