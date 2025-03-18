class InformasiDesa {
  final int id;
  final String judul;
  final String konten;
  final String tanggal;

  InformasiDesa({
    required this.id,
    required this.judul,
    required this.konten,
    required this.tanggal,
  });

  // Konversi JSON ke Model
  factory InformasiDesa.fromJson(Map<String, dynamic> json) {
    return InformasiDesa(
      id: json['id'],
      judul: json['judul'],
      konten: json['konten'],
      tanggal: json['tanggal'],
    );
  }

  // Konversi Model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'konten': konten,
      'tanggal': tanggal,
    };
  }
}
