import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/main.dart';
import 'package:trainsolo/model/check_promocode_response.dart';
import 'package:trainsolo/model/comp_user_response.dart';
import 'package:trainsolo/model/insert_promocode_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/personal_stats_response.dart';
import 'package:trainsolo/model/shared_stats_response.dart';
import 'package:trainsolo/screens/EditProfile.dart';
import 'package:trainsolo/screens/PersonalStats.dart';
import 'package:trainsolo/screens/SharedStats.dart';
import 'package:trainsolo/utils/Constants.dart';

import 'package:trainsolo/screens/SubscriptionBlocker.dart';
import 'package:trainsolo/utils/RevenueCatUtilities.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class Profile extends StatefulWidget {
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile> with SingleTickerProviderStateMixin {
  // ignore: unused_field
  bool _isInAsyncCall = false;
  TabController _controller;
  List<USERData> personalstatsData = [];

  // ignore: non_constant_identifier_names
  USERData UserPersonalData;
  // ignore: non_constant_identifier_names
  SharedStatsData SharedStatsDataObject;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    getPersonalStatsApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, top: 8.0, bottom: 8.0, right: 0.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox.expand(
                            child: FittedBox(
                              child: CachedNetworkImage(
                                imageUrl: (UserPersonalData != null &&
                                        UserPersonalData.profilepicurl != null)
                                    ? Constants.IMAGE_BASE_URL +
                                        "/" +
                                        UserPersonalData.profilepicurl
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
                    SizedBox(
                      //Use of SizedBox
                      height: 2,
                    ),
                    Text(
                        UserPersonalData != null
                            ? UserPersonalData.username
                            : "",
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(
                      //Use of SizedBox
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 237, 28, 36),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 237, 28, 36),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Center(
                                child: Text(
                                  UserPersonalData != null
                                      ? UserPersonalData.positioncode
                                      : "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                (UserPersonalData != null &&
                                        UserPersonalData.description != null)
                                    ? UserPersonalData.description
                                    : '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ButtonTheme(
                        minWidth: 150.0,
                        height: 50.0,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                            textColor: Colors.black,
                            color: Colors.transparent,
                            child: new Column(
                              children: [
                                Text(
                                  "GET UNLIMITED ACCESS NOW",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'HelveticaNeue',
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () => buySubscriptionNow()),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      //Use of SizedBox
                      height: 2,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: ButtonTheme(
                                minWidth: 150.0,
                                height: 50.0,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                    textColor: Colors.black,
                                    color: Colors.transparent,
                                    child: new Column(
                                      children: [
                                        Text(
                                          "EDIT PROFILE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'HelveticaNeue',
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () => {
                                          testTeamsModule(),
                                          Amplitude.getInstance(
                                                  instanceName: Constants
                                                      .AMPLITUDE_INSTANCE_NAME)
                                              .logEvent(
                                                  "Profile Edit Profile Clicked"),
                                          _openDetailsPage(context)
                                        }),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  side: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Visibility(
                              visible: true,
                              child: ButtonTheme(
                                minWidth: 150.0,
                                height: 50.0,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.transparent,
                                  child: new Column(
                                    children: [
                                      Text(
                                        "LOGOUT",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'HelveticaNeue',
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () => {
                                    Amplitude.getInstance(
                                            instanceName: Constants
                                                .AMPLITUDE_INSTANCE_NAME)
                                        .logEvent("Profile Logout Clicked"),
                                    setState(() {
                                      clearPreferences();
                                    }),
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 237, 28, 36))),
                                ),
                              ),
                            )
                          ]),
                    ),
                    // Container(
                    //     child: TextField(
                    //   onSubmitted: (String value) async {
                    //     checkUserPromoCode(value);
                    //   },
                    //   obscureText: true,
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 14.0,
                    //       fontFamily: 'HelveticaNeue'),
                    //   keyboardType: TextInputType.emailAddress,
                    //   decoration: new InputDecoration(
                    //     fillColor: Colors.transparent,
                    //     filled: true,
                    //     labelStyle: TextStyle(
                    //         color: Colors.white, fontFamily: 'HelveticaNeue'),
                    //     border: new OutlineInputBorder(),
                    //     hintStyle: TextStyle(
                    //         fontSize: 14.0,
                    //         color: Colors.white,
                    //         fontFamily: 'HelveticaNeue'),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       borderSide:
                    //           BorderSide(color: Colors.white, width: 1.0),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       borderSide:
                    //           BorderSide(color: Colors.white, width: 1.0),
                    //     ),
                    //     labelText: 'Code',
                    //     hintText: 'Enter Code',
                    //   ),
                    // ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: new BoxDecoration(color: Colors.black),
                child: new TabBar(
                  controller: _controller,
                  labelStyle: TextStyle(fontSize: 25.0),
                  unselectedLabelStyle: TextStyle(fontSize: 20.0),
                  indicatorColor: Color.fromARGB(255, 237, 28, 36),
                  indicatorWeight: 5.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    new Tab(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Personal Stats",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    new Tab(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Player Reports",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Container(
                height: 550,
                color: Colors.black,
                width: double.infinity,
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    PersonalStats(userpersonaldata: UserPersonalData),
                    SharedStats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  testTeamsModule() async {
    CompTeamResponse epCompTeamResponse = await compUserTeam('3');
    print("Comp Teams Response: $epCompTeamResponse");
    print("Status of Response: ${epCompTeamResponse.status}");
  }

  buySubscriptionNow() async {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Profile Buy Now Clicked");
    bool userAlreadySubscribed = await checkNonFitnessAccess();
    if (userAlreadySubscribed) {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Profile Buy Now User Already Subscribed");
      print("User is already subscribed");
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text(
              "You're already subscribed! If you'd like to change your subscription option, please navigate to the settings app.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'BebasNeue',
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              /* CupertinoDialogAction(
                  child: Text('Long Text Button'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),*/
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print("User is not subscribed");
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return SubscriptionBlocker(() => print("No navigation necessary"));
          });
    }
  }

  _openDetailsPage(BuildContext context) => Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) =>
                  EditProfile(userpersonaldata: UserPersonalData)))
          .then((_) {
        // This method gets callback after your SecondScreen is popped from the stack or finished.
        function1();
      });
  Future<void> getPersonalStatsApiCall() async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    print("JSON Decoded user data on profile page: $jsonResponse");
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      String userId = loginResponse.data.user.userId.toString();
      String userName = loginResponse.data.user.username.toString();
      PersonalStatsResponse response = await getPersonalStats(userId, userName);
      if (response.status == "true") {
        print("Get stats was true ...");
        setState(() {
          _isInAsyncCall = false;
        });
        Toast.show("${response.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        personalstatsData = response.data;
        print("Personal stats data: $personalstatsData");
        UserPersonalData = personalstatsData[0];
        print("User Personal Data: $UserPersonalData");
        print("?level no: ${UserPersonalData.levelno}");

        // getFitnessLeaderBoardByFitnessId(loginResponse.data.user.userId.toString(),fitnessList[0].id);
      } else {
        print("Get stats was false ...");
        setState(() {
          _isInAsyncCall = false;
        });

        Toast.show("${response.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  checkUserPromoCode(String value) async {
    print("Text field submitted w/ value $value");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    print("JSON Decoded user data on profile page: $jsonResponse");
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    String userMessage = "Invalid Code";
    if (loginResponse.data != null) {
      String userId = loginResponse.data.user.userId.toString();
      print("About to check promocode ...");
      CheckPromoCodeResponse checkPromoCodeResponse =
          await checkPromocode(userId, value);
      print("Promo code response status: ${checkPromoCodeResponse.status}");
      if (checkPromoCodeResponse.status == "true") {
        CheckPromoCodeResponse userHasPromoCodeResponse =
            await checkUserPromocodeMapping(userId);
        if (userHasPromoCodeResponse.status == "true") {
          InsertPromoCodeResponse insertPromoCode =
              await insertUserPromoCodeMapping(userId, value);
          if (insertPromoCode.status) {
            userMessage = "Code successfully applied!";
          }
        } else {
          userMessage = "You already have a promocode!";
        }
      }
    }
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            userMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'BebasNeue',
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            /* CupertinoDialogAction(
                  child: Text('Long Text Button'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),*/
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> clearPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
        ModalRoute.withName("/"));
  }

  void function1() {
    setState(() {
      getPersonalStatsApiCall();
    });
  }
}
