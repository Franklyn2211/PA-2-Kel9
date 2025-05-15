import 'package:flutter/material.dart';
import '../models/pengumuman.dart';
import '../services/api_service.dart';

class AllPengumumanPage extends StatelessWidget {
  final Color themeColor = const Color(0xFF3AC53E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Pengumuman'),
        backgroundColor: themeColor,
      ),
      body: FutureBuilder<List<Pengumuman>>(
        future: ApiService.fetchPengumuman(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: themeColor),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: const Text('Tidak ada pengumuman ditemukan'),
            );
          } else {
            List<Pengumuman> pengumumanList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pengumumanList.length,
              itemBuilder: (context, index) {
                final pengumuman = pengumumanList[index];
                return _pengumumanItem(pengumuman);
              },
            );
          }
        },
      ),
    );
  }

  Widget _pengumumanItem(Pengumuman pengumuman) {
    return Card(
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
              _removeHtmlTags(pengumuman.description),
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
          ],
        ),
      ),
    );
  }

  String _removeHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
