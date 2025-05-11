class ProfilDesa {
  final int id;
  final String history;
  final String visi;
  final String misi;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfilDesa({
    required this.id,
    required this.history,
    required this.visi,
    required this.misi,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method untuk membuat instance dari JSON
  factory ProfilDesa.fromJson(Map<String, dynamic> json) {
    return ProfilDesa(
      id: json['id'],
      history: json['history'],
      visi: json['visi'],
      misi: json['misi'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method untuk mengonversi instance ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'history': history,
      'visi': visi,
      'misi': misi,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
