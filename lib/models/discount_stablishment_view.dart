// To parse this JSON data, do
//
//     final discountStablishmentView = discountStablishmentViewFromJson(jsonString);

import 'dart:convert';

List<DiscountStablishmentView> discountStablishmentViewFromJson(String str) => List<DiscountStablishmentView>.from(json.decode(str).map((x) => DiscountStablishmentView.fromJson(x)));

String discountStablishmentViewToJson(List<DiscountStablishmentView> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscountStablishmentView {
    String id;
    String type;
    int value;
    int discount;
    String conditions;

    DiscountStablishmentView({
        required this.id,
        required this.type,
        required this.value,
        required this.discount,
        required this.conditions,
    });

    factory DiscountStablishmentView.fromJson(Map<String, dynamic> json) => DiscountStablishmentView(
        id: json["id"],
        type: json["type"],
        value: json["value"],
        discount: json["discount"],
        conditions: json["conditions"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
        "discount": discount,
        "conditions": conditions,
    };
}
