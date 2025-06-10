// To parse this JSON data, do
//
//     final discountProgress = discountProgressFromJson(jsonString);

import 'dart:convert';

List<DiscountProgress> discountProgressFromJson(String str) => List<DiscountProgress>.from(json.decode(str).map((x) => DiscountProgress.fromJson(x)));

String discountProgressToJson(List<DiscountProgress> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscountProgress {
    String id;
    String type;
    int value;
    String conditions;
    int discount;
    double progress;

    DiscountProgress({
        required this.id,
        required this.type,
        required this.value,
        required this.conditions,
        required this.discount,
        required this.progress,
    });

    factory DiscountProgress.fromJson(Map<String, dynamic> json) => DiscountProgress(
        id: json["id"],
        type: json["type"],
        value: json["value"],
        conditions: json["conditions"],
        discount: json["discount"],
        progress: json["progress"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
        "conditions": conditions,
        "discount": discount,
        "progress": progress,
    };
}
