import 'package:trainsolo/model/get_drill_response.dart';

/// Status : "true"
/// Message : ""
/// Data : [{"REC_ID":109,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_ID":122,"STARTDATE":"2021-07-11 11:24:30","ENDDATE":"2021-07-11 11:45:50","IS_COMPLETED":1,"DURATIONS":200,"DRILLID":66,"VIDEOID":"vkHw_hWZTh8","HASMATCHANALYSIS":"false","MATCHANALYSISID":null,"CATEGORY":"Dribbling","TITLE":"Stepover Ladder","DIFFICULTY":"Advanced","DRILLDESCRIPTION":"Move through the cone ladder while performing stepovers. Use the outside of your foot to push the ball across the cones and then quickly perform a stepover. Focus on properly weighting that outside touch so it does not roll too far away from you. Suggested reps: 3 rounds of 4 reps (1 rep is up and back).","INSESSIONPLAN":"false","SESSIONPLANOBJECTID":null,"VIMEOID":"574217909","ROUND_REQUIRED":3,"REPS_REQUIRED":4,"NO_OF_PARTICIPANTS":1,"POSITIONS":null,"THUMBNAIL":null},{"REC_ID":110,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_ID":122,"STARTDATE":null,"ENDDATE":null,"IS_COMPLETED":0,"DURATIONS":null,"DRILLID":67,"VIDEOID":"frvShhuvzq4","HASMATCHANALYSIS":"true","MATCHANALYSISID":"P9vKaqv7kRo","CATEGORY":"Dribbling","TITLE":"Sole Roll Ladder","DIFFICULTY":"Advanced","DRILLDESCRIPTION":"Work through the cone ladder using sole rolls. Sole roll the ball across the cone and stabilize it with an inside the boot touch. Keep repeating. Challenge yourself by increasing your speed and keeping your head up. Suggested reps: 3 rounds of 4 reps (1 rep is up and back)","INSESSIONPLAN":"false","SESSIONPLANOBJECTID":null,"VIMEOID":"574218554","ROUND_REQUIRED":3,"REPS_REQUIRED":4,"NO_OF_PARTICIPANTS":1,"POSITIONS":"defender_midfielder_striker","THUMBNAIL":null},{"REC_ID":111,"USR_ID":3,"USERNAME":"RAKSHIT2","PLAN_ID":122,"STARTDATE":null,"ENDDATE":null,"IS_COMPLETED":0,"DURATIONS":null,"DRILLID":90,"VIDEOID":"gnYBF8g6lO0","HASMATCHANALYSIS":"true","MATCHANALYSISID":"2c6BMF2_3UU","CATEGORY":"Dribbling","TITLE":"Figure 8 Cruyff Turn","DIFFICULTY":"Advanced","DRILLDESCRIPTION":"Starting at one corner of the box, you are going to perform cruyff turns at each cone. Follow the dribbling pattern, diagonal, straight, diagonal straight, until you return to your starting corner. Focus on accelerating after each turn. You must return to your starting cone to complete a rep. Suggested reps: 3 rounds of 3 reps.","INSESSIONPLAN":"false","SESSIONPLANOBJECTID":null,"VIMEOID":null,"ROUND_REQUIRED":3,"REPS_REQUIRED":3,"NO_OF_PARTICIPANTS":1,"POSITIONS":null,"THUMBNAIL":null}]

class GetPlanInfoResponse {
  String _status;
  String _message;
  List<Drills> _data;

  String get status => _status;
  String get message => _message;
  List<Drills> get data => _data;

  GetPlanInfoResponse({
      String status, 
      String message, 
      List<Drills> data}){
    _status = status;
    _message = message;
    _data = data;
}

  GetPlanInfoResponse.fromJson(dynamic json) {
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


