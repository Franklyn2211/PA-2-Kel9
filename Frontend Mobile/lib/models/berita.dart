class Berita {
  final int id;
  final String judul;
  final String isi;
  final String tanggal;

  Berita({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
  });

  // Konversi JSON ke Model
  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      tanggal: json['tanggal'],
    );
  }

  // Konversi Model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
    };
  }
}
