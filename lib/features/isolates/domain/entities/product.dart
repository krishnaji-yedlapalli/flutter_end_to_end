class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.rating,
  });

  @override
  String toString() =>
      'Product(id: $id, name: $name, category: $category, price: $price, stock: $stock, rating: $rating)';
}
