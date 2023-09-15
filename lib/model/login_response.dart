/// Status : "true"
/// Message : "Login successful! Redirecting..."
/// Data : {"user":{"USERNAME":"unitjohn","PIN":null,"PREFIX":null,"FIRST_NAME":"unit","LAST_NAME":"john","ROLE":"COACH","LEVEL":2,"REASON_FOR_JOINING":"FIND IT HARD TO TRAIN ALONE","EMAIL":"unit@john.com","MOBILE":null,"CITY_ID":null,"STATE_ID":null,"COUNTRY_ID":null,"PROFILE_PIC_URL":null,"KICK_STARTER_ID":null,"STATUS_REASON":null,"STATUS":"Active","GENDER":"Male","BIRTH_YEAR":1997,"BIRTH_MONTH":6,
/// "BIRTH_DAY":26,
/// "USR_ID":1,
/// "POSITION_CODE":"GK/GK"},"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MjQ2ODkxMTB9.994iJHKu1satiks_pddiabXGbNqG45DDsmoZPIxQAbY"}

class LoginResponse {
  String _status;
  String _message;
  Data _data;

  String get status => _status;
  String get message => _message;
  Data get data => _data;

  LoginResponse({String status, String message, Data data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  LoginResponse.fromJson(dynamic json) {
    // print(
    //     "Type of data to json status in login: ${json["Status"].runtimeType}");
    _status = json["Status"];
    // print(
    //     "Type of data to json message in login: ${json["Message"].runtimeType}");
    _message = json["Message"];
    // print("TYPE OF JSON DATA login: ${json["Data"].runtimeType}");
    // print(
    //     "Type of data to json in login: ${Data.fromJson(json["Data"]).runtimeType}");
    _data = json["Data"] != null ? Data.fromJson(json["Data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Status"] = _status;
    map["Message"] = _message;
    print("Data: ${_data}");
    if (_data != null) {
      map["Data"] = _data.toJson();
    }
    return map;
  }
}

/// user : {"USERNAME":"unitjohn","PIN":null,"PREFIX":null,"FIRST_NAME":"unit","LAST_NAME":"john","ROLE":"COACH","LEVEL":2,"REASON_FOR_JOINING":"FIND IT HARD TO TRAIN ALONE","EMAIL":"unit@john.com","MOBILE":null,"CITY_ID":null,"STATE_ID":null,"COUNTRY_ID":null,"PROFILE_PIC_URL":null,"KICK_STARTER_ID":null,"STATUS_REASON":null,"STATUS":"Active","GENDER":"Male","BIRTH_YEAR":1997,"BIRTH_MONTH":6,
/// "BIRTH_DAY":26,
/// "USR_ID":2,
/// "POSITION_CODE":"GK/GK"}
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MjQ2ODkxMTB9.994iJHKu1satiks_pddiabXGbNqG45DDsmoZPIxQAbY"

class Data {
  User _user;
  String _token;

  User get user => _user;
  String get token => _token;

  Data({User user, String token}) {
    _user = user;
    _token = token;
  }

  Data.fromJson(dynamic json) {
    _user = json["user"] != null ? User.fromJson(json["user"]) : null;
    _token = json["token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_user != null) {
      map["user"] = _user.toJson();
    }
    map["token"] = _token;
    return map;
  }
}

/// USERNAME : "unitjohn"
/// PIN : null
/// PREFIX : null
/// FIRST_NAME : "unit"
/// LAST_NAME : "john"
/// ROLE : "COACH"
/// LEVEL : 2
/// REASON_FOR_JOINING : "FIND IT HARD TO TRAIN ALONE"
/// EMAIL : "unit@john.com"
/// MOBILE : null
/// CITY_ID : null
/// STATE_ID : null
/// COUNTRY_ID : null
/// PROFILE_PIC_URL : null
/// KICK_STARTER_ID : null
/// STATUS_REASON : null
/// STATUS : "Active"
/// GENDER : "Male"
/// BIRTH_YEAR : 1997
/// BIRTH_MONTH : 6
/// USR_ID : 26
/// POSITION_CODE : "GK/GK"

class User {
  String _username;
  dynamic _pin;
  dynamic _prefix;
  String _firstname;
  String _lastname;
  String _role;
  int _level;
  String _reasonforjoining;
  String _email;
  dynamic _mobile;
  dynamic _cityid;
  dynamic _stateid;
  dynamic _countryid;
  dynamic _profilepicurl;
  dynamic _kickstarterid;
  dynamic _statusreason;
  String _status;
  String _gender;
  int _birthyear;
  int _birthmonth;
  int _birthday;
  int _userId;
  String _positioncode;
  String _token;
  String _subscriptionid;
  String _teamproperty;

  String get username => _username;
  dynamic get pin => _pin;
  dynamic get prefix => _prefix;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get role => _role;
  int get level => _level;
  String get reasonforjoining => _reasonforjoining;
  String get email => _email;
  dynamic get mobile => _mobile;
  dynamic get cityid => _cityid;
  dynamic get stateid => _stateid;
  dynamic get countryid => _countryid;
  dynamic get profilepicurl => _profilepicurl;
  dynamic get kickstarterid => _kickstarterid;
  dynamic get statusreason => _statusreason;
  String get status => _status;
  String get gender => _gender;
  int get birthyear => _birthyear;
  int get birthmonth => _birthmonth;
  int get birthday => _birthday;
  int get userId => _userId;
  String get positioncode => _positioncode;
  String get token => _token;
  String get subscriptionid => _subscriptionid;
  String get teamproperty => _teamproperty;

  User(
      {String username,
      dynamic pin,
      dynamic prefix,
      String firstname,
      String lastname,
      String role,
      int level,
      String reasonforjoining,
      String email,
      dynamic mobile,
      dynamic cityid,
      dynamic stateid,
      dynamic countryid,
      dynamic profilepicurl,
      dynamic kickstarterid,
      dynamic statusreason,
      String status,
      String gender,
      int birthyear,
      int birthmonth,
      int birthday,
      int userId,
      String positioncode,
      String token,
      String subscriptionid,
      String teamproperty}) {
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
    _statusreason = statusreason;
    _status = status;
    _gender = gender;
    _birthyear = birthyear;
    _birthmonth = birthmonth;
    _birthday = birthday;
    _userId = userId;
    _positioncode = positioncode;
    _token = token;
    _subscriptionid = subscriptionid;
    _teamproperty = teamproperty;
  }

  User.fromJson(dynamic json) {
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
    _statusreason = json["STATUS_REASON"];
    _status = json["STATUS"];
    _gender = json["GENDER"];
    _birthyear = json["BIRTH_YEAR"];
    _birthmonth = json["BIRTH_MONTH"];
    _birthday = json["BIRTH_DAY"];
    _userId = json["USR_ID"];
    _positioncode = json["POSITION_CODE"];
    _token = json["TOKEN"];
    _subscriptionid = json["USER_SUBSCRIPTION_ID"];
    _teamproperty = json["TEAM_PROPERTY"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
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
    map["STATUS_REASON"] = _statusreason;
    map["STATUS"] = _status;
    map["GENDER"] = _gender;
    map["BIRTH_YEAR"] = _birthyear;
    map["BIRTH_MONTH"] = _birthmonth;
    map["BIRTH_DAY"] = _birthday;
    map["USR_ID"] = _userId;
    map["POSITION_CODE"] = _positioncode;
    map["TOKEN"] = _token;
    map["USER_SUBSCRIPTION_ID"] = _subscriptionid;
    map["TEAM_PROPERTY"] = _teamproperty;

    return map;
  }
}
