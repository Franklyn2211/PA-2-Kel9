class Product {
  final int id;
  final String productName;
  final String description;
  final String photoUrl;
  final String location;
  final String price;
  final int stock;
  final String phone;

  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.photoUrl,
    required this.location,
    required this.price,
    required this.stock,
    required this.phone,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      description: json['description'],
      photoUrl: json['photo_url'],
      location: json['location'],
      price: json['price'],
      stock: json['stock'],
      phone: json['phone'],
    );
  }
}
