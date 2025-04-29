class Residents {
  final int id;
  final String nik;
  final String name;
  final String gender;
  final String address;
  final String birthDate;
  final String religion;
  final String familyCardNumber;
  final String? photoUrl;

  Residents({
    required this.id,
    required this.nik,
    required this.name,
    required this.gender,
    required this.address,
    required this.birthDate,
    required this.religion,
    required this.familyCardNumber,
    this.photoUrl,
  });

  factory Residents.fromJson(Map<String, dynamic> json) {
    return Residents(
      id: json['id'] ?? 0,
      nik: json['nik'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      birthDate: json['birth_date'] ?? '',
      religion: json['religion'] ?? '',
      familyCardNumber: json['family_card_number'] ?? '',
      photoUrl: json['photo_url'],
    );
  }
}