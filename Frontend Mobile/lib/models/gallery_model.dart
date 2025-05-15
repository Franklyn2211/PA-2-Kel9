class Gallery {
  final int id;
  final String title;
  final String photoUrl;
  final String? dateTaken;
  final String createdAt;
  final String updatedAt;

  Gallery({
    required this.id,
    required this.title,
    required this.photoUrl,
    this.dateTaken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'],
      title: json['title'],
      photoUrl: json['photo_url'], // Gunakan photo_url dari API
      dateTaken: json['date_taken'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
