class Product {
  final String name;
  final double price;
  final String? imageAsset;

  Product({required this.name, required this.price, this.imageAsset});
}

class Purchase {
  final String id;
  final String userId;
  final List<Product> products;
  final double totalAmount;
  final DateTime date;

  Purchase({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalAmount,
    required this.date,
  });
}
