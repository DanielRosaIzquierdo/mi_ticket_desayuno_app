// To parse this JSON data, do
//
//     final purchaseFromHistory = purchaseFromHistoryFromJson(jsonString);

import 'dart:convert';

List<Purchase> purchaseFromHistoryFromJson(String str) =>
    List<Purchase>.from(json.decode(str).map((x) => Purchase.fromJson(x)));

String purchaseFromHistoryToJson(List<Purchase> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Purchase {
  String id;
  String userId;
  String? userEmail;
  List<Product> products;
  double totalAmount;
  DateTime date;
  int discount;

  Purchase({
    required this.id,
    required this.userId,
    this.userEmail,
    required this.products,
    required this.totalAmount,
    required this.date,
    this.discount = 0
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
    id: json["id"],
    userId: json["userId"],
    products: List<Product>.from(
      json["products"].map((x) => Product.fromJson(x)),
    ),
    totalAmount: json["totalAmount"]?.toDouble(),
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "totalAmount": totalAmount,
    "date": date.toIso8601String(),
  };
}

class Product {
  String name;
  int quantity;
  double price;
  String? imageAsset;

  Product({
    required this.name,
    required this.quantity,
    required this.price,
    this.imageAsset,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json["name"],
    quantity: json["quantity"],
    price: json["price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "price": price,
  };
}
