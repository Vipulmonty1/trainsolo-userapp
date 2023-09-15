import 'dart:convert';

GetUsersByFitnessIdResponse getUsersByFitnessIdResponseFromJson(String str) => GetUsersByFitnessIdResponse.fromJson(json.decode(str));

String getUsersByFitnessIdResponseToJson(GetUsersByFitnessIdResponse data) => json.encode(data.toJson());

class GetUsersByFitnessIdResponse {
  GetUsersByFitnessIdResponse({
    this.status,
    this.message,
    this.data,
  });

  String status;
  String message;
  List<LeaderBoardData> data;

  factory GetUsersByFitnessIdResponse.fromJson(Map<String, dynamic> json) => GetUsersByFitnessIdResponse(
    status: json["Status"],
    message: json["Message"],
    data: List<LeaderBoardData>.from(json["Data"].map((x) => LeaderBoardData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class LeaderBoardData {
  LeaderBoardData({
    this.position,
    this.name,
    this.profilePhoto,
    this.shortName,
    this.desc,
    this.usrId,
  });

  String position;
  String name;
  String profilePhoto;
  String shortName;
  String desc;
  String usrId;

  factory LeaderBoardData.fromJson(Map<String, dynamic> json) => LeaderBoardData(
    position: json["position"],
    name: json["name"],
    profilePhoto: json["profilePhoto"],
    shortName: json["ShortName"],
    desc: json["Desc"],
    usrId: json["USR_ID"],
  );

  Map<String, dynamic> toJson() => {
    "position": position,
    "name": name,
    "profilePhoto": profilePhoto,
    "ShortName": shortName,
    "Desc": desc,
    "USR_ID": usrId,
  };
}
