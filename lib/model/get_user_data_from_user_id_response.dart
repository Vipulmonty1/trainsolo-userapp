class UserDataFromId {
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
  String _usersubscriptionid;
  String _teamproperty;

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
  String get usersubscriptionid => _usersubscriptionid;
  String get teamproperty => _teamproperty;

  UserDataFromId.fromJson(dynamic jsonWithArray) {
    dynamic json = jsonWithArray[0];
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
    _positioncode = json["POSITION_CODE"];
    _usersubscriptionid = json["USER_SUBSCRIPTION_ID"];
    _teamproperty = json["TEAM_PROPERTY"];
  }
}
