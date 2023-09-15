/// Status : "true"
/// Message : ""
/// Data : [{"position":"1","name":"RAKSHIT SHAH","profilePhoto":"/profiles/3.png","ShortName":"RS","Desc":"0 days 0 hours 7 minutes 18 seconds","USR_ID":"3"},{"position":"2","name":"Leigh Rickle","profilePhoto":"profile/130.jpg","ShortName":"LR","Desc":"0 days 0 hours 0 minutes 5 seconds","USR_ID":"130"},{"position":"3","name":"Sachin Parikh","profilePhoto":"","ShortName":"SP","Desc":"0 days 0 hours 0 minutes 0 seconds","USR_ID":"4"}]

class GetGlobalLeaderBoardResponse {
  String _status;
  String _message;
  List<LeaderBoardData> _data;

  String get status => _status;
  String get message => _message;
  List<LeaderBoardData> get data => _data;

  GetGlobalLeaderBoardResponse({
      String status, 
      String message, 
      List<LeaderBoardData> data}){
    _status = status;
    _message = message;
    _data = data;
}

  GetGlobalLeaderBoardResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(LeaderBoardData.fromJson(v));
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

/// position : "1"
/// name : "RAKSHIT SHAH"
/// profilePhoto : "/profiles/3.png"
/// ShortName : "RS"
/// Desc : "0 days 0 hours 7 minutes 18 seconds"
/// USR_ID : "3"

class LeaderBoardData {
  String _position;
  String _name;
  String _profilePhoto;
  String _shortName;
  String _desc;
  String _usrid;

  String get position => _position;
  String get name => _name;
  String get profilePhoto => _profilePhoto;
  String get shortName => _shortName;
  String get desc => _desc;
  String get usrid => _usrid;

  LeaderBoardData({
      String position, 
      String name, 
      String profilePhoto, 
      String shortName, 
      String desc, 
      String usrid}){
    _position = position;
    _name = name;
    _profilePhoto = profilePhoto;
    _shortName = shortName;
    _desc = desc;
    _usrid = usrid;
}

  LeaderBoardData.fromJson(dynamic json) {
    _position = json["position"];
    _name = json["name"];
    _profilePhoto = json["profilePhoto"];
    _shortName = json["ShortName"];
    _desc = json["Desc"];
    _usrid = json["USR_ID"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["position"] = _position;
    map["name"] = _name;
    map["profilePhoto"] = _profilePhoto;
    map["ShortName"] = _shortName;
    map["Desc"] = _desc;
    map["USR_ID"] = _usrid;
    return map;
  }

}