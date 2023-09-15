class SingleAppParamResponse {
  String _status;
  String _message;
  dynamic _data;

  String get status => _status;
  String get message => _message;
  dynamic get data => _data;

  SingleAppParamResponse({String status, String message, dynamic data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SingleAppParamResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    _data = json["Data"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Status"] = _status;
    map["Message"] = _message;
    map["Data"] = _data;
    return map;
  }
}
