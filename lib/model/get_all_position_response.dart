/// Status : "true"
/// Message : ""
/// Data : [{"CODE":"GK","PLAYER_GROUP":"Goalkeeper","DESCRIPTION":"Goalkeeper"},{"CODE":"RB","PLAYER_GROUP":"Defenders","DESCRIPTION":"Right Fullback"},{"CODE":"LB","PLAYER_GROUP":"Defenders","DESCRIPTION":"Left Fullback"},{"CODE":"CB","PLAYER_GROUP":"Defenders","DESCRIPTION":"Center Back"},{"CODE":"CB2","PLAYER_GROUP":"Defenders","DESCRIPTION":"Center Back/Sweeper"},{"CODE":"DEF","PLAYER_GROUP":"Defenders","DESCRIPTION":"Defending/Holding Midfielder"},{"CODE":"RM","PLAYER_GROUP":"Midfielders","DESCRIPTION":"Right Midfielder/Winger"},{"CODE":"CM","PLAYER_GROUP":"Midfielders","DESCRIPTION":"Central/Box-to-Box Midfielder"},{"CODE":"S","PLAYER_GROUP":"Forwards","DESCRIPTION":"Striker"},{"CODE":"AM","PLAYER_GROUP":"Midfielders","DESCRIPTION":"Attacking Midfielder/Playmaker"},{"CODE":"LM","PLAYER_GROUP":"Midfielders","DESCRIPTION":"Left Midfielder/Wingers"}]

class GetAllPositionResponse {
  String _status;
  String _message;
  List<PositionData> _data;

  String get status => _status;
  String get message => _message;
  List<PositionData> get data => _data;

  GetAllPositionResponse({
      String status, 
      String message, 
      List<PositionData> data}){
    _status = status;
    _message = message;
    _data = data;
}

  GetAllPositionResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(PositionData.fromJson(v));
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

/// CODE : "GK"
/// PLAYER_GROUP : "Goalkeeper"
/// DESCRIPTION : "Goalkeeper"

class PositionData {
  String _code;
  String _playergroup;
  String _description;

  String get code => _code;
  String get playergroup => _playergroup;
  String get description => _description;

  PositionData({
      String code, 
      String playergroup, 
      String description}){
    _code = code;
    _playergroup = playergroup;
    _description = description;
}

  PositionData.fromJson(dynamic json) {
    _code = json["CODE"];
    _playergroup = json["PLAYER_GROUP"];
    _description = json["DESCRIPTION"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["CODE"] = _code;
    map["PLAYER_GROUP"] = _playergroup;
    map["DESCRIPTION"] = _description;
    return map;
  }

}