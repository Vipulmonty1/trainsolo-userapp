/// Status : "true"
/// Message : ""
/// Data : [{"USR_ID":3,"USERNAME":"RAKSHIT2","PIN":null,"PREFIX":"MR.","FIRST_NAME":"RAKSHIT","LAST_NAME":"SHAH","ROLE":"COACH","LEVEL":1,"REASON_FOR_JOINING":"TO LEARN SOCCER","EMAIL":"rakshitshah1994@gmail.com","MOBILE":"8140982099","CITY_ID":null,"STATE_ID":null,"COUNTRY_ID":null,"PROFILE_PIC_URL":"profiles/3.jpg","KICK_STARTER_ID":1,"STATUS":"Active","STATUS_REASON":null,"GENDER":"Male","BIRTH_YEAR":1994,"BIRTH_MONTH":11,"BIRTH_DAY":25,"POSITION_CODE":"GK","DESCRIPTION":"Goalkeeper","PERSONAL_STREAK":4,"GLOBAL_BEST_STREAK":5,"LEVEL_NO":1,"BAR_FOR_LEVEL":3,"REMAINING_LEVEL_UP_STR":"7 Sessions to Level 2"}]

class PersonalStatsResponse {
  String _status;
  String _message;
  List<USERData> _data;

  String get status => _status;
  String get message => _message;
  List<USERData> get data => _data;

