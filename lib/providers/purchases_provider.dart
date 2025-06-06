import 'package:flutter/material.dart';
import 'package:mi_ticket_desayuno_app/client/dio_service.dart';
import 'package:mi_ticket_desayuno_app/models/purchase_model.dart';

class PurchasesProvider with ChangeNotifier {
  // 1. Lista mock de productos
  final List<Product> products = [
    Product(name: 'Café', price: 1.50, imageAsset: 'assets/images/cafe.jpg'),
    Product(
      name: 'Croissant',
      price: 2.00,
      imageAsset: 'assets/images/croissant.jpg',
    ),
    Product(name: 'Zumo', price: 3.00, imageAsset: 'assets/images/zumo.jpg'),
    Product(
      name: 'Tostada',
      price: 2.00,
      imageAsset: 'assets/images/tostada.png',
    ),
    Product(name: 'Té', price: 1.50, imageAsset: 'assets/images/te.jpg'),
  ];

  // 2. Lista de nombres de productos “seleccionados”
  final List<String> selectedProductNames = [];

  // 3. Getter: cantidad para un producto dado
  int quantityOf(Product product) {
    return selectedProductNames.where((name) => name == product.name).length;
  }

  // 4. Getter: total acumulado
  double get total {
    double sum = 0;
    for (final product in products) {
      final qty = quantityOf(product);
      sum += product.price * qty;
    }
    return sum;
  }

  // 5. Incrementar / decrementar selección
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

  // -------------------------------------------------------------------
  // 6. Función para comprobar que el usuario existe en el backend
  Future<bool> checkUserExists(String userId) async {
    try {
      final dio = DioService.instance.client;
      // Asegúrate de que DioService.instance.client esté configurado con la baseUrl correcta.
      // Por ejemplo, en DioService podrías tener:
      //   _dio = Dio(BaseOptions(baseUrl: 'http://192.168.x.x:3000'));
      final response = await dio.get('/auth/user/$userId');
print('======================================== ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = response.data;
        // Dependiendo de cómo te devuelva el backend: si data es un Map con campo 'id':
        if (data != null && data['id'] != null) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 7. Genera el objeto Purchase a partir de userId y las cantidades actuales
  Purchase createPurchaseObject(String userId) {
    // Construimos la lista de Product a partir de selectedProductNames
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
      totalAmount: total,
      date: DateTime.now(),
    );
  }
}
