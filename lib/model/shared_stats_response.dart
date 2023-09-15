/// Status : "true"
/// Message : ""
/// Data : [{"PLAN_ID":2,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"Rx TITLE 222","DRILLS_JSON_DATA":"2,5,66,77,88,99,100","TOTAL_DURATION":"450","THUMBNAIL_NAME":"RT","IS_BOOKMARKED":0,"IS_SHARED":1}]

class SharedStatsResponse {
  String _status;
  String _message;
  List<SharedStatsData> _data;

  String get status => _status;
  String get message => _message;
  List<SharedStatsData> get data => _data;

  SharedStatsResponse({
      String status, 
      String message, 
      List<SharedStatsData> data}){
    _status = status;
    _message = message;
    _data = data;
}

  SharedStatsResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(SharedStatsData.fromJson(v));
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

class SharedStatsData {
  int _planid;
  int _usrid;
  String _username;
  String _plantitle;
  String _drillsjsondata;
  String _totalduration;
  String _thumbnailname;
  int _isbookmarked;
  int _isshared;

  int get planid => _planid;
  int get usrid => _usrid;
  String get username => _username;
  String get plantitle => _plantitle;
  String get drillsjsondata => _drillsjsondata;
  String get totalduration => _totalduration;
  String get thumbnailname => _thumbnailname;
  int get isbookmarked => _isbookmarked;
  int get isshared => _isshared;

  SharedStatsData({
      int planid, 
      int usrid, 
      String username, 
      String plantitle, 
      String drillsjsondata, 
      String totalduration, 
      String thumbnailname, 
      int isbookmarked, 
      int isshared}){
    _planid = planid;
    _usrid = usrid;
    _username = username;
    _plantitle = plantitle;
    _drillsjsondata = drillsjsondata;
    _totalduration = totalduration;
    _thumbnailname = thumbnailname;
    _isbookmarked = isbookmarked;
    _isshared = isshared;
}

  SharedStatsData.fromJson(dynamic json) {
    _planid = json["PLAN_ID"];
    _usrid = json["USR_ID"];
    _username = json["USERNAME"];
    _plantitle = json["PLAN_TITLE"];
    _drillsjsondata = json["DRILLS_JSON_DATA"];
    _totalduration = json["TOTAL_DURATION"];
    _thumbnailname = json["THUMBNAIL_NAME"];
    _isbookmarked = json["IS_BOOKMARKED"];
    _isshared = json["IS_SHARED"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["PLAN_ID"] = _planid;
    map["USR_ID"] = _usrid;
    map["USERNAME"] = _username;
    map["PLAN_TITLE"] = _plantitle;
    map["DRILLS_JSON_DATA"] = _drillsjsondata;
    map["TOTAL_DURATION"] = _totalduration;
    map["THUMBNAIL_NAME"] = _thumbnailname;
    map["IS_BOOKMARKED"] = _isbookmarked;
    map["IS_SHARED"] = _isshared;
    return map;
  }

}