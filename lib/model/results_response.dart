// To parse this JSON data, do
//
//     final resultsResponse = resultsResponseFromMap(jsonString);

import 'dart:convert';

class ResultsResponse {
  ResultsResponse({
    required this.results,
  });

  final List<Result> results;

  factory ResultsResponse.fromJson(String str) =>
      ResultsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultsResponse.fromMap(Map<String, dynamic> json) => ResultsResponse(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class Result {
  Result({
    required this.id,
    required this.messagge,
    required this.date,
    required this.hour,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String messagge;
  final String date;
  final String hour;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["_id"],
        messagge: json["messagge"],
        date: json["date"],
        hour: json["hour"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "messagge": messagge,
        "date": date,
        "hour": hour,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
