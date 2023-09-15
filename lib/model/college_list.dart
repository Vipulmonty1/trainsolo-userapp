import 'dart:convert';

import 'package:trainsolo/model/search_college_response.dart';

CollegeList collegeListFromJson(String str) => CollegeList.fromJson(json.decode(str));

String collegeListToJson(CollegeList data) => json.encode(data.toJson());

class CollegeList {
  CollegeList({
    this.status,
    this.message,
    this.data,
  });

  String status;
  String message;
  List<College> data;

  factory CollegeList.fromJson(Map<String, dynamic> json) => CollegeList(
    status: json["Status"],
    message: json["Message"],
    data: List<College>.from(json["Data"].map((x) => College.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}