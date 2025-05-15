class Penduduk {
  final String nik;
  final String name;
  final String? password; // Optional karena mungkin tidak ingin menampilkan

  Penduduk({
    required this.nik,
    required this.name,
    this.password,
  });

  factory Penduduk.fromJson(Map<String, dynamic> json) {
    return Penduduk(
      nik: json['nik'],
      name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'name': name,
      if (password != null) 'password': password,
    };
  }
}