import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:trainsolo/model/common_success.dart';
import 'package:trainsolo/model/signup_response.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import '../api/api_service.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/singuponly_bloc.dart';
import 'Dashboard.dart';
import 'login_view.dart';
import 'package:toast/toast.dart';
import '../model/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class SignupAll extends StatefulWidget {
  SignupAllPage createState() => SignupAllPage();
}

class ReasonList {
  String reason;
  int index;

  ReasonList({this.reason, this.index});
}

class SignupAllPage extends State<SignupAll> {
  bool _isInAsyncCall = false;
  GlobalKey<PageContainerState> key = GlobalKey();
  bool _highschoolPressed = false;
  bool _collagePressed = false;
  bool _otherPressed = false;
  bool _playerPressed = false;
  bool _coachPressed = false;
  bool _malePressed = false;
  bool _femalePressed = false;

  bool _position1Pressed = false;
  bool _position2Pressed = false;
  bool _position3Pressed = false;
  bool _position4Pressed = false;
  bool _position5Pressed = false;
  bool _position6Pressed = false;
  bool _position7Pressed = false;
  bool _position8Pressed = false;
  bool _position9Pressed = false;
  bool _position10Pressed = false;
  String userPosition = "";

  final PageController _pageController = PageController();

  int id = 0;
  List<ReasonList> fList = [
    ReasonList(
      index: 1,
      reason: "I find it hard to train alone",
    ),
    ReasonList(
      index: 2,
      reason: "I want to play in college",
    ),
    ReasonList(
      index: 3,
      reason: "Pure improvement",
    ),
    ReasonList(
      index: 4,
      reason: "I can't afford a coach",
    ),
  ];

  bool navigateToPage = false;

