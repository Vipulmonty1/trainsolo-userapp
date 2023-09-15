import 'dart:convert';

GetTeamByUserIdResponse getTeamByUserIdResponseFromJson(String str) => GetTeamByUserIdResponse.fromJson(json.decode(str));

String getTeamByUserIdResponseToJson(GetTeamByUserIdResponse data) => json.encode(data.toJson());

class GetTeamByUserIdResponse {
  GetTeamByUserIdResponse({
    this.status,
    this.message,
    this.data,
  });

  String status;
  String message;
  List<Team> data;

  factory GetTeamByUserIdResponse.fromJson(Map<String, dynamic> json) => GetTeamByUserIdResponse(
    status: json["Status"],
    message: json["Message"],
    data: List<Team>.from(json["Data"].map((x) => Team.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Team {
  Team({
    this.teamId,
    this.teamName,
    this.players,
    this.adminid,
    this.relationCoachUsr,
    this.teamCreatedBy,
    this.username,
  });

  int teamId;
  String teamName;
  String players;
  int adminid;
  String relationCoachUsr;
  int teamCreatedBy;
  String username;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    teamId: json["TEAM_ID"],
    teamName: json["TEAM_NAME"],
    players: json["PLAYERS"],
    adminid: json["ADMINID"],
    relationCoachUsr: json["RELATION_COACH_USR"],
    teamCreatedBy: json["TEAM_CREATED_BY"],
    username: json["USERNAME"],
  );

  Map<String, dynamic> toJson() => {
    "TEAM_ID": teamId,
    "TEAM_NAME": teamName,
    "PLAYERS": players,
    "ADMINID": adminid,
    "RELATION_COACH_USR": relationCoachUsr,
    "TEAM_CREATED_BY": teamCreatedBy,
    "USERNAME": username,
  };
}
