// To parse this JSON data, do
//
//     final topSpenders = topSpendersFromJson(jsonString);

import 'dart:convert';

List<TopSpender> topSpendersFromJson(String str) => List<TopSpender>.from(json.decode(str).map((x) => TopSpender.fromJson(x)));

String topSpendersToJson(List<TopSpender> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopSpender {
    String email;
    double totalSpent;

    TopSpender({
        required this.email,
        required this.totalSpent,
    });

    factory TopSpender.fromJson(Map<String, dynamic> json) => TopSpender(
        email: json["email"],
        totalSpent: json["totalSpent"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "totalSpent": totalSpent,
    };
}
