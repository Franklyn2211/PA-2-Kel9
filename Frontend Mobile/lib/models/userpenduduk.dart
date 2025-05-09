class Resident {
  final String nik;
  final String name;
  final String? password;
  final int? id; // Optional karena mungkin tidak ingin menampilkan

  Resident({
    required this.nik,
    required this.name,
    this.password,
    this.id,
  });
   @override
  String toString() {
    return 'Resident{id: $id, nik: $nik, name: $name}';
  }

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'],
      nik: json['nik'] ?? '',
      name: json['nama'] ?? '',
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nik': nik,
      'nama': name,
      'password': password,
    };
  }
}
