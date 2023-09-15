import 'package:trainsolo/model/get_drill_response.dart';

/// Status : "true"
/// Message : ""
/// Data : [{"USR_ID":3,"USERNAME":"rakshit2","SCORE_TEXT":"10 Goals","SCORE_DATE":"2021-07-17 15:35:36","DRILLID":1,"VIDEOID":"KvD-4zIQ_1Y","HASMATCHANALYSIS":"true","MATCHANALYSISID":"575504479","CATEGORY":"Shooting","TITLE":"Stationary Slot Shot (6 Yards)","DIFFICULTY":"Beginner","DRILLDESCRIPTION":"Place a single ball on the six yard line. Use your instep to slot the ball into the net. Try and aim for the space between the post and the cone. Use both your right foot and left foot. Suggested reps: 3 rounds of 10 shots each foot.","INSESSIONPLAN":"false","SESSIONPLANOBJECTID":null,"VIMEOID":"567780291","ROUND_REQUIRED":3,"REPS_REQUIRED":6,"NO_OF_PARTICIPANTS":1,"POSITIONS":"Striker","THUMBNAIL":"https://i.vimeocdn.com/video/1173964704_640.jpg"},{"USR_ID":3,"USERNAME":"rakshit2","SCORE_TEXT":"10 Goals","SCORE_DATE":"2021-07-17 15:35:36","DRILLID":1,"VIDEOID":"KvD-4zIQ_1Y","HASMATCHANALYSIS":"true","MATCHANALYSISID":"575504479","CATEGORY":"Shooting","TITLE":"Stationary Slot Shot (6 Yards)","DIFFICULTY":"Beginner","DRILLDESCRIPTION":"Place a single ball on the six yard line. Use your instep to slot the ball into the net. Try and aim for the space between the post and the cone. Use both your right foot and left foot. Suggested reps: 3 rounds of 10 shots each foot.","INSESSIONPLAN":"false","SESSIONPLANOBJECTID":null,"VIMEOID":"567780291","ROUND_REQUIRED":3,"REPS_REQUIRED":6,"NO_OF_PARTICIPANTS":1,"POSITIONS":"Striker","THUMBNAIL":"https://i.vimeocdn.com/video/1173964704_640.jpg"},{"USR_ID":3,"USERNAME":"rakshit2","SCORE_TEXT":"10 Goals","SCORE_DATE":"2021-07-16 00:00:00","DRILLID":22,"VIDEOID":"mwvgOsqvpRg","HASMATCHANALYSIS":"false","MATCHANALYSISID":null,"CATEGORY":"Passing","TITLE":"10 Yard Straight Passing","DIFFICULTY":"Advanced","DRILLDESCRIPTION":"Stand 10 yards away from the wall and firmly pass the ball into the wall using one touch. Keep your ankle locked and toe pointed up. Challenge yourself by increasing the pace of your pass. Suggested reps: 3 rounds of 10 passes each foot.","INSESSIONPLAN":"false","SESSIONPLANOBJECTID":null,"VIMEOID":"565110014","ROUND_REQUIRED":3,"REPS_REQUIRED":20,"NO_OF_PARTICIPANTS":1,"POSITIONS":null,"THUMBNAIL":"https://i.vimeocdn.com/video/1168329670_640.jpg"}]

class GetAllTHDrillRecordsResponse {
  String _status;
  String _message;
  List<Drills> _data;

  String get status => _status;
  String get message => _message;
  List<Drills> get data => _data;

  GetAllTHDrillRecordsResponse({
      String status, 
      String message, 
      List<Drills> data}){
    _status = status;
    _message = message;
    _data = data;
}

  GetAllTHDrillRecordsResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(Drills.fromJson(v));
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

/// USR_ID : 3
/// USERNAME : "rakshit2"
/// SCORE_TEXT : "10 Goals"
/// SCORE_DATE : "2021-07-17 15:35:36"
/// DRILLID : 1
/// VIDEOID : "KvD-4zIQ_1Y"
/// HASMATCHANALYSIS : "true"
/// MATCHANALYSISID : "575504479"
/// CATEGORY : "Shooting"
/// TITLE : "Stationary Slot Shot (6 Yards)"
/// DIFFICULTY : "Beginner"
/// DRILLDESCRIPTION : "Place a single ball on the six yard line. Use your instep to slot the ball into the net. Try and aim for the space between the post and the cone. Use both your right foot and left foot. Suggested reps: 3 rounds of 10 shots each foot."
/// INSESSIONPLAN : "false"
/// SESSIONPLANOBJECTID : null
/// VIMEOID : "567780291"
/// ROUND_REQUIRED : 3
/// REPS_REQUIRED : 6
/// NO_OF_PARTICIPANTS : 1
/// POSITIONS : "Striker"
/// THUMBNAIL : "https://i.vimeocdn.com/video/1173964704_640.jpg"

