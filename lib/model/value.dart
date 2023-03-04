// To parse this JSON data, do
//
//     final resultsResponse = resultsResponseFromMap(jsonString);

import 'dart:convert';

class ResultValue {
  ResultValue({
    required this.value,
  });

  final int value;

  factory ResultValue.fromJson(String str) =>
      ResultValue.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultValue.fromMap(Map<String, dynamic> json) => ResultValue(
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
      };
}
