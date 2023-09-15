class MissionLeaderBoardResponse {
  String _status;
  String _message;
  List<MissionLeaderBoardData> _data;

  String get status => _status;
  String get message => _message;
  List<MissionLeaderBoardData> get data => _data;

  // ignore: non_constant_identifier_names
  MissionLeaderBoardResponse(
      {String status, String message, List<MissionLeaderBoardData> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  MissionLeaderBoardResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(MissionLeaderBoardData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Status"] = _status;
    map["Message"] = _message;
    if (_data != null) {
      map["Data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// PLAN_ID : 2
/// USR_ID : 3
/// USERNAME : "RAKSHIT2"
/// PLAN_TITLE : "Rx TITLE 222"
/// DRILLS_JSON_DATA : "2,5,66,77,88,99,100"
/// TOTAL_DURATION : "450"
/// THUMBNAIL_NAME : "RT"
/// IS_BOOKMARKED : 0
/// IS_SHARED : 1

class MissionLeaderBoardData {
  int _missionid;
  String _name;
  String _logo;
  String _desc;
  String _username;
  int _sessionCompleted;
  String _profilepic;
  int _position;

  int get missionid => _missionid;
  String get name => _name;
  String get logo => _logo;
  String get desc => _desc;
  String get username => _username;
  String get profilepic => _profilepic;
  int get sessionCompleted => _sessionCompleted;
  int get position => _position;

  MissionLeaderBoardData(
      {int missionid,
      String name,
      String logo,
      String desc,
      String username,
      String profilepic,
      int sessionCompleted,
      int position}) {
    _missionid = missionid;
    _name = name;
    _logo = logo;
    _desc = desc;
    _username = username;
    _profilepic = profilepic;
    _sessionCompleted = sessionCompleted;
    _position = position;
  }

  MissionLeaderBoardData.fromJson(dynamic json) {
    _missionid = json["MISSION_ID"];
    _name = json["MISSION_NAME"];
    _logo = json["MISSION_LOGO_URL"];
    _desc = json["MISSION_DESCRIPTION"];
    _username = json["USER_NAME"];
    _profilepic = json["PROFILE_PIC_URL"];
    _sessionCompleted = json["TOTAL_SESSIONS"];
    _position = json["position"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["MISSION_ID"] = _missionid;
    map["MISSION_NAME"] = _name;
    map["MISSION_LOGO_URL"] = _logo;
    map["MISSION_DESCRIPTION"] = _desc;
    map["USER_NAME"] = _username;
    map["PROFILE_PIC_URL"] = _profilepic;
    map["TOTAL_SESSIONS"] = _sessionCompleted;
    map["position"] = _position;
    return map;
  }
}
