/// Status : "true"
/// Message : "Profile picture updated successfully."
/// Data : "/profiles/4.jpg"

class UploadPictureResponse {
  String _status;
  String _message;
  String _data;

  String get status => _status;
  String get message => _message;
  String get data => _data;

  UploadPictureResponse({
      String status, 
      String message, 
      String data}){
    _status = status;
    _message = message;
    _data = data;
}

  UploadPictureResponse.fromJson(dynamic json) {
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