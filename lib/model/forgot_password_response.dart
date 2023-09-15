class ForgotPasswordResponse {
  bool _status;
  String _message;
  dynamic _data;

  bool get status => _status;
  String get message => _message;
  dynamic get data => _data;

  ForgotPasswordResponse({bool status, String message, dynamic data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  ForgotPasswordResponse.fromJson(dynamic json) {
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
