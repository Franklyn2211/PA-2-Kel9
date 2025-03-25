class Berita {
  int id;
  String title;
  String description;
  String photo;
  DateTime createdAt;
  DateTime updatedAt;
  String photoUrl;

  Berita({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
    required this.photoUrl,
  });

  // Factory method to create a Berita instance from JSON
  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      photo: json['photo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      photoUrl: json['photo_url'],
    );
  }
}