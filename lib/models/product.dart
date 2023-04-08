import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String? brand;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    this.brand,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'brand': brand,
        'image': image,
      };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        name: map['name'],
        price: double.parse(map['price']),
        brand: map['brand'],
        image: map['image'],
      );

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Product(
      id: doc.id,
      name: data['name'],
      price: double.parse(data['price']),
      brand: data['brand'],
      image: data['image'],
    );
  }
}
