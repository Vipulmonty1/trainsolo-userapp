/// Status : "true"
/// Message : ""
/// Data : [{"PLAN_ID":2,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"Rx TITLE 222","DRILLS_JSON_DATA":"2,5,66,77,88,99,100","TOTAL_DURATION":"450","THUMBNAIL_NAME":"RT","IS_BOOKMARKED":0,"IS_SHARED":1}]

class SharedStatsUsersResponse {
  String _status;
  String _message;
  List<SharedStatsUsersData> _data;

  String get status => _status;
  String get message => _message;
  List<SharedStatsUsersData> get data => _data;

  SharedStatsUsersResponse(
      {String status, String message, List<SharedStatsUsersData> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SharedStatsUsersResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(SharedStatsUsersData.fromJson(v));
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

class SharedStatsUsersData {
  int _usrid;
  String _username;
  String _thumbnailname;
  String _positioncode;
  int _iscompleted;
  int _userplanid;

  int get usrid => _usrid;
  int get userplanid => _userplanid;
  String get username => _username;
  String get positioncode => _positioncode;
  String get thumbnailname => _thumbnailname;
  int get iscompleted => _iscompleted;

  SharedStatsUsersData(
      {int usrid,
      String username,
      String thumbnailname,
      String positioncode,
      int iscompleted,
      int userplanid}) {
    _usrid = usrid;
    _username = username;
    _thumbnailname = thumbnailname;
    _positioncode = positioncode;
    _iscompleted = iscompleted;
    _userplanid = userplanid;
  }

  SharedStatsUsersData.fromJson(dynamic json) {
    _usrid = json["USR_ID"];
    _username = json["UserName"];
    _thumbnailname = json["profile_pic_url"];
    _positioncode = json["position_code"];
    _iscompleted = json["is_completed"];
    _userplanid = json["plan_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["USR_ID"] = _usrid;
    map["UserName"] = _username;
    map["profile_pic_url"] = _thumbnailname;
    map["position_code"] = _positioncode;
    map["is_completed"] = _iscompleted;
    map["plan_id"] = _userplanid;
    return map;
  }
}
