class MissionListResponse {
  String _status;
  String _message;
  List<MissonListData> _data;

  String get status => _status;
  String get message => _message;
  List<MissonListData> get data => _data;

  // ignore: non_constant_identifier_names
  MissionListResponse(
      {String status, String message, List<MissonListData> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  MissionListResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(MissonListData.fromJson(v));
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

class MissonListData {
  int _missionid;
  String _name;
  String _logo;
  String _desc;
  String _mediaurl;
  String _missionstaus;
  int _sessiontocomplete;
  int _contributors;
  int _totalmissionsession;
  int _personsessions;
  int _usersessionscnt;

  int get missionid => _missionid;
  String get name => _name;
  String get logo => _logo;
  String get desc => _desc;
  String get mediaurl => _mediaurl;
  String get missionstaus => _missionstaus;
  int get sessiontocomplete => _sessiontocomplete;
  int get contributors => _contributors;

  int get totalmissionsession => _totalmissionsession;
  int get personsessions => _personsessions;
  int get usersessionscnt => _usersessionscnt;

  MissonListData(
      {int missionid,
      String name,
      String logo,
      String desc,
      String mediaurl,
      String missionstaus,
      int sessiontocomplete,
      int contributors,
      int totalmissionsession,
      int personsessions,
      int usersessionscnt}) {
    _missionid = missionid;
    _name = name;
    _logo = logo;
    _desc = desc;
    _mediaurl = mediaurl;
    _missionstaus = missionstaus;
    _sessiontocomplete = sessiontocomplete;
    _contributors = contributors;
    _totalmissionsession = totalmissionsession;
    _personsessions = personsessions;
    _usersessionscnt = usersessionscnt;
  }

  MissonListData.fromJson(dynamic json) {
    _missionid = json["MISSION_ID"];
    _name = json["MISSION_NAME"];
    _logo = json["MISSION_LOGO_URL"];
    _desc = json["MISSION_DESCRIPTION"];
    _mediaurl = json["MEDIA_URL"];
    _missionstaus = json["MISSION_STATUS"];
    _sessiontocomplete = json["SESSIONS_TO_CMPLT"];
    _contributors = json["CONTRIBUTORS_COUNT"];

    _totalmissionsession = json["MISSION_TOTAL_TGT"];
    _personsessions = json["MISSION_PERSON_TGT"];
    _usersessionscnt = json["USR_SESSION_CNT"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["MISSION_ID"] = _missionid;
    map["MISSION_NAME"] = _name;
    map["MISSION_LOGO_URL"] = _logo;
    map["MISSION_DESCRIPTION"] = _desc;
    map["MEDIA_URL"] = _mediaurl;
    map["MISSION_STATUS"] = _missionstaus;
    map["SESSIONS_TO_CMPLT"] = _sessiontocomplete;
    map["CONTRIBUTORS_COUNT"] = _contributors;
    map["MISSION_TOTAL_TGT"] = _totalmissionsession;
    map["MISSION_PERSON_TGT"] = _personsessions;
    map["USR_SESSION_CNT"] = _usersessionscnt;

    return map;
  }
}
