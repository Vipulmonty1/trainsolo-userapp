/// Status : "true"
/// Message : ""
/// Data : [{"PLAN_ID":10,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"PLAN TITLE 1","DRILLS_JSON_DATA":"1,2,3,9,111","TOTAL_DURATION":null,"THUMBNAIL_NAME":"pt","IS_BOOKMARKED":1},{"PLAN_ID":9,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"PLAN TITLE 1","DRILLS_JSON_DATA":"1,2,3,9,111","TOTAL_DURATION":null,"THUMBNAIL_NAME":"pt","IS_BOOKMARKED":1},{"PLAN_ID":8,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"PLAN TITLE 1","DRILLS_JSON_DATA":"1,2,3,9,111","TOTAL_DURATION":null,"THUMBNAIL_NAME":"PT","IS_BOOKMARKED":1},{"PLAN_ID":7,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"PLAN TITLE 1","DRILLS_JSON_DATA":"1,2,3,9,111","TOTAL_DURATION":"210","THUMBNAIL_NAME":"PT","IS_BOOKMARKED":1},{"PLAN_ID":6,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"PLAN TITLE 1","DRILLS_JSON_DATA":"1,2,3,9,111","TOTAL_DURATION":"210","THUMBNAIL_NAME":"PT","IS_BOOKMARKED":1},{"PLAN_ID":5,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"PLAN TITLE 1","DRILLS_JSON_DATA":"1,2,3,9,111","TOTAL_DURATION":"210","THUMBNAIL_NAME":"PT","IS_BOOKMARKED":1},{"PLAN_ID":4,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"PLAN TITLE 1","DRILLS_JSON_DATA":"1,2,3,9,111","TOTAL_DURATION":null,"THUMBNAIL_NAME":"PT","IS_BOOKMARKED":1},{"PLAN_ID":3,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"PLAN TITLE 1","DRILLS_JSON_DATA":"1,2,3,9,111","TOTAL_DURATION":null,"THUMBNAIL_NAME":"PT","IS_BOOKMARKED":1},{"PLAN_ID":2,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_TITLE":"Rx TITLE 222","DRILLS_JSON_DATA":"2,5,66,77,88,99,100","TOTAL_DURATION":"450","THUMBNAIL_NAME":"RT","IS_BOOKMARKED":0}]

class GetPlanListByIdResponse {
  String _status;
  String _message;
  List<Plan> _data;

  String get status => _status;
  String get message => _message;
  List<Plan> get data => _data;

  GetPlanListByIdResponse({
      String status, 
      String message, 
      List<Plan> data}){
    _status = status;
    _message = message;
    _data = data;
}

  GetPlanListByIdResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(Plan.fromJson(v));
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

/// PLAN_ID : 10
/// USR_ID : 3
/// USERNAME : "RAKSHIT2"
/// PLAN_TITLE : "PLAN TITLE 1"
/// DRILLS_JSON_DATA : "1,2,3,9,111"
/// TOTAL_DURATION : null
/// THUMBNAIL_NAME : "pt"
/// IS_BOOKMARKED : 1

class Plan {
  int _planid;
  int _usrid;
  String _username;
  String _plantitle;
  String _drillsjsondata;
  dynamic _totalduration;
  String _thumbnailname;
  int _isbookmarked;

  int get planid => _planid;
  int get usrid => _usrid;
  String get username => _username;
  String get plantitle => _plantitle;
  String get drillsjsondata => _drillsjsondata;
  dynamic get totalduration => _totalduration;
  String get thumbnailname => _thumbnailname;
  int get isbookmarked => _isbookmarked;

  Plan({
      int planid, 
      int usrid, 
      String username, 
      String plantitle, 
      String drillsjsondata, 
      dynamic totalduration, 
      String thumbnailname, 
      int isbookmarked}){
    _planid = planid;
    _usrid = usrid;
    _username = username;
    _plantitle = plantitle;
    _drillsjsondata = drillsjsondata;
    _totalduration = totalduration;
    _thumbnailname = thumbnailname;
    _isbookmarked = isbookmarked;
}

  Plan.fromJson(dynamic json) {
    _planid = json["PLAN_ID"];
    _usrid = json["USR_ID"];
    _username = json["USERNAME"];
    _plantitle = json["PLAN_TITLE"];
    _drillsjsondata = json["DRILLS_JSON_DATA"];
    _totalduration = json["TOTAL_DURATION"];
    _thumbnailname = json["THUMBNAIL_NAME"];
    _isbookmarked = json["IS_BOOKMARKED"];
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
    return map;
  }

}