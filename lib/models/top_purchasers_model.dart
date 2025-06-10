// To parse this JSON data, do
//
//     final topPurchasers = topPurchasersFromJson(jsonString);

import 'dart:convert';

List<TopPurchaser> topPurchasersFromJson(String str) => List<TopPurchaser>.from(json.decode(str).map((x) => TopPurchaser.fromJson(x)));

String topPurchasersToJson(List<TopPurchaser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopPurchaser {
    String email;
    int purchaseCount;

    TopPurchaser({
        required this.email,
        required this.purchaseCount,
    });

    factory TopPurchaser.fromJson(Map<String, dynamic> json) => TopPurchaser(
        email: json["email"],
        purchaseCount: json["purchaseCount"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "purchaseCount": purchaseCount,
    };
}
