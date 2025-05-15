import 'package:flutter/material.dart';
import '../models/berita.dart';
<<<<<<< HEAD
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_html/flutter_html.dart'; // Import flutter_html package
=======
import 'package:flutter_html/flutter_html.dart'; // Tambahkan ini
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520

class BeritaDetailPage extends StatelessWidget {
  final Berita berita;

  const BeritaDetailPage({Key? key, required this.berita}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format date in Indonesian format
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formattedDate = formatter.format(berita.createdAt.toLocal());
    
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.white,
      // Custom scroll view for better scrolling effects
      body: CustomScrollView(
        slivers: [
          // App bar with image background
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.blue[800],
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
=======
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Detail Berita",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul berita
            Center(
              child: Text(
                berita.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero image
                  Image.network(
                    berita.photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and date
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Berita Desa",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Title
                      Text(
                        berita.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Date and time
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            "${berita.createdAt.toLocal().hour}:${berita.createdAt.toLocal().minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      
                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Divider(color: Colors.grey[300], thickness: 1),
                      ),
                    ],
                  ),
                ),
                
                // Content with HTML rendering
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article content using basic flutter_html
                      Container(
                        child: Html(
                          data: berita.description,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Share and bookmark buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Share button
                          ElevatedButton.icon(
                            onPressed: () {
                              // Share functionality
                            },
                            icon: const Icon(Icons.share, size: 20),
                            label: const Text("Bagikan"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue[800],
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Bookmark button
                          OutlinedButton.icon(
                            onPressed: () {
                              // Bookmark functionality
                            },
                            icon: const Icon(Icons.bookmark_border, size: 20),
                            label: const Text("Simpan"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue[800],
                              side: BorderSide(color: Colors.blue[800]!),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
          ),
        ],
=======
            SizedBox(height: 20),

            // Gambar berita dengan shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  berita.photoUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Deskripsi berita dengan format HTML
            Html(
              data: berita.description,
              style: {
                "body": Style(
                  fontSize: FontSize(16.0),
                  color: Colors.grey[800],
                  lineHeight: LineHeight(1.5),
                ),
                "b": Style(
                  fontWeight: FontWeight.bold,
                ),
                "strong": Style(
                  fontWeight: FontWeight.bold,
                ),
                "i": Style(
                  fontStyle: FontStyle.italic,
                ),
                "em": Style(
                  fontStyle: FontStyle.italic,
                ),
              },
            ),
          ],
        ),
>>>>>>> 2adfedfdb119fb23cc6b2b49ca139581a3432520
      ),
    );
  }
}