  PersonalStatsResponse({String status, String message, List<USERData> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  PersonalStatsResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
    if (json["Data"] != null) {
      _data = [];
      json["Data"].forEach((v) {
        _data.add(USERData.fromJson(v));
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
/// USERNAME : "RAKSHIT2"
/// PIN : null
/// PREFIX : "MR."
/// FIRST_NAME : "RAKSHIT"
/// LAST_NAME : "SHAH"
/// ROLE : "COACH"
/// LEVEL : 1
/// REASON_FOR_JOINING : "TO LEARN SOCCER"
/// EMAIL : "rakshitshah1994@gmail.com"
/// MOBILE : "8140982099"
/// CITY_ID : null
/// STATE_ID : null
/// COUNTRY_ID : null
/// PROFILE_PIC_URL : "profiles/3.jpg"
/// KICK_STARTER_ID : 1
/// STATUS : "Active"
/// STATUS_REASON : null
/// GENDER : "Male"
/// BIRTH_YEAR : 1994
/// BIRTH_MONTH : 11
/// BIRTH_DAY : 25
/// POSITION_CODE : "GK"
/// DESCRIPTION : "Goalkeeper"
/// PERSONAL_STREAK : 4
/// GLOBAL_BEST_STREAK : 5
/// LEVEL_NO : 1
/// BAR_FOR_LEVEL : 3
/// REMAINING_LEVEL_UP_STR : "7 Sessions to Level 2"

class USERData {
  int _usrid;
  String _username;
  dynamic _pin;
  String _prefix;
  String _firstname;
  String _lastname;
  String _role;
  int _level;
  String _reasonforjoining;
  String _email;
  String _mobile;
  dynamic _cityid;
  dynamic _stateid;
  dynamic _countryid;
  String _profilepicurl;
  int _kickstarterid;
  String _status;
  dynamic _statusreason;
  String _gender;
  int _birthyear;
  int _birthmonth;
  int _birthday;
  String _positioncode;
  String _description;
  int _personalstreak;
  int _globalbeststreak;
  int _levelno;
  int _barforlevel;
  String _remaininglevelupstr;
  String _promocodeimage;

  int get usrid => _usrid;
  String get username => _username;
  dynamic get pin => _pin;
  String get prefix => _prefix;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get role => _role;
  int get level => _level;
  String get reasonforjoining => _reasonforjoining;
  String get email => _email;
  String get mobile => _mobile;
  dynamic get cityid => _cityid;
  dynamic get stateid => _stateid;
  dynamic get countryid => _countryid;
  String get profilepicurl => _profilepicurl;
  int get kickstarterid => _kickstarterid;
  String get status => _status;
  dynamic get statusreason => _statusreason;
  String get gender => _gender;
  int get birthyear => _birthyear;
  int get birthmonth => _birthmonth;
  int get birthday => _birthday;
  String get positioncode => _positioncode;
  String get description => _description;
  int get personalstreak => _personalstreak;
  int get globalbeststreak => _globalbeststreak;
  int get levelno => _levelno;
  int get barforlevel => _barforlevel;
  String get remaininglevelupstr => _remaininglevelupstr;
  String get promocodeimage => _promocodeimage;

  USERData(
      {int usrid,
      String username,
      dynamic pin,
      String prefix,
      String firstname,
      String lastname,
      String role,
      int level,
      String reasonforjoining,
      String email,
      String mobile,
      dynamic cityid,
      dynamic stateid,
      dynamic countryid,
      String profilepicurl,
      int kickstarterid,
      String status,
      dynamic statusreason,
      String gender,
      int birthyear,
      int birthmonth,
      int birthday,
      String positioncode,
      String description,
      int personalstreak,
      int globalbeststreak,
      int levelno,
      int barforlevel,
      String remaininglevelupstr,
      String promocodeimage}) {
    _usrid = usrid;
    _username = username;
    _pin = pin;
    _prefix = prefix;
    _firstname = firstname;
    _lastname = lastname;
    _role = role;
    _level = level;
    _reasonforjoining = reasonforjoining;
    _email = email;
    _mobile = mobile;
    _cityid = cityid;
    _stateid = stateid;
    _countryid = countryid;
    _profilepicurl = profilepicurl;
    _kickstarterid = kickstarterid;
    _status = status;
    _statusreason = statusreason;
    _gender = gender;
    _birthyear = birthyear;
    _birthmonth = birthmonth;
    _birthday = birthday;
    _positioncode = positioncode;
    _description = description;
    _personalstreak = personalstreak;
    _globalbeststreak = globalbeststreak;
    _levelno = levelno;
    _barforlevel = barforlevel;
    _remaininglevelupstr = remaininglevelupstr;
    _promocodeimage = promocodeimage;
  }

  USERData.fromJson(dynamic json) {
    _usrid = json["USR_ID"];
    _username = json["USERNAME"];
    _pin = json["PIN"];
    _prefix = json["PREFIX"];
    _firstname = json["FIRST_NAME"];
    _lastname = json["LAST_NAME"];
    _role = json["ROLE"];
    _level = json["LEVEL"];
    _reasonforjoining = json["REASON_FOR_JOINING"];
    _email = json["EMAIL"];
    _mobile = json["MOBILE"];
    _cityid = json["CITY_ID"];
    _stateid = json["STATE_ID"];
    _countryid = json["COUNTRY_ID"];
    _profilepicurl = json["PROFILE_PIC_URL"];
    _kickstarterid = json["KICK_STARTER_ID"];
    _status = json["STATUS"];
    _statusreason = json["STATUS_REASON"];
    _gender = json["GENDER"];
    _birthyear = json["BIRTH_YEAR"];
    _birthmonth = json["BIRTH_MONTH"];
    _birthday = json["BIRTH_DAY"];
    _positioncode = json["POSITION_CODE"].toString();
    _description = json["DESCRIPTION"];
    _personalstreak = json["PERSONAL_STREAK"];
    _globalbeststreak = json["GLOBAL_BEST_STREAK"];
    _levelno = json["LEVEL_NO"];
    _barforlevel = json["BAR_FOR_LEVEL"];
    _remaininglevelupstr = json["REMAINING_LEVEL_UP_STR"];
    _promocodeimage = json["PROMOCODE"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["USR_ID"] = _usrid;
    map["USERNAME"] = _username;
    map["PIN"] = _pin;
    map["PREFIX"] = _prefix;
    map["FIRST_NAME"] = _firstname;
    map["LAST_NAME"] = _lastname;
    map["ROLE"] = _role;
    map["LEVEL"] = _level;
    map["REASON_FOR_JOINING"] = _reasonforjoining;
    map["EMAIL"] = _email;
    map["MOBILE"] = _mobile;
    map["CITY_ID"] = _cityid;
    map["STATE_ID"] = _stateid;
    map["COUNTRY_ID"] = _countryid;
    map["PROFILE_PIC_URL"] = _profilepicurl;
    map["KICK_STARTER_ID"] = _kickstarterid;
    map["STATUS"] = _status;
    map["STATUS_REASON"] = _statusreason;
    map["GENDER"] = _gender;
    map["BIRTH_YEAR"] = _birthyear;
    map["BIRTH_MONTH"] = _birthmonth;
    map["BIRTH_DAY"] = _birthday;
    map["POSITION_CODE"] = _positioncode;
    map["DESCRIPTION"] = _description;
    map["PERSONAL_STREAK"] = _personalstreak;
    map["GLOBAL_BEST_STREAK"] = _globalbeststreak;
    map["LEVEL_NO"] = _levelno;
    map["BAR_FOR_LEVEL"] = _barforlevel;
    map["REMAINING_LEVEL_UP_STR"] = _remaininglevelupstr;
    map["PROMOCODE"] = _promocodeimage;
    return map;
  }
}
