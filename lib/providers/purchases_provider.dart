import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_ticket_desayuno_app/client/dio_service.dart';
import 'package:mi_ticket_desayuno_app/models/purchase_model.dart';
import 'package:mi_ticket_desayuno_app/models/top_purchasers_model.dart';
import 'package:mi_ticket_desayuno_app/models/top_spenders_model.dart';

class PurchasesProvider with ChangeNotifier {
  final dio = DioService.instance.client;
  List<Purchase> purchases = [];
  List<TopSpender> topSpenders = [];
  List<TopPurchaser> topPurchasers = [];
  final List<Product> products = [
    Product(
      name: 'Café',
      price: 1.50,
      quantity: 0,
      imageAsset: 'assets/images/cafe.jpg',
    ),
    Product(
      name: 'Croissant',
      price: 2.00,
      quantity: 0,
      imageAsset: 'assets/images/croissant.jpg',
    ),
    Product(
      name: 'Zumo',
      price: 3.00,
      quantity: 0,
      imageAsset: 'assets/images/zumo.jpg',
    ),
    Product(
      name: 'Tostada',
      price: 2.00,
      quantity: 0,
      imageAsset: 'assets/images/tostada.png',
    ),
    Product(
      name: 'Té',
      price: 1.50,
      quantity: 0,
      imageAsset: 'assets/images/te.jpg',
    ),
  ];

  List<String> selectedProductNames = [];

  int quantityOf(Product product) {
    return selectedProductNames.where((name) => name == product.name).length;
  }

  double get total {
    double sum = 0;
    for (final product in products) {
      final qty = quantityOf(product);
      sum += product.price * qty;
    }
    return sum;
  }

  void increment(Product product) {
    selectedProductNames.add(product.name);
    notifyListeners();
  }

  void decrement(Product product) {
    final index = selectedProductNames.indexOf(product.name);
    if (index != -1) {
      selectedProductNames.removeAt(index);
      notifyListeners();
    }
  }

  bool get isEmpty => selectedProductNames.isEmpty;

  void clearAll() {
    selectedProductNames.clear();
    notifyListeners();
  }

  Future<void> getPurchases() async {
    final response = await dio.get('/purchases/all');

    if (response.statusCode == 200) {
      purchases = purchaseFromHistoryFromJson(jsonEncode(response.data));
      await addEmailToPurchases();
      notifyListeners();
    }
  }

  Purchase createPurchaseObject(String userId, int discount) {
    final selectedList = <Product>[];
    for (final prod in products) {
      final qty = quantityOf(prod);
      for (int i = 0; i < qty; i++) {
        selectedList.add(prod);
      }
    }

    return Purchase(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      products: selectedList,
      totalAmount: total - (total * (discount / 100)),
      date: DateTime.now(),
      discount: discount,
    );
  }

  void resetSelectedProducts() {
    selectedProductNames = [];
  }

  Future<void> addEmailToPurchases() async {
    for (var p in purchases) {
      try {
        final response = await dio.get('/auth/user/${p.userId}');
        if (response.statusCode == 200) {
          final data = response.data;
          if (data != null && data['id'] != null) {
            p.userEmail = data['email'];
          }
        }
      } catch (e) {}
    }
  }

  Future<void> getTopSpenders() async {
    try {
      final response = await dio.get('/purchases/top-spenders');
      if (response.statusCode == 200 && response.data != null) {
        topSpenders = topSpendersFromJson(jsonEncode(response.data));
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> getTopPurchasers() async {
    try {
      final response = await dio.get('/purchases/top-purchasers');
      if (response.statusCode == 200 && response.data != null) {
        topPurchasers = topPurchasersFromJson(jsonEncode(response.data));
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<bool> makePurchase(Purchase purchase, String discountId) async {
    try {
      // Agrupa productos por nombre y suma la cantidad
      final Map<String, Product> groupedProducts = {};
      for (final p in purchase.products) {
        if (groupedProducts.containsKey(p.name)) {
          groupedProducts[p.name] = Product(
            name: p.name,
            quantity: groupedProducts[p.name]!.quantity + 1,
            price: p.price,
          );
        } else {
          groupedProducts[p.name] = Product(
            name: p.name,
            quantity: 1,
            price: p.price,
          );
        }
      }

      final data = {
        "userId": purchase.userId,
        "products":
            groupedProducts.values
                .map(
                  (p) => {
                    "name": p.name,
                    "quantity": p.quantity,
                    "price": p.price,
                  },
                )
                .toList(),
        "totalAmount": purchase.totalAmount,
        "date": purchase.date.toUtc().toIso8601String(),
        "discountId": discountId,
      };

      final response = await dio.post(
        '/purchases/register',
        data: jsonEncode(data),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllPurchases() async {
    try {
      final response = await dio.delete('/purchases/all');

      if (response.statusCode == 200) {
        purchases.clear();
        topSpenders.clear();
        topPurchasers.clear();
        notifyListeners();

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
