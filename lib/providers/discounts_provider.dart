import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_ticket_desayuno_app/client/dio_service.dart';
import 'package:mi_ticket_desayuno_app/models/discount_progress_model.dart';
import 'package:mi_ticket_desayuno_app/models/discount_stablishment_view.dart';

class DiscountsProvider with ChangeNotifier {
  final dio = DioService.instance.client;
  bool loadingFinalPrice = false;
  int discountPercent = 0;
  List<DiscountProgress> allDiscounts = [];
  List<DiscountStablishmentView> discountsStablishmentView = [];

  Future<void> getUserProgress() async {
    final response = await dio.get('/discounts/progress');

    if (response.statusCode == 200) {
      final discountProgressResponse = discountProgressFromJson(
        jsonEncode(response.data),
      );
      allDiscounts = discountProgressResponse;
      notifyListeners();
    }
  }

  Future<bool> getDiscountsStablishmentView() async {
    final response = await dio.get('/discounts');

    if (response.statusCode == 200) {
      final discountsStablishmentViewResponse =
          discountStablishmentViewFromJson(jsonEncode(response.data));
      discountsStablishmentView = discountsStablishmentViewResponse;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> deleteDiscount(String discountId) async {
    try {
      final response = await dio.delete('/discounts/$discountId');

      if (response.statusCode == 200) {
        discountsStablishmentView.removeWhere(
          (discount) => discount.id == discountId,
        );

        notifyListeners();

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> addDiscount({
    required String type,
    required int value,
    required String conditions,
    required int discount,
  }) async {
    try {
      final response = await dio.post(
        '/discounts',
        data: {
          "type": type,
          "value": value,
          "conditions": conditions,
          "discount": discount,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        return response.data['discountId'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void setLoadingFinalPrice() {
    loadingFinalPrice = true;
  }

  void setHasLoadedFinalPrice() {
    loadingFinalPrice = false;
  }

  Future<void> getDiscountPercentByUserId(String userId) async {
    setLoadingFinalPrice();
    try {
      final response = await dio.get('/discounts/$userId');
      if (response.statusCode == 200 && response.data != null) {
        setHasLoadedFinalPrice();
        discountPercent = int.parse(response.data["percent"]);
      }
      setHasLoadedFinalPrice();
      discountPercent = 0;
    } catch (e) {
      setHasLoadedFinalPrice();
      discountPercent = 0;
    }
  }
}
