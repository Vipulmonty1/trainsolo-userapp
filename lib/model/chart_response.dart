/// Status : "true"
/// Message : ""
/// Data : [{"PLAN_ID":2,"USR_ID":3,"collegename":"RAKSHIT2","PLAN_TITLE":"Rx TITLE 222","DRILLS_JSON_DATA":"2,5,66,77,88,99,100","TOTAL_DURATION":"450","THUMBNAIL_NAME":"RT","IS_BOOKMARKED":0,"IS_SHARED":1}]

class ChartResponse {
  String _status;
  String _message;
  List<ChartData> _data;

  String get status => _status;
  String get message => _message;
  List<ChartData> get data => _data;

  ChartResponse({String status, String message, List<ChartData> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  ChartResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(ChartData.fromJson(v));
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

class ChartData {
  int _level;
  String _collegename;
  String _testname;

  int get level => _level;
  String get collegename => _collegename;
  String get testname => _testname;

  ChartData({int level, String collegename, String testname}) {
    _level = level;
    _collegename = collegename;
    _testname = testname;
  }

  ChartData.fromJson(dynamic json) {
    _level = json["LEVEL"];
    _collegename = json["COLLEGE_NAME"];
    _testname = json["TEST_NAME"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["LEVEL"] = _level;
    map["COLLEGE_NAME"] = _collegename;
    map["TEST_NAME"] = _testname;

    return map;
  }
}
