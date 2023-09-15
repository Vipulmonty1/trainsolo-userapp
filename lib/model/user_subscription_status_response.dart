class UserSubscriptionStatusResponse {
  String _status;
  String _message;
  Data _data;

  UserSubscriptionStatusResponse({String status, String message, Data data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  String get status => _status;
  String get message => _message;
  Data get data => _data;

  UserSubscriptionStatusResponse.fromJson(dynamic json) {
    // print("User subscription status response from json running ...");
    // print(
    //     "Type of data to json status in subscription: ${json["Status"].runtimeType}");
    _status = json["Status"];
    // print(
    //     "Type of data to json message in subscription: ${json["Message"].runtimeType}");
    _message = json["Message"];
    // print("JSON SUBSCRIPTION DATA: ${json["Data"]}");
    // print(
    //     "Type of data to json in subscription: ${Data.fromJson(json["Data"][0]).runtimeType}");
    _data = json["Data"] != null ? Data.fromJson(json["Data"][0]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Status"] = _status;
    map["Message"] = _message;
    if (_data != null) {
      // print("Type of data to json in subscription: ${_data.toJson()}");
      map["Data"] = _data.toJson();
    }
    return map;
  }
}

class Data {
  String _expired;
  String _subscription_required;

  String get expired => _expired;
  String get subscription_required => _subscription_required;

  Data({String expired, String subscription_required}) {
    _expired = expired;
    _subscription_required = subscription_required;
  }

  Data.fromJson(dynamic json) {
    _expired = json["EXPIRED"];
    _subscription_required = json["SUBSCRIPTION_REQUIRED"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["EXPIRED"] = _expired;
    map["SUBSCRIPTION_REQUIRED"] = _subscription_required;
  }
}
