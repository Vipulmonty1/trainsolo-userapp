import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/common_success.dart';
import 'package:trainsolo/model/get_all_position_response.dart';
import 'package:trainsolo/model/get_user_data_from_user_id_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/personal_stats_response.dart';
import 'package:trainsolo/model/upload_picture_response.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:trainsolo/bloc/signup_bloc.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class EditProfile extends StatefulWidget {
  final USERData userpersonaldata;
  final VoidCallback onButtonPressed;
  EditProfile({@required this.userpersonaldata, this.onButtonPressed});

  EditProfilePage createState() => EditProfilePage();
}

class EditProfilePage extends State<EditProfile> {
  bool _isInAsyncCall = false;
  File _image;
  ProgressDialog pr;
  bool _playerPressed = false;
  bool _coachPressed = false;
  bool _malePressed = false;
  bool _femalePressed = false;
  bool _highschoolPressed = false;
  bool _collagePressed = false;
  bool _otherPressed = false;
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController clubController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String level;
  String role;
  String gender;
  String positioncodeYo;
  String UploadedPicUrl;

  List<PositionData> positionDataList = [];
  List<String> positionStringList = [];

  String dropdownvalue;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
      upload(_image);
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
      upload(_image);
    });
  }

  getCurrentDate() {
    FocusScope.of(context).requestFocus(FocusNode());
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(
          2021,
          12,
        ),
        theme: DatePickerTheme(
            headerColor: Color.fromARGB(255, 237, 28, 36),
            backgroundColor: Colors.black,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        dayController = TextEditingController()..text = date.day.toString();
        monthController = TextEditingController()..text = date.month.toString();
        yearController = TextEditingController()..text = date.year.toString();
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  @override
  void initState() {
    super.initState();
    getPositionListApiCall();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setClubProperty();
    });
    firstnameController.text = widget.userpersonaldata.firstname;
    lastnameController.text = widget.userpersonaldata.lastname;
    dayController.text = widget.userpersonaldata.birthday.toString();
    monthController.text = widget.userpersonaldata.birthmonth.toString();
    yearController.text = widget.userpersonaldata.birthyear.toString();
    emailController.text = widget.userpersonaldata.email;
    // clubController.text = widget.userpersonaldata.team_property;
    level = widget.userpersonaldata.level.toString();
    role = widget.userpersonaldata.role.toString();
    gender = widget.userpersonaldata.gender.toString();
    dropdownvalue = widget.userpersonaldata.description.toString();

    if (widget.userpersonaldata.role.toUpperCase() == "PLAYER") {
      _playerPressed = true;
      _coachPressed = false;
    } else if (widget.userpersonaldata.role.toUpperCase() == "COACH") {
      _coachPressed = true;
      _playerPressed = false;
    }

    if (widget.userpersonaldata.gender == "Male") {
      _malePressed = true;
      _femalePressed = false;
    } else if (widget.userpersonaldata.gender == "Female") {
      _femalePressed = true;
      _malePressed = false;
    }

    if (widget.userpersonaldata.level == 1) {
      _highschoolPressed = true;
      _collagePressed = false;
      _otherPressed = false;
    } else if (widget.userpersonaldata.level == 2) {
      _highschoolPressed = false;
      _collagePressed = true;
      _otherPressed = false;
    } else if (widget.userpersonaldata.level == 3) {
      _highschoolPressed = false;
      _collagePressed = false;
      _otherPressed = true;
    }
  }

  void setClubProperty() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userdata = prefs.getString(Constants.USER_DATA);
    // final jsonResponse = json.decode(userdata);
    // print("JSON decoded login response: $jsonResponse");
    // LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    clubController.text = "Unregistered";
    print("Initial user id: ${widget.userpersonaldata.usrid}");
    if (widget.userpersonaldata.usrid != null) {
      UserDataFromId userDataFromId =
          await getUserDataFromId(widget.userpersonaldata.usrid.toString());
      print("Userdatafromid: $userDataFromId");
      print("Team property: ${userDataFromId.teamproperty}");
      if (userDataFromId != null && userDataFromId.teamproperty != null) {
        print("TEAM PROPERTY ?: ${userDataFromId.teamproperty}");
        clubController.text = userDataFromId.teamproperty;
      } else {
        print("conditionals were not met ... :(");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
    );
    return Scaffold(
      body: ModalProgressHUD(
        child: Stack(
          children: [
            _createForm(context),
          ],
        ),
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    final bloc = Provider.of<SignupBloc>(context, listen: false);
    // ignore: unused_local_variable
    FocusNode myFocusNode = new FocusNode();
    return SingleChildScrollView(
      child: new Container(
        padding: EdgeInsets.only(top: 50.0),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 28, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  child: Text(
                    'Edit profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'BebasNeue',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, top: 8.0, bottom: 8.0, right: 0.0),
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            _image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox.expand(
                            child: FittedBox(
                              child: CachedNetworkImage(
                                imageUrl: (widget.userpersonaldata != null &&
                                        widget.userpersonaldata.profilepicurl !=
                                            null)
                                    ? Constants.IMAGE_BASE_URL +
                                        "/" +
                                        widget.userpersonaldata.profilepicurl
                                    : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                                placeholder: (context, url) => Transform.scale(
                                  scale: 0.2,
                                  child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 237, 28, 36)),
                                ),
                                errorWidget: (context, url, error) =>
                                    Transform.scale(
                                  scale: 0.7,
                                  child: Icon(Icons.image, color: Colors.grey),
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            /* RaisedButton(
              child: Text("UPLOAD"),
              onPressed:(){

                upload(_image);

              },
            ),*/
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: new Row(
                children: <Widget>[
                  new Flexible(
                    flex: 1,
                    child: TextField(
                      controller: firstnameController,
                      style: TextStyle(color: Colors.white),
                      decoration: new InputDecoration(
                        labelStyle: TextStyle(
                            color: Colors.white, fontFamily: 'HelveticaNeue'),
                        labelText: "First Name",
                        hintText: 'Enter Your First name',
                        hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontFamily: 'HelveticaNeue'),
                        border: new OutlineInputBorder(),
                        fillColor: Colors.transparent,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  new Flexible(
                    flex: 1,
                    child: TextField(
                      controller: lastnameController,
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'HelveticaNeue'),
                      decoration: new InputDecoration(
                        labelStyle: TextStyle(
                            color: Colors.white, fontFamily: 'HelveticaNeue'),
                        border: new OutlineInputBorder(),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "Last Name",
                        hintText: 'Enter Your First name',
                        hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontFamily: 'HelveticaNeue'),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: new Row(
                children: <Widget>[
                  new Flexible(
                      flex: 1,
                      child: TextField(
                        focusNode: FocusNode(),
                        onTap: getCurrentDate,
                        controller: yearController,
                        style: TextStyle(color: Colors.white),
                        decoration: new InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.white, fontFamily: 'HelveticaNeue'),
                          border: new OutlineInputBorder(),
                          fillColor: Colors.transparent,
                          filled: true,
                          hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontFamily: 'HelveticaNeue'),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                      )),
                  SizedBox(width: 20),
                  new Flexible(
                    flex: 1,
                    child: _monthField(bloc),
                  ),
                  SizedBox(width: 20),
                  new Flexible(
                    flex: 1,
                    child: _dayField(bloc),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  labelStyle: TextStyle(
                      color: Colors.white, fontFamily: 'HelveticaNeue'),
                  border: new OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  filled: true,
                  labelText: "E-mail",
                  hintText: 'Enter Your Email',
                  hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeue'),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: clubController,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  labelStyle: TextStyle(
                      color: Colors.white, fontFamily: 'HelveticaNeue'),
                  border: new OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  filled: true,
                  labelText: "Club",
                  hintText: 'Enter Your Club',
                  hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontFamily: 'HelveticaNeue'),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 15.0, right: 15.0, top: 10, bottom: 10),
            //   //padding: EdgeInsets.symmetric(horizontal: 15),
            //   child: _passwordField(bloc),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                child: Text(
                  'PLAYER POSITION',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            ButtonTheme(
              minWidth: 500,
              height: 61.0,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  textColor: Colors.black,
                  color: Colors.transparent,
                  child: DropdownButton<String>(
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.black,
                    isExpanded: true,
                    value: dropdownvalue,
                    items: positionStringList.map((String values) {
                          return DropdownMenuItem<String>(
                            value: values,
                            child: new Text(values),
                          );
                        }).toList() ??
                        [],
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownvalue = newValue;
                      });
                    },
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.white)),
                  onPressed: () {},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                child: Text(
                  'PROFILE TYPE',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ButtonTheme(
                      minWidth: 120.0,
                      height: 61.0,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        textColor: Colors.black,
                        color:
                            _playerPressed ? Colors.white : Colors.transparent,
                        child: new Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                TrainsoloIcons.football,
                                color: _playerPressed
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              "PLAYER",
                              style: TextStyle(
                                color: _playerPressed
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 14,
                                fontFamily: 'HelveticaNeue',
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _playerPressed = !_playerPressed;

                            if (_playerPressed) {
                              _coachPressed = false;
                            }
                            role = "PLAYER";
                          });
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 20),
                    ButtonTheme(
                      minWidth: 120.0,
                      height: 61.0,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        textColor: Colors.black,
                        color:
                            _coachPressed ? Colors.white : Colors.transparent,
                        child: new Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                TrainsoloIcons.coach,
                                color:
                                    _coachPressed ? Colors.black : Colors.white,
                              ),
                            ),
                            Text(
                              "COACH",
                              style: TextStyle(
                                color:
                                    _coachPressed ? Colors.black : Colors.white,
                                fontSize: 14,
                                fontFamily: 'HelveticaNeue',
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _coachPressed = !_coachPressed;

                            if (_coachPressed) {
                              _playerPressed = false;
                            }
                            role = "COACH";
                          });
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white)),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                child: Text(
                  'SEX',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ButtonTheme(
                      minWidth: 120.0,
                      height: 61.0,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        textColor: Colors.black,
                        color: _malePressed ? Colors.white : Colors.transparent,
                        child: new Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                TrainsoloIcons.male,
                                color:
                                    _malePressed ? Colors.black : Colors.white,
                              ),
                            ),
                            Text(
                              "Male",
                              style: TextStyle(
                                color:
                                    _malePressed ? Colors.black : Colors.white,
                                fontSize: 16,
                                fontFamily: 'HelveticaNeue',
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _malePressed = !_malePressed;

                            if (_malePressed) {
                              _femalePressed = false;
                            }
                            gender = "Male";
                          });
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 20),
                    ButtonTheme(
                      minWidth: 120.0,
                      height: 61.0,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        textColor: Colors.black,
                        color:
                            _femalePressed ? Colors.white : Colors.transparent,
                        child: new Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                TrainsoloIcons.female,
                                color: _femalePressed
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              "Female",
                              style: TextStyle(
                                color: _femalePressed
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 16,
                                fontFamily: 'HelveticaNeue',
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _femalePressed = !_femalePressed;

                            if (_femalePressed) {
                              _malePressed = false;
                            }
                            gender = "Female";
                          });
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white)),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                child: Text(
                  'LEVEL',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ButtonTheme(
                        minWidth: 110.0,
                        height: 110.0,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: _highschoolPressed
                              ? Colors.white
                              : Colors.transparent,
                          child: new Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  TrainsoloIcons.highschool,
                                  size: 50,
                                  color: _highschoolPressed
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                "Highschool",
                                maxLines: 1,
                                style: TextStyle(
                                  color: _highschoolPressed
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              )
                            ],
                          ),
                          onPressed: () => {
                            setState(() {
                              _highschoolPressed = !_highschoolPressed;

                              if (_highschoolPressed) {
                                _collagePressed = false;
                                _otherPressed = false;
                              }

                              level = "1";
                            }),
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      flex: 1,
                      child: ButtonTheme(
                        minWidth: 110.0,
                        height: 110.0,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: _collagePressed
                              ? Colors.white
                              : Colors.transparent,
                          child: new Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  TrainsoloIcons.collage,
                                  size: 50,
                                  color: _collagePressed
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                "College",
                                maxLines: 1,
                                style: TextStyle(
                                  color: _collagePressed
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => {
                            setState(() {
                              _collagePressed = !_collagePressed;

                              if (_collagePressed) {
                                _highschoolPressed = false;
                                _otherPressed = false;
                              }

                              level = "2";
                            }),
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      flex: 1,
                      child: ButtonTheme(
                        minWidth: 110.0,
                        height: 110.0,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          textColor: Colors.black,
                          color:
                              _otherPressed ? Colors.white : Colors.transparent,
                          child: new Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  TrainsoloIcons.other,
                                  size: 50,
                                  color: _otherPressed
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                "Other",
                                maxLines: 1,
                                style: TextStyle(
                                  color: _otherPressed
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => {
                            setState(() {
                              _otherPressed = !_otherPressed;

                              if (_otherPressed) {
                                _highschoolPressed = false;
                                _collagePressed = false;
                              }
                              level = "3";
                            })
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.white)),
                        ),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: ButtonTheme(
                minWidth: 150.0,
                height: 50.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  textColor: Colors.black,
                  color: Color.fromARGB(255, 237, 28, 36),
                  child: new Column(
                    children: [
                      Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'HelveticaNeue',
                        ),
                      ),
                    ],
                  ),
                  /*  onPressed: widget.onButtonPressed,*/
                  onPressed: () => {
                    // if (firstnameController.text.isEmpty)
                    //   {
                    //     Toast.show('Enter first name', context,
                    //         duration: Toast.LENGTH_SHORT,
                    //         gravity: Toast.BOTTOM),
                    //   }
                    // else if (lastnameController.text.isEmpty)
                    //   {
                    //     Toast.show('Enter last name', context,
                    //         duration: Toast.LENGTH_SHORT,
                    //         gravity: Toast.BOTTOM),
                    //   }
                    // else if (yearController.text.isEmpty)
                    //   {
                    //     Toast.show('Select valid date', context,
                    //         duration: Toast.LENGTH_SHORT,
                    //         gravity: Toast.BOTTOM),
                    //   }
                    // else if (monthController.text.isEmpty)
                    //   {
                    //     Toast.show('Select valid date', context,
                    //         duration: Toast.LENGTH_SHORT,
                    //         gravity: Toast.BOTTOM),
                    //   }
                    // else if (dayController.text.isEmpty)
                    //   {
                    //     Toast.show('Select valid date', context,
                    //         duration: Toast.LENGTH_SHORT,
                    //         gravity: Toast.BOTTOM),
                    //   }
                    if (emailController.text.isEmpty)
                      {
                        Toast.show('Enter valid email', context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM),
                      }
                    else
                      {
                        Amplitude.getInstance(
                                instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                            .logEvent("Profile Edit Profile Updated"),
                        positionDataList.forEach((element) {
                          if (element.description == dropdownvalue) {
                            positioncodeYo = element.code;
                          }
                        }),
                        print("About to update user data ..."),
                        print(
                            "Club controller text: ${clubController.text.toString()}"),
                        updateUserDataApiCall(
                            firstnameController.text.toString(),
                            lastnameController.text.toString(),
                            yearController.text.toString(),
                            monthController.text.toString(),
                            dayController.text.toString(),
                            emailController.text.toString(),
                            widget.userpersonaldata.usrid.toString(),
                            widget.userpersonaldata.prefix,
                            widget.userpersonaldata.reasonforjoining,
                            role,
                            level,
                            gender,
                            widget.userpersonaldata.username,
                            widget.userpersonaldata.mobile.toString(),
                            UploadedPicUrl.toString(),
                            positioncodeYo,
                            clubController.text.toString()),
                      }

                    /* Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => TrainingOnGoing(drillItem: drillListFromPlan[0],drillList:drillListFromPlan)
                                            // builder: (context) => TrainingOnGoing()
                                          )),*/
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.red)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _yearField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.yearStream,
        builder: (context, snapshot) {
          return;
        });
  }

  Widget _monthField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.monthStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeMonth,
            focusNode: FocusNode(),
            style: TextStyle(color: Colors.white),
            onTap: getCurrentDate,
            controller: monthController,
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _dayField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.dayStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeDay,
            focusNode: FocusNode(),
            style: TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
            onTap: getCurrentDate,
            controller: dayController,
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _passwordField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordSignupStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changePassword,
            style: TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
            obscureText: true,
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              labelText: 'Password',
              hintText: 'Enter Your Password',
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  // ignore: unused_element
  Widget _bottomButtonField(SignupBloc bloc) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10, bottom: 10),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: StreamBuilder<bool>(
                stream: bloc.validarSignupFormStream,
                builder: (context, snapshot) {
                  return MaterialButton(
                    onPressed: snapshot.hasData ? () => _signup(bloc) : null,
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(side: BorderSide(color: Colors.red)),
                  );
                })),
      ],
    );
  }

  _signup(SignupBloc bloc) {
    if (bloc.submit()) {
      print('Email in signup: ${bloc.emailSignup}');
      print('Password: signup ${bloc.passwordSignup} ');
      print('name: signup ${bloc.firstnameSignup} ');
      print('last: signup ${bloc.lastnameSignup} ');
      print('year: signup ${yearController.text} ');
      print('month: signup ${monthController.text} ');
      print('day: signup ${dayController.text} ');
      print('conformpassword: signup ${bloc.confirmPasswordSignup} ');
      Navigator.pushReplacementNamed(context, "askQuestion", arguments: {
        "year": yearController.text,
        "month": monthController.text,
        "day": dayController.text
      });
    } else {
      print('day: signup ${dayController.text} ');
    }

    //

    /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Temp(value: yearController.text)));*/
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  updateUserDataApiCall(
      String firstname,
      String lastname,
      String year,
      String month,
      String day,
      String email,
      String userid,
      String prifix,
      String reason,
      String role,
      String level,
      String gender,
      String username,
      String mobile,
      String picurl,
      String positioncode,
      String teamproperty) async {
    CommonSuccess updateresponse = await updateUserData(
        firstname,
        lastname,
        year,
        month,
        day,
        email,
        userid,
        prifix,
        username,
        role,
        level,
        gender,
        reason,
        mobile,
        picurl,
        positioncode,
        teamproperty);
    setState(() {
      _isInAsyncCall = true;
    });
    if (updateresponse.status == "true") {
      _isInAsyncCall = false;

      Toast.show("${updateresponse.message}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pop(context);
      // widget.onButtonPressed();

    } else {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Profile Edit Profile Unable to update user data :(");
      Toast.show("${updateresponse.message}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pop(context);
    }
  }

  Future<void> getPositionListApiCall() async {
    GetAllPositionResponse getPosition = await getAllPositionList();
    if (getPosition.status == "true") {
      _isInAsyncCall = false;
      Toast.show("${getPosition.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      setState(() {
        positionDataList = getPosition.data;
      });

      positionDataList.forEach((element) {
        positionStringList.add(element.description);
      });
      if (widget.userpersonaldata.description == null)
        dropdownvalue = positionStringList[0].toString();
    } else {
      _isInAsyncCall = false;

      Toast.show("${getPosition.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  upload(File imageFile) async {
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    String url = "profilePics";
    var uri = Uri.parse(Constants.apiBaseURL + url);
    var uuid = Uuid();

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile(
        widget.userpersonaldata.usrid.toString(), stream, length,
        filename: uuid.v4());
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      UploadPictureResponse imageprofile =
          UploadPictureResponse.fromJson(jsonDecode(value));

      if (imageprofile.status == "true") {
        setState(() {
          _isInAsyncCall = false;
        });
        UploadedPicUrl = imageprofile.data;
        Toast.show("${imageprofile.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          _isInAsyncCall = false;
        });
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .logEvent(
                "Profile Edit Profile Unable to update user Image data :(");
        Toast.show("${imageprofile.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}

basename(String path) {
  File file = new File(path);
  String fileName = file.path.split('/').last;
  print(":::::::::::::::::FILE NAME:::::::::::::" + fileName);
  return fileName;
}

reen() {}
