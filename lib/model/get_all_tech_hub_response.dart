/// Status : "true"
/// Message : ""
/// Data : [{"CATEGORY":"Ball Work","THUMBNAIL":"/lib/5.jpg"},{"CATEGORY":"Juggling","THUMBNAIL":"/lib/18.jpg"},{"CATEGORY":"Wall Work","THUMBNAIL":"/lib/23.jpg"}]

class GetAllTechHubResponse {
  String _status;
  String _message;
  List<Category> _data;

  String get status => _status;
  String get message => _message;
  List<Category> get data => _data;

  GetAllTechHubResponse({
      String status, 
      String message, 
      List<Category> data}){
    _status = status;
    _message = message;
    _data = data;
}

  GetAllTechHubResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(Category.fromJson(v));
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

/// CATEGORY : "Ball Work"
/// THUMBNAIL : "/lib/5.jpg"

class Category {
  String _category;
  String _thumbnail;

  String get category => _category;
  String get thumbnail => _thumbnail;

  Category({
      String category, 
      String thumbnail}){
    _category = category;
    _thumbnail = thumbnail;
}

  Category.fromJson(dynamic json) {
    _category = json["CATEGORY"];
    _thumbnail = json["THUMBNAIL"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["CATEGORY"] = _category;
    map["THUMBNAIL"] = _thumbnail;
    return map;
  }

}