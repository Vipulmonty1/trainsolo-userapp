/// Status : "true"
/// Message : ""
/// Data : [{"LIB_ID":1,"VIDEO_TITLE":"Single Scissors","THUMBNAIL":"/lib/1.jpg","VIMEO_URL":"https://vimeo.com/567780291","YOUTUBE_URL":"https://www.youtube.com/watch?v=bbUzCsGGJ6w","EXPLANATION":"Drive at the first set of cones. Perform a single scissor and quickly cut the ball back across your body. Finish in the final gate. This movement mimics sealing off your defender once you have beaten them. Reset each rep and use both right and left feet. Suggested reps: 3 rounds of 8.","REPS":3,"ROUNDS":8},{"LIB_ID":2,"VIDEO_TITLE":"Gated Roll Overs","THUMBNAIL":"/lib/2.jpg","VIMEO_URL":"https://vimeo.com/567780941","YOUTUBE_URL":null,"EXPLANATION":null,"REPS":null,"ROUNDS":null},{"LIB_ID":3,"VIDEO_TITLE":"La Croqueta","THUMBNAIL":"/lib/3.jpg","VIMEO_URL":"https://vimeo.com/567778868","YOUTUBE_URL":"https://www.youtube.com/watch?v=WijYEtoLjS8","EXPLANATION":"Begin by driving at the first set of cones. Once there, perform a shoulder feint followed by a Croqueta. After your move, quickly speed dribble through the end gate. Focus on really selling that fake with your upper body. Alternate between the left and right finish gate. Suggested reps: 3 rounds of 10 reps","REPS":3,"ROUNDS":10},{"LIB_ID":4,"VIDEO_TITLE":"Drive to Chop","THUMBNAIL":"/lib/4.jpg","VIMEO_URL":"https://vimeo.com/567779378","YOUTUBE_URL":"https://www.youtube.com/watch?v=GO3wVab2w4Q","EXPLANATION":"Begin by driving at the first cone. Once there, perform a Ronaldo Chop. After you","REPS":3,"ROUNDS":8},{"LIB_ID":5,"VIDEO_TITLE":"Drag Across","THUMBNAIL":"/lib/5.jpg","VIMEO_URL":"https://vimeo.com/565163726","YOUTUBE_URL":null,"EXPLANATION":null,"REPS":null,"ROUNDS":null},{"LIB_ID":6,"VIDEO_TITLE":"Main Match Analysis","THUMBNAIL":"/lib/6.jpg","VIMEO_URL":"https://vimeo.com/568571830","YOUTUBE_URL":null,"EXPLANATION":null,"REPS":null,"ROUNDS":null}]

class GetVideosByCategoryResponse {
  String _status;
  String _message;
  List<VideoData> _data;

  String get status => _status;
  String get message => _message;
  List<VideoData> get data => _data;

  GetVideosByCategoryResponse({
      String status, 
      String message, 
      List<VideoData> data}){
    _status = status;
    _message = message;
    _data = data;
}

  GetVideosByCategoryResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(VideoData.fromJson(v));
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

/// LIB_ID : 1
/// VIDEO_TITLE : "Single Scissors"
/// THUMBNAIL : "/lib/1.jpg"
/// VIMEO_URL : "https://vimeo.com/567780291"
/// YOUTUBE_URL : "https://www.youtube.com/watch?v=bbUzCsGGJ6w"
/// EXPLANATION : "Drive at the first set of cones. Perform a single scissor and quickly cut the ball back across your body. Finish in the final gate. This movement mimics sealing off your defender once you have beaten them. Reset each rep and use both right and left feet. Suggested reps: 3 rounds of 8."
/// REPS : 3
/// ROUNDS : 8

class VideoData {
  int _libid;
  String _videotitle;
  String _thumbnail;
  String _vimeourl;
  String _youtubeurl;
  String _explanation;
  int _reps;
  int _rounds;

  int get libid => _libid;
  String get videotitle => _videotitle;
  String get thumbnail => _thumbnail;
  String get vimeourl => _vimeourl;
  String get youtubeurl => _youtubeurl;
  String get explanation => _explanation;
  int get reps => _reps;
  int get rounds => _rounds;

  VideoData({
      int libid, 
      String videotitle, 
      String thumbnail, 
      String vimeourl, 
      String youtubeurl, 
      String explanation, 
      int reps, 
      int rounds}){
    _libid = libid;
    _videotitle = videotitle;
    _thumbnail = thumbnail;
    _vimeourl = vimeourl;
    _youtubeurl = youtubeurl;
    _explanation = explanation;
    _reps = reps;
    _rounds = rounds;
}

  VideoData.fromJson(dynamic json) {
    _libid = json["LIB_ID"];
    _videotitle = json["VIDEO_TITLE"];
    _thumbnail = json["THUMBNAIL"];
    _vimeourl = json["VIMEO_URL"];
    _youtubeurl = json["YOUTUBE_URL"];
    _explanation = json["EXPLANATION"];
    _reps = json["REPS"];
    _rounds = json["ROUNDS"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["LIB_ID"] = _libid;
    map["VIDEO_TITLE"] = _videotitle;
    map["THUMBNAIL"] = _thumbnail;
    map["VIMEO_URL"] = _vimeourl;
    map["YOUTUBE_URL"] = _youtubeurl;
    map["EXPLANATION"] = _explanation;
    map["REPS"] = _reps;
    map["ROUNDS"] = _rounds;
    return map;
  }

}