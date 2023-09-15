/// Status : "true"
/// Message : ""
/// Data : [{"Title":"POSITION BASED TRAINING","Tagline":"Training sessions tailored to your game","Data":[{"LIB_CAT_ID":2,"GROUP_CATEGORY":"POSITION BASED TRAINING","CATEGORY_SUBLINE":null,"THUMBNAIL":null,"PARENT_LIB_CAT_ID":1,"GRP_BY":"Winger Session","CAT_ORD":"11"},{"LIB_CAT_ID":3,"GROUP_CATEGORY":"POSITION BASED TRAINING","CATEGORY_SUBLINE":null,"THUMBNAIL":null,"PARENT_LIB_CAT_ID":1,"GRP_BY":"Centre Midfielder","CAT_ORD":"21"}]},{"Title":"GAMES & CHALLENGES","Tagline":"Challenge yourself and improve your game","Data":[{"LIB_CAT_ID":5,"GROUP_CATEGORY":"GAMES & CHALLENGES","CATEGORY_SUBLINE":null,"THUMBNAIL":null,"PARENT_LIB_CAT_ID":2,"GRP_BY":"Kickups Revamped","CAT_ORD":"61"},{"LIB_CAT_ID":6,"GROUP_CATEGORY":"GAMES & CHALLENGES","CATEGORY_SUBLINE":null,"THUMBNAIL":null,"PARENT_LIB_CAT_ID":2,"GRP_BY":"Driven ball Golf","CAT_ORD":"71"}]}]

class LibraryResponse {
  String _status;
  String _message;
  List<MainLibrary> _data;

  String get status => _status;
  String get message => _message;
  List<MainLibrary> get data => _data;

  LibraryResponse({String status, String message, List<MainLibrary> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  LibraryResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(MainLibrary.fromJson(v));
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

/// Title : "POSITION BASED TRAINING"
/// Tagline : "Training sessions tailored to your game"
/// Data : [{"LIB_CAT_ID":2,"GROUP_CATEGORY":"POSITION BASED TRAINING","CATEGORY_SUBLINE":null,"THUMBNAIL":null,"PARENT_LIB_CAT_ID":1,"GRP_BY":"Winger Session","CAT_ORD":"11"},{"LIB_CAT_ID":3,"GROUP_CATEGORY":"POSITION BASED TRAINING","CATEGORY_SUBLINE":null,"THUMBNAIL":null,"PARENT_LIB_CAT_ID":1,"GRP_BY":"Centre Midfielder","CAT_ORD":"21"}]

class MainLibrary {
  String _title;
  String _tagline;

  List<SubLibrary> _data;

  String get title => _title;
  String get tagline => _tagline;

  List<SubLibrary> get data => _data;

  MainLibrary(
      {String title, String tagline, String category, List<SubLibrary> data}) {
    _title = title;
    _tagline = tagline;

    _data = data;
  }

  MainLibrary.fromJson(dynamic json) {
    _title = json["Title"];
    _tagline = json["Tagline"];

    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(SubLibrary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Title"] = _title;
    map["Tagline"] = _tagline;

    if (_data != null) {
      map["Data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// LIB_CAT_ID : 2
/// GROUP_CATEGORY : "POSITION BASED TRAINING"
/// CATEGORY_SUBLINE : null
/// THUMBNAIL : null
/// PARENT_LIB_CAT_ID : 1
/// GRP_BY : "Winger Session"
/// CAT_ORD : "11"
/// EXAPLANATION : null

class SubLibrary {
  int _libcatid;
  String _groupcategory;
  dynamic _categorysubline;
  String _thumbnail;
  int _parentlibcatid;
  String _grpby;
  int _catord;
  dynamic _exaplanation;
  String _matchanalysisid;
  String _category;

  int get libcatid => _libcatid;
  String get groupcategory => _groupcategory;
  dynamic get categorysubline => _categorysubline;
  String get thumbnail => _thumbnail;
  int get parentlibcatid => _parentlibcatid;
  String get grpby => _grpby;
  int get catord => _catord;
  String get matchanalysisid => _matchanalysisid;
  String get category => _category;
  dynamic get exaplanation => _exaplanation;

  SubLibrary(
      {int libcatid,
      String groupcategory,
      dynamic categorysubline,
      String thumbnail,
      int parentlibcatid,
      String grpby,
      int catord,
      dynamic exaplanation,
      String matchanalysisid,
      String category}) {
    _libcatid = libcatid;
    _groupcategory = groupcategory;
    _categorysubline = categorysubline;
    _thumbnail = thumbnail;
    _parentlibcatid = parentlibcatid;
    _grpby = grpby;
    _catord = catord;
    _exaplanation = exaplanation;
    _matchanalysisid = matchanalysisid;
    _category = _category;
  }

  SubLibrary.fromJson(dynamic json) {
    _libcatid = json["LIB_CAT_ID"];
    _groupcategory = json["GROUP_CATEGORY"];
    _categorysubline = json["CATEGORY_SUBLINE"];
    _thumbnail = json["THUMBNAIL"];
    _parentlibcatid = json["PARENT_LIB_CAT_ID"];
    _grpby = json["GRP_BY"];
    _catord = json["CAT_ORD"];
    _exaplanation = json["EXAPLANATION"];
    _matchanalysisid = json["MATCHANALYSISID"];
    _category = json["ISCATEGORY"].toString();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["LIB_CAT_ID"] = _libcatid;
    map["GROUP_CATEGORY"] = _groupcategory;
    map["CATEGORY_SUBLINE"] = _categorysubline;
    map["THUMBNAIL"] = _thumbnail;
    map["PARENT_LIB_CAT_ID"] = _parentlibcatid;
    map["GRP_BY"] = _grpby;
    map["CAT_ORD"] = _catord;
    map["EXAPLANATION"] = _exaplanation;
    map["MATCHANALYSISID"] = _matchanalysisid;
    map["ISCATEGORY"] = _category;
    return map;
  }
}
