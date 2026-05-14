import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  final String? category;

  const Product({
    this.id,
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString(),
      barcode: (json['ean'] ?? json['barcode'] ?? '').toString(),
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString(),
      imageUrl: (json['photo_url'] ?? json['image_url'])?.toString(),
      category: json['category']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, barcode, name, brand, imageUrl, category];
}
