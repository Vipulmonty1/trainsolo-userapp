import 'dart:convert';

CollegeTestInfo collegeTestInfoFromJson(String str) => CollegeTestInfo.fromJson(json.decode(str));

String collegeTestInfoToJson(CollegeTestInfo data) => json.encode(data.toJson());

class CollegeTestInfo {
  CollegeTestInfo({
    this.id,
    this.explanation,
    this.name,
    this.frequency,
    this.setupImgName,
    this.thumbnailImgName,
    this.audioFile,
  });

  String id;
  String explanation;
  String name;
  int frequency;
  dynamic setupImgName;
  String thumbnailImgName;
  dynamic audioFile;

  factory CollegeTestInfo.fromJson(Map<String, dynamic> json) => CollegeTestInfo(
    id: json["_id"],
    explanation: json["explanation"],
    name: json["name"],
    frequency: json["frequency"],
    setupImgName: json["setupImgName"],
    thumbnailImgName: json["thumbnailImgName"],
    audioFile: json["audioFile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "explanation": explanation,
    "name": name,
    "frequency": frequency,
    "setupImgName": setupImgName,
    "thumbnailImgName": thumbnailImgName,
    "audioFile": audioFile,
  };
}
