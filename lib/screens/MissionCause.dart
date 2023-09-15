import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/mission_list_response.dart';
import 'package:trainsolo/model/get_users_response.dart';
import 'package:trainsolo/screens/MissionDetails.dart';
// ignore: unused_import
import 'package:trainsolo/screens/TrainingOnGoing.dart';
import 'package:trainsolo/utils/Constants.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class MissionCause extends StatefulWidget {
  final MissonListData missiondata;
  MissionCause({@required this.missiondata});
  /*final String title;
  MissionCause({@required this.title});*/
  MissionCausePage createState() => MissionCausePage();
}

class MissionCausePage extends State<MissionCause> {
  final searchController = TextEditingController();
  bool _isInAsyncCall = false;

  List<MissonListData> missionList = [];

  MissonListData missioninfo;

  void refresh() {
    setState(() {});
  }

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    getMissionList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, bottom: 0.0, top: 20.0),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "Pick your Social cause",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BebasNeue',
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: missionList.length,
                    // Number of widget to be created.
                    itemBuilder: (context, itemIndex) {
                      // ignore: unused_local_variable
                      return Container(
                        height: 340,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        width: double.infinity,
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 1.0, left: 1.0, right: 1.0),
                                  child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Image.network(
                                        missionList[itemIndex].logo != null
                                            ? missionList[itemIndex].logo
                                            : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                                        height: 75,
                                        width: 100,
                                      )),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: Text(
                                                        missionList[itemIndex]
                                                            .name,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'HelveticaNeue',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        )),
                                                  )),
                                              Expanded(
                                                  flex: 0,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 12.0),
                                                    child: GestureDetector(
                                                        onTap: /* _report,*/ () {},
                                                        child: Container(
                                                          width: 80,
                                                          height: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    237,
                                                                    28,
                                                                    36),
                                                            border: Border.all(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      237,
                                                                      28,
                                                                      36),
                                                            ),
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    5.0),
                                                          ),
                                                          child: Center(
                                                            child:
                                                                // ignore: deprecated_member_use
                                                                FlatButton(
                                                              child: Text(
                                                                  missionList[itemIndex]
                                                                              .missionstaus ==
                                                                          "Active"
                                                                      ? "Enrolled"
                                                                      : "Join Now",
                                                                  style:
                                                                      TextStyle(
                                                                    color: missionList[itemIndex].missionstaus ==
                                                                            "Active"
                                                                        ? Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)
                                                                        : Colors
                                                                            .white,
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        'HelveticaNeue',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  )),
                                                              onPressed: () {
                                                                Amplitude.getInstance(
                                                                        instanceName:
                                                                            Constants
                                                                                .AMPLITUDE_INSTANCE_NAME)
                                                                    .logEvent(
                                                                        "Mission Join Now/Enrolled Clicked",
                                                                        eventProperties: {
                                                                      "mission_name":
                                                                          missionList[itemIndex]
                                                                              .name,
                                                                      "mission_id":
                                                                          missionList[itemIndex]
                                                                              .missionid
                                                                    });
                                                                EnrolledForMission(
                                                                    missionList[
                                                                        itemIndex]);
                                                              },
                                                            ),
                                                          ),
                                                        )),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 18.0,
                                              top: 0.0,
                                              bottom: 10.0),
                                          child: Text(
                                              missionList[itemIndex].desc !=
                                                      null
                                                  ? missionList[itemIndex].desc
                                                  : "",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Text(
                                              missionList[itemIndex]
                                                          .sessiontocomplete !=
                                                      null
                                                  ? missionList[itemIndex]
                                                          .sessiontocomplete
                                                          .toString() +
                                                      " / " +
                                                      missionList[itemIndex]
                                                          .totalmissionsession
                                                          .toString() +
                                                      " Sessions Contributed - Community Objective"
                                                  : "",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ),
                                        SfSliderTheme(
                                          data: SfSliderThemeData(
                                            activeTrackHeight: 8.0,
                                            inactiveTrackHeight: 8.0,
                                            trackCornerRadius: 5,
                                            overlayColor: Colors.transparent,
                                            activeDividerRadius: 100,
                                            thumbColor: Colors.transparent,
                                            activeTrackColor:
                                                Color.fromARGB(255, 255, 0, 0),
                                            inactiveTrackColor: Colors.white,
                                          ),
                                          child: SfSlider(
                                            min: 0,
                                            max: missionList[itemIndex]
                                                .totalmissionsession,
                                            value: missionList[itemIndex]
                                                .sessiontocomplete,
                                            onChanged: (dynamic newValue) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                              missionList[itemIndex]
                                                          .contributors !=
                                                      0
                                                  ? missionList[itemIndex]
                                                          .contributors
                                                          .toString() +
                                                      " contributors"
                                                  : "",
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 20.0, top: 10.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      // print(
                                                      //     "Mission details button was clicked");
                                                      // TODO: Uncomment once this is working on TestFlight/the Play Store
                                                      Amplitude.getInstance(
                                                              instanceName:
                                                                  Constants
                                                                      .AMPLITUDE_INSTANCE_NAME)
                                                          .logEvent(
                                                              "Mission Details Clicked",
                                                              eventProperties: {
                                                            "mission_name":
                                                                missionList[
                                                                        itemIndex]
                                                                    .name,
                                                            "mission_id":
                                                                missionList[
                                                                        itemIndex]
                                                                    .missionid
                                                          });
                                                      _details(
                                                          context,
                                                          missionList[
                                                              itemIndex]);
                                                      print(
                                                          "Eventually, we'll go to details ...");
                                                    },
                                                    child: Container(
                                                      width: 80,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 237, 28, 36),
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255, 237, 28, 36),
                                                        ),
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: Center(
                                                        child: Text("Details",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'HelveticaNeue',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )),
                                                      ),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Amplitude.getInstance(
                                                              instanceName:
                                                                  Constants
                                                                      .AMPLITUDE_INSTANCE_NAME)
                                                          .logEvent(
                                                              "Mission Personal Clicked",
                                                              eventProperties: {
                                                            "mission_name":
                                                                missionList[
                                                                        itemIndex]
                                                                    .name,
                                                            "mission_id":
                                                                missionList[
                                                                        itemIndex]
                                                                    .missionid
                                                          });
                                                      _personaldetails(
                                                          context,
                                                          missionList[
                                                              itemIndex]);
                                                    },
                                                    child: Container(
                                                      width: 80,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 237, 28, 36),
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255, 237, 28, 36),
                                                        ),
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: Center(
                                                        child: Text("Personal",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'HelveticaNeue',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )),
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),

                              /*Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, top: 0.0, bottom: .0, right: 0.0),
                                            child:  Container(
                                              margin: const EdgeInsets.only(left: 20.0, right: 20.0,bottom: 10.0),
                                              child: Image.asset('assets/graphimage.png'), ),
                                          ),*/
                            ]),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getMissionList() async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      String userId = loginResponse.data.user.userId.toString();
      String userName = loginResponse.data.user.username.toString();
      MissionListResponse response = await getMissionLists(userId, userName);
      if (response.status == "true") {
        setState(() {
          _isInAsyncCall = false;
        });
        Toast.show("${response.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        missionList = response.data;
      } else {
        if (mounted) {
          setState(() {
            _isInAsyncCall = false;
          });

          Toast.show("${response.message}", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      }
    }
  }

  onChanged(BuildContext context, UsersData item) {
    print("this is on tap onChanged and index is " + item.username);
  }

  // ignore: non_constant_identifier_names
  Future<void> EnrolledForMission(MissonListData item) async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      String userId = loginResponse.data.user.userId.toString();
      String userName = loginResponse.data.user.username.toString();
      String missionid = item.missionid.toString();

      MissionListResponse response =
          await enrolledForMissionAPI(userId, userName, missionid);
      if (response.status == "true") {
        setState(() {
          _isInAsyncCall = false;
        });
        Toast.show("${response.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          _isInAsyncCall = false;
        });

        Toast.show("${response.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  _details(BuildContext context, MissonListData item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MissionDetails(
                  missioninfo: item,
                  tabIndex: 0,
                )));
  }

  _personaldetails(BuildContext context, MissonListData item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MissionDetails(missioninfo: item, tabIndex: 1)));
  }
}