  String level;
  String role;
  String gender;
  String resonforjoin;
  String teamProperty;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Sign Up Entered Email And Password");
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> rcvdData =
        ModalRoute.of(context).settings.arguments;
    final bloc = Provider.of<SignupOnlyBloc>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ModalProgressHUD(
          child: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: ExactAssetImage('assets/splash.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: PageIndicatorContainer(
              key: key,
              child: PageView(
                  controller: _pageController,
                  children: <Widget>[
                    // choose role coach or player
                    Container(
                      child: Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 90.0, bottom: 10.0),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                              child: Text(
                                'PLAYER OR COACH?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w400,
                                ),
                                /*style: GoogleFonts.poppins(
                                fontSize: 50,
                              ),*/
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ButtonTheme(
                                    minWidth: 120.0,
                                    height: 50.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _playerPressed
                                          ? Colors.white
                                          : Colors.transparent,
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
                                            "Player",
                                            style: TextStyle(
                                              color: _playerPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'HelveticaNeue',
                                            ),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        Amplitude.getInstance(
                                                instanceName: Constants
                                                    .AMPLITUDE_INSTANCE_NAME)
                                            .logEvent(
                                                "Sign Up Entered Player or Coach");
                                        setState(() {
                                          _playerPressed = !_playerPressed;

                                          if (_playerPressed) {
                                            _coachPressed = false;
                                          }
                                          role = "PLAYER";
                                        });

                                        if (_pageController.hasClients) {
                                          _pageController.animateToPage(
                                            1,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  ButtonTheme(
                                    minWidth: 120.0,
                                    height: 50.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _coachPressed
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: new Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Icon(
                                              TrainsoloIcons.coach,
                                              color: _coachPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Coach",
                                            style: TextStyle(
                                              color: _coachPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'HelveticaNeue',
                                            ),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        Amplitude.getInstance(
                                                instanceName: Constants
                                                    .AMPLITUDE_INSTANCE_NAME)
                                            .logEvent(
                                                "Sign Up Entered Player or Coach");
                                        setState(() {
                                          _coachPressed = !_coachPressed;

                                          if (_coachPressed) {
                                            _playerPressed = false;
                                          }
                                          role = "COACH";
                                        });

                                        if (_pageController.hasClients) {
                                          _pageController.animateToPage(
                                            1,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      )),
                    ),
                    // choose gender male or female
                    Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 90.0, bottom: 10.0),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                                child: Text(
                                  'SEX?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  /*style: GoogleFonts.poppins(
                                fontSize: 50,
                              ),*/
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                              child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ButtonTheme(
                                      minWidth: 120.0,
                                      height: 50.0,
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                        textColor: Colors.black,
                                        color: _malePressed
                                            ? Colors.white
                                            : Colors.transparent,
                                        child: new Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Icon(
                                                TrainsoloIcons.male,
                                                color: _malePressed
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Male",
                                              style: TextStyle(
                                                color: _malePressed
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 25,
                                                fontFamily: 'HelveticaNeue',
                                              ),
                                            )
                                          ],
                                        ),
                                        onPressed: () {
                                          Amplitude.getInstance(
                                                  instanceName: Constants
                                                      .AMPLITUDE_INSTANCE_NAME)
                                              .logEvent(
                                                  "Sign Up Entered Male or Female");
                                          setState(() {
                                            _malePressed = !_malePressed;

                                            if (_malePressed) {
                                              _femalePressed = false;
                                            }
                                            gender = "Male";
                                          });

                                          if (_pageController.hasClients) {
                                            _pageController.animateToPage(
                                              2,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    ButtonTheme(
                                      minWidth: 120.0,
                                      height: 50.0,
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                        textColor: Colors.black,
                                        color: _femalePressed
                                            ? Colors.white
                                            : Colors.transparent,
                                        child: new Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
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
                                                fontSize: 25,
                                                fontFamily: 'HelveticaNeue',
                                              ),
                                            )
                                          ],
                                        ),
                                        onPressed: () {
                                          Amplitude.getInstance(
                                                  instanceName: Constants
                                                      .AMPLITUDE_INSTANCE_NAME)
                                              .logEvent(
                                                  "Sign Up Entered Male or Female");
                                          setState(() {
                                            _femalePressed = !_femalePressed;

                                            if (_femalePressed) {
                                              _malePressed = false;
                                            }
                                            gender = "Female";
                                          });

                                          if (_pageController.hasClients) {
                                            _pageController.animateToPage(
                                              2,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // choose levels  highschool,collage,other
                    Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 90.0, bottom: 10.0),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                                child: Text(
                                  'WHAT LEVEL DO YOU PLAY?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
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
                                                padding:
                                                    const EdgeInsets.all(6.0),
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
                                            Amplitude.getInstance(
                                                    instanceName: Constants
                                                        .AMPLITUDE_INSTANCE_NAME)
                                                .logEvent(
                                                    "Sign Up Entered Level"),
                                            setState(() {
                                              _highschoolPressed =
                                                  !_highschoolPressed;

                                              if (_highschoolPressed) {
                                                _collagePressed = false;
                                                _otherPressed = false;
                                              }

                                              level = "1";
                                            }),
                                            if (_pageController.hasClients)
                                              {
                                                _pageController.animateToPage(
                                                  3,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.easeInOut,
                                                )
                                              }
                                          },
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
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
                                                padding:
                                                    const EdgeInsets.all(6.0),
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
                                            Amplitude.getInstance(
                                                    instanceName: Constants
                                                        .AMPLITUDE_INSTANCE_NAME)
                                                .logEvent(
                                                    "Sign Up Entered Level"),
                                            setState(() {
                                              _collagePressed =
                                                  !_collagePressed;

                                              if (_collagePressed) {
                                                _highschoolPressed = false;
                                                _otherPressed = false;
                                              }

                                              level = "2";
                                            }),
                                            if (_pageController.hasClients)
                                              {
                                                _pageController.animateToPage(
                                                  3,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.easeInOut,
                                                )
                                              }
                                          },
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ButtonTheme(
                                        minWidth: 110.0,
                                        height: 110.0,
                                        // ignore: deprecated_member_use
                                        child: RaisedButton(
                                          textColor: Colors.black,
                                          color: _otherPressed
                                              ? Colors.white
                                              : Colors.transparent,
                                          child: new Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
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
                                            Amplitude.getInstance(
                                                    instanceName: Constants
                                                        .AMPLITUDE_INSTANCE_NAME)
                                                .logEvent(
                                                    "Sign Up Entered Level"),
                                            setState(() {
                                              _otherPressed = !_otherPressed;

                                              if (_otherPressed) {
                                                _highschoolPressed = false;
                                                _collagePressed = false;
                                              }

                                              if (_pageController.hasClients) {
                                                _pageController.animateToPage(
                                                  3,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.easeInOut,
                                                );
                                              }

                                              level = "3";
                                            })
                                          },
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // choose reason  for join app
                    Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 90.0, bottom: 10.0),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                                child: Text(
                                  'REASON FOR JOINING?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                              child: Container(
                                height: 350.0,
                                child: Column(
                                  children: fList
                                      .map((data) => Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor:
                                                Color(0xFFFFFFFF),
                                          ),
                                          child: RadioListTile(
                                            title: Text("${data.reason}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19,
                                                  fontFamily: 'HelveticaNeue',
                                                )),
                                            groupValue: id,
                                            value: data.index,
                                            onChanged: (val) {
                                              Amplitude.getInstance(
                                                      instanceName: Constants
                                                          .AMPLITUDE_INSTANCE_NAME)
                                                  .logEvent(
                                                      "Sign Up Entered Reason For Joining");
                                              setState(() {
                                                id = data.index;
                                                navigateToPage = true;
                                              });

                                              if (navigateToPage) {
                                                resonforjoin = data.reason
                                                    .toUpperCase()
                                                    .toString();

                                                if (_pageController
                                                    .hasClients) {
                                                  _pageController.animateToPage(
                                                    4,
                                                    duration: const Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.easeInOut,
                                                  );
                                                }

                                                /*  print("rcvd fdata year ${rcvdData['year']}");
                                              print("rcvd fdata month ${rcvdData['month']}");
                                              print("rcvd fdata day${rcvdData['day']}");
                                              print('Email in signup: ${bloc.emailSignup}');
                                              print('Password: signup ${bloc.passwordSignup} ');
                                              print('name: signup ${bloc.firstnameSignup} ');
                                              print('last: signup ${bloc.lastnameSignup} ');
                                              print('reason: signup ${data.reason} ');
                                              print('level: signup ${level} ');
                                              print('conformpassword: signup ${bloc.confirmPasswordSignup} ');*/

                                                /*Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) {
                                                    return Dashboard();
                                                  }));*/
                                              }
                                            },
                                            activeColor: Color.fromARGB(
                                                255, 237, 28, 36),
                                            //unselectedWidgetColor: ??= isDark ? Colors.white70 : Colors.black54,
                                          )))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 90.0, bottom: 10.0),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                              child: Text(
                                'CLUB/TEAM?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w400,
                                ),
                                /*style: GoogleFonts.poppins(
                                fontSize: 50,
                              ),*/
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: new TextField(
                                onSubmitted: (String value) => {
                                  Amplitude.getInstance(
                                          instanceName:
                                              Constants.AMPLITUDE_INSTANCE_NAME)
                                      .logEvent("Sign Up Entered Club/Team"),
                                  print(
                                      "Club/Team text field was submitted w/ value: $value"),
                                  teamProperty = value,
                                  _pageController.animateToPage(
                                    5,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  ),
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: new InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'HelveticaNeue'),
                                  border: new OutlineInputBorder(),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  labelText: "Skip Below",
                                  hintText:
                                      'Enter Your Club/Team (If Applicable)',
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
                          SizedBox(height: 20),
                          Center(
                            child: MaterialButton(
                              // onPressed: () => print(
                              //     "Button was clicked, snapshot has data?: ${snapshot.hasData}"),
                              onPressed: () => {
                                Amplitude.getInstance(
                                        instanceName:
                                            Constants.AMPLITUDE_INSTANCE_NAME)
                                    .logEvent("Sign Up Skipped Club/Team"),
                                teamProperty = "",
                                _pageController.animateToPage(
                                  5,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                )
                              },
                              color: Color.fromARGB(255, 237, 28, 36),
                              textColor: Colors.white,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 24,
                              ),
                              // child: Text(
                              //   "Skip",
                              //   style:
                              //       TextStyle(color: Colors.white, fontSize: 24),
                              // ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Color.fromARGB(255, 237, 28, 36))),
                            ),
                          ),
                        ],
                      )),
                    ),
                    // choose position for signup button
                    Container(
                      child: SingleChildScrollView(
                        child: Center(
                            child: Column(children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 65.0, bottom: 0.0),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                'WHAT POSITION DO YOU PLAY?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset('assets/footballground.png',
                                        height: 500.0, width: 300.0),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: _gotosiginField(),
                                    ),
                                  ],
                                ),
                              )),

                              Positioned(
                                top: 100,
                                left: 140,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position1Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position1Pressed =
                                              !_position1Pressed;
                                          if (_position1Pressed) {
                                            _position2Pressed = false;
                                            _position3Pressed = false;
                                            _position4Pressed = false;
                                            _position5Pressed = false;
                                            _position6Pressed = false;
                                            _position7Pressed = false;
                                            _position8Pressed = false;
                                            _position9Pressed = false;
                                            _position10Pressed = false;
                                          }
                                          userPosition = "1";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB1
                              Positioned(
                                top: 200,
                                left: 10,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position2Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position2Pressed =
                                              !_position2Pressed;

                                          if (_position2Pressed) {
                                            _position1Pressed = false;
                                            _position3Pressed = false;
                                            _position4Pressed = false;
                                            _position5Pressed = false;
                                            _position6Pressed = false;
                                            _position7Pressed = false;
                                            _position8Pressed = false;
                                            _position9Pressed = false;
                                            _position10Pressed = false;
                                          }
                                        });
                                        userPosition = "3";
                                        var uuid = Uuid();
                                        signupApiCall(
                                            context,
                                            "",
                                            "",
                                            "",
                                            "0",
                                            "0",
                                            "0",
                                            bloc.emailSignup,
                                            bloc.passwordSignup,
                                            role,
                                            gender,
                                            level,
                                            resonforjoin,
                                            userPosition,
                                            uuid.v1(),
                                            teamProperty);
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB2
                              Positioned(
                                top: 200,
                                right: 10,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position3Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position3Pressed =
                                              !_position3Pressed;
                                          if (_position3Pressed) {
                                            _position1Pressed = false;
                                            _position2Pressed = false;
                                            _position4Pressed = false;
                                            _position5Pressed = false;
                                            _position6Pressed = false;
                                            _position7Pressed = false;
                                            _position8Pressed = false;
                                            _position9Pressed = false;
                                            _position10Pressed = false;
                                          }
                                          userPosition = "4";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB3
                              Positioned(
                                top: 175,
                                left: 140,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position4Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position4Pressed =
                                              !_position4Pressed;

                                          if (_position4Pressed) {
                                            _position1Pressed = false;
                                            _position2Pressed = false;
                                            _position3Pressed = false;
                                            _position5Pressed = false;
                                            _position6Pressed = false;
                                            _position7Pressed = false;
                                            _position8Pressed = false;
                                            _position9Pressed = false;
                                            _position10Pressed = false;
                                          }

                                          userPosition = "2";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB4
                              Positioned(
                                top: 290,
                                left: 140,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position5Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position5Pressed =
                                              !_position5Pressed;

                                          if (_position5Pressed) {
                                            _position1Pressed = false;
                                            _position2Pressed = false;
                                            _position3Pressed = false;
                                            _position4Pressed = false;
                                            _position6Pressed = false;
                                            _position7Pressed = false;
                                            _position8Pressed = false;
                                            _position9Pressed = false;
                                            _position10Pressed = false;
                                          }

                                          userPosition = "6";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB5
                              Positioned(
                                top: 325,
                                left: 50,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position6Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position6Pressed =
                                              !_position6Pressed;

                                          if (_position6Pressed) {
                                            _position1Pressed = false;
                                            _position2Pressed = false;
                                            _position3Pressed = false;
                                            _position4Pressed = false;
                                            _position5Pressed = false;
                                            _position7Pressed = false;
                                            _position8Pressed = false;
                                            _position9Pressed = false;
                                            _position10Pressed = false;
                                          }
                                          userPosition = "5";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB6
                              Positioned(
                                top: 325,
                                right: 50,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position7Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position7Pressed =
                                              !_position7Pressed;

                                          if (_position7Pressed) {
                                            _position1Pressed = false;
                                            _position2Pressed = false;
                                            _position3Pressed = false;
                                            _position4Pressed = false;
                                            _position5Pressed = false;
                                            _position6Pressed = false;
                                            _position8Pressed = false;
                                            _position9Pressed = false;
                                            _position10Pressed = false;
                                          }
                                          userPosition = "7";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB7
                              Positioned(
                                top: 375,
                                left: 90,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position8Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position8Pressed =
                                              !_position8Pressed;

                                          if (_position8Pressed) {
                                            _position1Pressed = false;
                                            _position2Pressed = false;
                                            _position3Pressed = false;
                                            _position4Pressed = false;
                                            _position5Pressed = false;
                                            _position6Pressed = false;
                                            _position7Pressed = false;
                                            _position9Pressed = false;
                                            _position10Pressed = false;
                                          }
                                          userPosition = "8";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB8
                              Positioned(
                                top: 375,
                                right: 90,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position9Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position9Pressed =
                                              !_position9Pressed;

                                          if (_position9Pressed) {
                                            _position1Pressed = false;
                                            _position2Pressed = false;
                                            _position3Pressed = false;
                                            _position4Pressed = false;
                                            _position5Pressed = false;
                                            _position6Pressed = false;
                                            _position7Pressed = false;
                                            _position8Pressed = false;
                                            _position10Pressed = false;
                                          }
                                          userPosition = "9";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB9
                              Positioned(
                                top: 425,
                                left: 140,
                                height: 43,
                                width: 43,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  _position10Pressed
                                                      ? "assets/t_shirt_red.png"
                                                      : "assets/t_shirt_blank.png",
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _position10Pressed =
                                              !_position10Pressed;

                                          if (_position10Pressed) {
                                            _position1Pressed = false;
                                            _position2Pressed = false;
                                            _position3Pressed = false;
                                            _position4Pressed = false;
                                            _position5Pressed = false;
                                            _position6Pressed = false;
                                            _position7Pressed = false;
                                            _position8Pressed = false;
                                            _position9Pressed = false;
                                          }
                                          userPosition = "10";
                                          var uuid = Uuid();
                                          signupApiCall(
                                              context,
                                              "",
                                              "",
                                              "",
                                              "0",
                                              "0",
                                              "0",
                                              bloc.emailSignup,
                                              bloc.passwordSignup,
                                              role,
                                              gender,
                                              level,
                                              resonforjoin,
                                              userPosition,
                                              uuid.v1(),
                                              teamProperty);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ), //PB10
                            ],
                          ),
                        ])),
                      ),
                    ),
                  ],
                  physics: new NeverScrollableScrollPhysics()),
              align: IndicatorAlign.bottom,
              length: 6,
              indicatorSpace: 30.0,
              indicatorColor: Colors.white,
              indicatorSelectorColor: Color.fromARGB(255, 237, 28, 36),
            ),
          ),
          inAsyncCall: _isInAsyncCall,
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(
            color: Color.fromARGB(255, 237, 28, 36),
          ),
        ),
      ),
    );
  }

  signupApiCall(
      BuildContext context,
      String usernameSignup,
      String firstnameSignup,
      String lastnameSignup,
      String year,
      String month,
      String day,
      String emailSignup,
      String passwordSignup,
      String role,
      String gender,
      String level,
      String reason,
      String userPosition,
      String uuid,
      String teamProperty) async {
    print("Email signup: $emailSignup");
    print("Password signup: $passwordSignup");
    print("First name: $firstnameSignup");
    print("Last name: $lastnameSignup");
    print("year: $year");
    print("month: $month");
    print("day: $day");
    print("Role: $role");
    print("Level: $level");
    print("reason: $reason");
    print("userPosition: $userPosition");
    print("uuid: $uuid");
    print("Team Property: $teamProperty");
    int splitIndex = emailSignup.indexOf("@");
    String username = "";
    if (splitIndex > 0) {
      username = emailSignup.substring(0, splitIndex);
    }
    print("Username: $username");
    SignupResponse registrationresponse = await preUserRegistration(
        username,
        firstnameSignup,
        lastnameSignup,
        year,
        month,
        day,
        emailSignup,
        passwordSignup,
        role,
        gender,
        level,
        reason,
        userPosition,
        uuid,
        teamProperty);
    setState(() {
      _isInAsyncCall = true;
    });
    if (registrationresponse.status == "true") {
      _isInAsyncCall = false;
      // print('not null' + registrationresponse.message);
      Toast.show("${registrationresponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      LoginResponse logindatd = await login(username, passwordSignup);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Constants.USER_DATA, jsonEncode(logindatd));
      if (logindatd != null &&
          logindatd.data != null &&
          logindatd.data.user != null &&
          logindatd.data.user.userId != null) {
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .setUserProperties(logindatd.data.user.toJson());
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .setUserId(logindatd.data.user.userId.toString());
      }
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("User Registered");
      print(
          "Subscription ID upon signup ... ${logindatd.data.user.subscriptionid}");
      if (logindatd.data.user.subscriptionid != null) {
        print("Conditional was met, about to call purchases.login ...");
        LogInResult _ =
            await Purchases.logIn(logindatd.data.user.subscriptionid);
        PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
        print("User Purchaser Info: ${purchaserInfo}");
      } else {
        print("Conditional was not met ...");
      }

      var isDeepLink = prefs.getString(Constants.IS_DEEP_LINK);
      var planid = prefs.getString(Constants.PLAN_ID);
      var userid = prefs.getString(Constants.SHARED_USER_ID);
      if (isDeepLink == "Yes") {
        updateSharingPlanApiCall(planid, userid);
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      _isInAsyncCall = false;
      //print('null'+registrationresponse.message);
      Toast.show("${registrationresponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<void> updateSharingPlanApiCall(String planid, String players) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      String userId = loginResponse.data.user.userId.toString();
      CommonSuccess response =
          await updateSharingPlan(players, "", planid, userId, "", "USER");
      if (response.status == "true") {}
    }
  }

  Widget _gotosiginField() {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: new TextSpan(
                  text: "I'M ALREADY A USER, ",
                  style: TextStyle(color: Colors.white),
                  children: [
                    new TextSpan(
                        text: "SIGN IN",
                        style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontWeight: FontWeight.bold),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            print('Tap Here onTap');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          })
                  ]),
            ),
          );
        });
  }
}
