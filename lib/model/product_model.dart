 class ProductModel {
   final int id;
   final String name;
   final int price;
   final String image;
   final String detail;
   final int category;
   final int rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.detail,
    required this.category,
    required this.rating,
  });

  // from map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      image: map['image'] ?? '',
      detail: map['detail'] ?? '',
      category: map['category'] ?? '',
      rating: map['rating'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "image": image,
      "detail": detail,
      "category": category,
      "rating": rating,
    };
  }
}
