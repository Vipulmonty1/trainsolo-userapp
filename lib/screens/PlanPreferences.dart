import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/ItemModel.dart';
import 'package:trainsolo/model/block_with_subscription.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/user_subscription_status_response.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/utils/RevenueCatUtilities.dart';
import 'Dashboard.dart';
import 'SubscriptionBlocker.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:trainsolo/model/single_app_param_response.dart';
import 'package:get_version/get_version.dart';
import 'package:flutter/services.dart';

class PlanPreferences extends StatefulWidget {
  final VoidCallback onBuildOwnPlanPress;
  final VoidCallback genratePlanPressed;

  PlanPreferences(
      {@required this.onBuildOwnPlanPress, this.genratePlanPressed});

  PlanPreferencesPage createState() => PlanPreferencesPage();
}

class PlanPreferencesPage extends State<PlanPreferences>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  String participants = "1";
  String categoryapi;
  String noOfDrillstime = "1200";
  String skillLevel = "Advanced";
  double noOfDrills = 4.0;
  bool _isInAsyncCall = false;
  bool _onePersonPressed = true;
  bool _twoPersonPressed = false;
  bool _dribblingPressed = true;
  bool _passingPressed = false;
  bool _shootingPressed = false;
  bool _wall_workPressed = false;
  bool _jugglingPressed = false;
  bool _ballmasteryPressed = false;
  bool _20minPressed = true;
  bool _45minPressed = false;
  bool _1hrPlushPressed = false;
  bool _BeginnerPressed = false;
  bool _IntermediatePressed = false;
  bool _AdvancedPressed = true;
  bool _buildOwnPlanPressed = false;
  bool _generatePlanPressed = false;
  double _value = 4.0;
  String userId;
  String userName;

  final List<ItemModel> _subscriptionItems = [
    ItemModel(1, 'assets/listimage.png', "\$ 79.99/ Year",
        '\$ 6.65/month billed annually', true),
    ItemModel(
        2, 'assets/listimage.png', '\$ 9.99 / Month', 'Billed Monthly', true),
  ];

  @override
  bool get wantKeepAlive => true;

  // TODO: Factor out

  List<String> category = [];
  String objectives;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("App lifecycle state changed ...");
  }

  @override
  initState() {
    print("State initialized ...");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateApp();
  }

  // TODOs: make it dependent on which OS you're on
  // Make the alert undismissable so that you're forced to update
  // Create an app param for min version, and make sure the check works correctly
  _showDialog() async {
    String platformURL = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.trainsolo"
        : "https://apps.apple.com/us/app/trainsolo-soccer/id1582909254";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Update Required"),
        content: new Text("Please download the latest version of Trainsolo!"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Update"),
            onPressed: () => {launch(platformURL)},
          )
        ],
      ),
    );
  }

  void updateApp() async {
    print("Update button was clicked");
    String projectVersion;
// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = '';
    }
    // On iOS, version is 1.0.7
    // Platform messages may fail, so we use a try/catch PlatformException.
    // print("Project version: $projectVersion");
    String minAppVersion = await getMinVersionAppParam(Platform.isAndroid);
    // print(
    //     "Check min app version: ${checkMinAppVersion(projectVersion, minAppVersion)}");
    // TODO: Debug, something is going wrong
    if (checkMinAppVersion(projectVersion, minAppVersion)) {
      Future(_showDialog);
    }
  }

  bool checkMinAppVersion(String version, String minAppVersion) {
    // version = "2.0.0";
    print("Current app version: $version");
    if (minAppVersion.isEmpty || version.isEmpty) {
      return false;
    }
    List<int> versionVals = version.split('.').map(int.parse).toList();
    List<int> minVersionVals = minAppVersion.split('.').map(int.parse).toList();
    if (versionVals.length != 3 || minVersionVals.length != 3) {
      return false;
    }
    for (int i = 0; i <= 2; i++) {
      if (versionVals[i] > minVersionVals[i]) {
        return false;
      } else if (versionVals[i] < minVersionVals[i]) {
        return true;
      }
    }
    return false;
  }

  Future<String> getMinVersionAppParam(bool isAndroid) async {
    String returnVal = "";
    String paramKey = "IOS_MIN_APP_VERSION";
    if (isAndroid) {
      paramKey = "ANDROID_MIN_APP_VERSION";
    }
    // Logic ... maybe set default return value as empty, and then check if string is not empty
    SingleAppParamResponse adResponse = await getSingleAppParam(paramKey);
    if (adResponse != null && adResponse.data[0]['PAR_VALUE'] != null) {
      print("Param val: ${adResponse.data[0]['PAR_VALUE']}");
      returnVal = adResponse.data[0]['PAR_VALUE'];
    }
    return returnVal;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Container(
                    height: 50.0,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ButtonTheme(
                              minWidth: 160.0,
                              height: 40.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                textColor: Colors.black,
                                color: _onePersonPressed
                                    ? Colors.white
                                    : Colors.transparent,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        TrainsoloIcons.player1,
                                        color: _onePersonPressed
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "1 PLAYER",
                                      style: TextStyle(
                                        color: _onePersonPressed
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
                                    _onePersonPressed = !_onePersonPressed;
                                    participants = "1";

                                    if (_onePersonPressed) {
                                      _twoPersonPressed = false;
                                    }
                                  });
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.white)),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ButtonTheme(
                              minWidth: 160.0,
                              height: 40.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                textColor: Colors.black,
                                color: _twoPersonPressed
                                    ? Colors.white
                                    : Colors.transparent,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        TrainsoloIcons.group_248,
                                        color: _twoPersonPressed
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "2 PLAYERS",
                                      style: TextStyle(
                                        color: _twoPersonPressed
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
                                    _twoPersonPressed = !_twoPersonPressed;
                                    participants = "2";
                                    if (_twoPersonPressed) {
                                      _onePersonPressed = false;
                                    }
                                  });
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.white)),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    height: 210.0,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 0.0, bottom: 10.0),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              'Session Objectives',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'HelveticaNeue',
                                // fontWeight: FontWeight.w800,
                              ),
                              /*style: GoogleFonts.poppins(
                                          fontSize: 50,
                                        ),*/
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ButtonTheme(
                                    minWidth: 90.0,
                                    height: 80.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _dribblingPressed
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: new Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.5),
                                            child: Icon(
                                              TrainsoloIcons.dribbling,
                                              size: 40,
                                              color: _dribblingPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Dribbling",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: _dribblingPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'HelveticaNeue',
                                            ),
                                          )
                                        ],
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          _dribblingPressed =
                                              !_dribblingPressed;
                                        }),
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ButtonTheme(
                                    minWidth: 90.0,
                                    height: 80.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _passingPressed
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: new Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.5),
                                            child: Icon(
                                              TrainsoloIcons.passing,
                                              size: 40,
                                              color: _passingPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Passing",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: _passingPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'HelveticaNeue',
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          _passingPressed = !_passingPressed;
                                        }),
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ButtonTheme(
                                    minWidth: 90.0,
                                    height: 80.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _shootingPressed
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: new Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.5),
                                            child: Icon(
                                              TrainsoloIcons.shooting,
                                              size: 40,
                                              color: _shootingPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Shooting",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: _shootingPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'HelveticaNeue',
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          _shootingPressed = !_shootingPressed;
                                        })
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ButtonTheme(
                                      minWidth: 90.0,
                                      height: 80.0,
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                        textColor: Colors.black,
                                        color: _wall_workPressed
                                            ? Colors.white
                                            : Colors.transparent,
                                        child: new Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2.5, 2.5, 2.5),
                                              child: Row(children: [
                                                Icon(
                                                  TrainsoloIcons.wall_walk,
                                                  size: 40,
                                                  color: _wall_workPressed
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Container(
                                                  width: 6,
                                                  height: 40,
                                                  color: Colors.white,
                                                )
                                              ]),
                                            ),
                                            Text(
                                              "Wall Work",
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: _wall_workPressed
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'HelveticaNeue',
                                              ),
                                            )
                                          ],
                                        ),
                                        onPressed: () => {
                                          setState(() {
                                            _wall_workPressed =
                                                !_wall_workPressed;
                                          }),
                                        },
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ButtonTheme(
                                      minWidth: 90.0,
                                      height: 80.0,
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                        textColor: Colors.black,
                                        color: _jugglingPressed
                                            ? Colors.white
                                            : Colors.transparent,
                                        child: new Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.5),
                                              child: Icon(
                                                TrainsoloIcons.juggling,
                                                size: 40,
                                                color: _jugglingPressed
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Juggling",
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: _jugglingPressed
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'HelveticaNeue',
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () => {
                                          setState(() {
                                            _jugglingPressed =
                                                !_jugglingPressed;
                                          }),
                                        },
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ButtonTheme(
                                      minWidth: 90.0,
                                      height: 80.0,
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                        textColor: Colors.black,
                                        color: _ballmasteryPressed
                                            ? Colors.white
                                            : Colors.transparent,
                                        child: Center(
                                          child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 5.0, 0, 0),
                                                child: Center(
                                                  child: Icon(
                                                    TrainsoloIcons.ball_mastery,
                                                    size: 40,
                                                    color: _ballmasteryPressed
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Center(
                                                  child: Text(
                                                    "Ball Work",
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: _ballmasteryPressed
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'HelveticaNeue',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () => {
                                          setState(() {
                                            _ballmasteryPressed =
                                                !_ballmasteryPressed;
                                          })
                                        },
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 75.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              'Skill Level',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'HelveticaNeue',
                                // fontWeight: FontWeight.w800,
                              ),
                              /*style: GoogleFonts.poppins(
                                          fontSize: 50,
                                        ),*/
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ButtonTheme(
                                    height: 40.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _BeginnerPressed
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: new Column(
                                        children: [
                                          Text(
                                            "Beginner",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: _BeginnerPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'HelveticaNeue',
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          _BeginnerPressed = !_BeginnerPressed;
                                          skillLevel = "Beginner";
                                          if (_BeginnerPressed) {
                                            _IntermediatePressed = false;
                                            _AdvancedPressed = false;
                                          }
                                        }),
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ButtonTheme(
                                    height: 40.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _IntermediatePressed
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: new Column(
                                        children: [
                                          Text(
                                            "Medium",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: _IntermediatePressed
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'HelveticaNeue',
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          _IntermediatePressed =
                                              !_IntermediatePressed;
                                          skillLevel = "Intermediate";
                                          if (_IntermediatePressed) {
                                            _BeginnerPressed = false;
                                            _AdvancedPressed = false;
                                          }
                                        }),
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ButtonTheme(
                                    height: 40.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _AdvancedPressed
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: new Column(
                                        children: [
                                          Text(
                                            "Advanced",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: _AdvancedPressed
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'HelveticaNeue',
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          _AdvancedPressed = !_AdvancedPressed;
                                          skillLevel = "Advanced";
                                          if (_AdvancedPressed) {
                                            _BeginnerPressed = false;
                                            _IntermediatePressed = false;
                                          }
                                        })
                                      },
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   height: 75.0,
                  //   // margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  //   child: Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                  //         child: Container(
                  //           margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //           child: Text(
                  //             'Workout Duration',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 14,
                  //               fontFamily: 'HelveticaNeue',
                  //               // fontWeight: FontWeight.w800,
                  //             ),
                  //             /*style: GoogleFonts.poppins(
                  //                         fontSize: 50,
                  //                       ),*/
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  //         child: new Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Expanded(
                  //                 child: ButtonTheme(
                  //                   // minWidth: 110.0,
                  //                   height: 40.0,
                  //                   // ignore: deprecated_member_use
                  //                   child: RaisedButton(
                  //                     textColor: Colors.black,
                  //                     color: _20minPressed
                  //                         ? Colors.white
                  //                         : Colors.transparent,
                  //                     child: new Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.center,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [
                  //                         Text(
                  //                           "20 min",
                  //                           style: TextStyle(
                  //                             color: _20minPressed
                  //                                 ? Colors.black
                  //                                 : Colors.white,
                  //                             fontSize: 14,
                  //                             fontFamily: 'HelveticaNeue',
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     onPressed: () => {
                  //                       setState(() {
                  //                         _20minPressed = !_20minPressed;
                  //                         noOfDrillstime = "1200";
                  //                         _value = 4;
                  //                         noOfDrills = 4;
                  //                         if (_20minPressed) {
                  //                           _45minPressed = false;
                  //                           _1hrPlushPressed = false;
                  //                         }
                  //                       }),
                  //                     },
                  //                     shape: new RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             new BorderRadius.circular(8.0),
                  //                         side:
                  //                             BorderSide(color: Colors.white)),
                  //                   ),
                  //                 ),
                  //               ),
                  //               SizedBox(width: 10),
                  //               Expanded(
                  //                 child: ButtonTheme(
                  //                   // minWidth: 110.0,
                  //                   height: 40.0,
                  //                   // ignore: deprecated_member_use
                  //                   child: RaisedButton(
                  //                     textColor: Colors.black,
                  //                     color: _45minPressed
                  //                         ? Colors.white
                  //                         : Colors.transparent,
                  //                     child: new Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.center,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [
                  //                         Text(
                  //                           "45 min",
                  //                           style: TextStyle(
                  //                             color: _45minPressed
                  //                                 ? Colors.black
                  //                                 : Colors.white,
                  //                             fontSize: 14,
                  //                             fontFamily: 'HelveticaNeue',
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     onPressed: () => {
                  //                       setState(() {
                  //                         _45minPressed = !_45minPressed;
                  //                         _value = 7;
                  //                         noOfDrills = 7;
                  //                         noOfDrillstime = "2700";
                  //                         if (_45minPressed) {
                  //                           _20minPressed = false;
                  //                           _1hrPlushPressed = false;
                  //                         }
                  //                       }),
                  //                     },
                  //                     shape: new RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             new BorderRadius.circular(8.0),
                  //                         side:
                  //                             BorderSide(color: Colors.white)),
                  //                   ),
                  //                 ),
                  //               ),
                  //               SizedBox(width: 10),
                  //               Expanded(
                  //                 child: ButtonTheme(
                  //                   // minWidth: 110.0,
                  //                   height: 40.0,
                  //                   // ignore: deprecated_member_use
                  //                   child: RaisedButton(
                  //                     textColor: Colors.black,
                  //                     color: _1hrPlushPressed
                  //                         ? Colors.white
                  //                         : Colors.transparent,
                  //                     child: new Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.center,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [
                  //                         Text(
                  //                           "1hr +",
                  //                           style: TextStyle(
                  //                             color: _1hrPlushPressed
                  //                                 ? Colors.black
                  //                                 : Colors.white,
                  //                             fontSize: 14,
                  //                             fontFamily: 'HelveticaNeue',
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     onPressed: () => {
                  //                       setState(() {
                  //                         _1hrPlushPressed = !_1hrPlushPressed;
                  //                         _value = 10;
                  //                         noOfDrills = 10;
                  //                         noOfDrillstime = "3600";
                  //                         if (_1hrPlushPressed) {
                  //                           _20minPressed = false;
                  //                           _45minPressed = false;
                  //                         }
                  //                       })
                  //                     },
                  //                     shape: new RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             new BorderRadius.circular(8.0),
                  //                         side:
                  //                             BorderSide(color: Colors.white)),
                  //                   ),
                  //                 ),
                  //               )
                  //             ]),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    height: 125.0,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        //   child: new Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Expanded(
                        //           child: ButtonTheme(
                        //             minWidth: 110.0,
                        //             height: 40.0,
                        //             // ignore: deprecated_member_use
                        //             child: RaisedButton(
                        //               textColor: Colors.black,
                        //               color: _20minPressed
                        //                   ? Colors.white
                        //                   : Colors.transparent,
                        //               child: new Column(
                        //                 children: [
                        //                   Text(
                        //                     "20 min",
                        //                     style: TextStyle(
                        //                       color: _20minPressed
                        //                           ? Colors.black
                        //                           : Colors.white,
                        //                       fontSize: 14,
                        //                       fontFamily: 'HelveticaNeue',
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               onPressed: () => {
                        //                 setState(() {
                        //                   _20minPressed = !_20minPressed;
                        //                   noOfDrillstime = "1200";
                        //                   _value = 4;
                        //                   noOfDrills = 4;
                        //                   if (_20minPressed) {
                        //                     _45minPressed = false;
                        //                     _1hrPlushPressed = false;
                        //                   }
                        //                 }),
                        //               },
                        //               shape: new RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       new BorderRadius.circular(8.0),
                        //                   side:
                        //                       BorderSide(color: Colors.white)),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //           child: ButtonTheme(
                        //             minWidth: 110.0,
                        //             height: 40.0,
                        //             // ignore: deprecated_member_use
                        //             child: RaisedButton(
                        //               textColor: Colors.black,
                        //               color: _45minPressed
                        //                   ? Colors.white
                        //                   : Colors.transparent,
                        //               child: new Column(
                        //                 children: [
                        //                   Text(
                        //                     "45 min",
                        //                     style: TextStyle(
                        //                       color: _45minPressed
                        //                           ? Colors.black
                        //                           : Colors.white,
                        //                       fontSize: 14,
                        //                       fontFamily: 'HelveticaNeue',
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               onPressed: () => {
                        //                 setState(() {
                        //                   _45minPressed = !_45minPressed;
                        //                   _value = 7;
                        //                   noOfDrills = 7;
                        //                   noOfDrillstime = "2700";
                        //                   if (_45minPressed) {
                        //                     _20minPressed = false;
                        //                     _1hrPlushPressed = false;
                        //                   }
                        //                 }),
                        //               },
                        //               shape: new RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       new BorderRadius.circular(8.0),
                        //                   side:
                        //                       BorderSide(color: Colors.white)),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //           child: ButtonTheme(
                        //             minWidth: 110.0,
                        //             height: 40.0,
                        //             // ignore: deprecated_member_use
                        //             child: RaisedButton(
                        //               textColor: Colors.black,
                        //               color: _1hrPlushPressed
                        //                   ? Colors.white
                        //                   : Colors.transparent,
                        //               child: new Column(
                        //                 children: [
                        //                   Text(
                        //                     "1hr +",
                        //                     style: TextStyle(
                        //                       color: _1hrPlushPressed
                        //                           ? Colors.black
                        //                           : Colors.white,
                        //                       fontSize: 14,
                        //                       fontFamily: 'HelveticaNeue',
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               onPressed: () => {
                        //                 setState(() {
                        //                   _1hrPlushPressed = !_1hrPlushPressed;
                        //                   _value = 10;
                        //                   noOfDrills = 10;
                        //                   noOfDrillstime = "3600";
                        //                   if (_1hrPlushPressed) {
                        //                     _20minPressed = false;
                        //                     _45minPressed = false;
                        //                   }
                        //                 })
                        //               },
                        //               shape: new RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       new BorderRadius.circular(8.0),
                        //                   side:
                        //                       BorderSide(color: Colors.white)),
                        //             ),
                        //           ),
                        //         )
                        //       ]),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 5.0),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              'Number of Drills',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'HelveticaNeue',
                                // fontWeight: FontWeight.w800
                              ),
                              /*style: GoogleFonts.poppins(
                                          fontSize: 50,
                                        ),*/
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 10.0, top: 5.0),
                          padding:
                              const EdgeInsets.only(right: 20.0, bottom: 3.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SfSliderTheme(
                              data: SfSliderThemeData(
                                activeTickColor:
                                    Color.fromARGB(255, 237, 28, 36),
                                inactiveTickColor:
                                    Color.fromARGB(255, 237, 28, 36),
                                activeLabelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'HelveticaNeue',
                                ),
                                tickOffset: Offset(0.0, 5.0),
                              ),
                              child: SfSlider(
                                min: 1.0,
                                max: 10.0,
                                value: _value,
                                stepSize: 1,
                                interval: 1,
                                showTicks: true,
                                showLabels: true,
                                showDividers: true,
                                minorTicksPerInterval: 0,
                                enableTooltip: false,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    _value = value;
                                    noOfDrills = _value;
                                    print("VALUE IS" + _value.toString());
                                  });
                                },
                                activeColor: Color.fromARGB(255, 237, 28, 36),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonTheme(
                            minWidth: 150.0,
                            height: 50.0,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              textColor: Colors.black,
                              color: Color.fromARGB(255, 237, 28, 36),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Generate Plan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'HelveticaNeue',
                                    ),
                                  ),
                                ],
                              ),
                              //onPressed: widget.genratePlanPressed,
                              onPressed: () async => {
                                WidgetsBinding.instance.addPostFrameCallback(
                                    (_) =>
                                        _blockWithSubscriptionGenerate(context))
                                // if (_dribblingPressed.toString() == "true")
                                //   {category.add('Dribbling')}
                                // else
                                //   {},
                                // if (_passingPressed.toString() == "true")
                                //   {category.add('Passing')}
                                // else
                                //   {},
                                // if (_shootingPressed.toString() == "true")
                                //   {category.add('Shooting')}
                                // else
                                //   {},
                                // if (_wall_workPressed.toString() == "true")
                                //   {category.add('Wall Work')}
                                // else
                                //   {},
                                // if (_jugglingPressed.toString() == "true")
                                //   {category.add('Juggling')}
                                // else
                                //   {},
                                // if (_ballmasteryPressed.toString() == "true")
                                //   {category.add('Ball Mastery')}
                                // else
                                //   {},
                                // if (category.isEmpty)
                                //   {
                                //     Toast.show(
                                //         "Please Select at least One Category",
                                //         context,
                                //         duration: Toast.LENGTH_SHORT,
                                //         gravity: Toast.BOTTOM)
                                //   }
                                // else
                                //   {
                                //     objectives = category.join(', '),
                                //     generatePlanApiCall(
                                //         participants,
                                //         objectives,
                                //         noOfDrillstime,
                                //         noOfDrills.toStringAsFixed(0),
                                //         skillLevel)
                                //   }
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      color: _generatePlanPressed
                                          ? Color.fromARGB(255, 237, 28, 36)
                                          : Color.fromARGB(255, 237, 28, 36))),
                            ),
                          ),
                          SizedBox(width: 10),
                          ButtonTheme(
                            minWidth: 150.0,
                            height: 50.0,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              textColor: Colors.black,
                              color: _buildOwnPlanPressed
                                  ? Color.fromARGB(255, 237, 28, 36)
                                  : Colors.transparent,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Build Own Plan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'HelveticaNeue',
                                    ),
                                  ),
                                ],
                              ),
                              // onPressed: widget.onBuildOwnPlanPress,
                              onPressed: () => {
                                Amplitude.getInstance(
                                        instanceName:
                                            Constants.AMPLITUDE_INSTANCE_NAME)
                                    .logEvent('Build Plan Clicked'),
                                widget.onBuildOwnPlanPress(),
                              },
                              /* onPressed: () => {
                                setState(() {



                                  */ /*_buildOwnPlanPressed = !_buildOwnPlanPressed;*/ /*

                                }),
                              },*/
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      color: _buildOwnPlanPressed
                                          ? Color.fromARGB(255, 237, 28, 36)
                                          : Colors.white)),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          );
        }),
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
    );
  }

  Future<void> _blockWithSubscriptionGenerate(BuildContext context) async {
    bool shouldRenderSubscription = await checkAPIBlocker();
    bool userEntitled = await checkNonFitnessAccess();
    if (userEntitled || !shouldRenderSubscription) {
      generatePlanApproved();
    } else {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Subscription Blocker Rendered",
              eventProperties: {"source": "train_generate_plan"});
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return SubscriptionBlocker(() => generatePlanApproved());
          });
    }
  }

  generatePlanApproved() {
    if (_dribblingPressed.toString() == "true") {
      category.add('Dribbling');
    }
    if (_passingPressed.toString() == "true") {
      category.add('Passing');
    }
    if (_shootingPressed.toString() == "true") {
      category.add('Shooting');
    }
    if (_wall_workPressed.toString() == "true") {
      category.add('Wall Work');
    }
    if (_jugglingPressed.toString() == "true") {
      category.add('Juggling');
    }
    if (_ballmasteryPressed.toString() == "true") {
      category.add('Ball Mastery');
    }
    if (category.isEmpty) {
      Toast.show("Please Select at least One Category", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      objectives = category.join(', ');
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Generate Plan Clicked", eventProperties: {
        "num_participants": participants,
        "objectives": objectives,
        "num_drills": noOfDrills.toStringAsFixed(0),
        "skill_level": skillLevel
      });
      generatePlanApiCall(participants, objectives, noOfDrillstime,
          noOfDrills.toStringAsFixed(0), skillLevel);
    }
  }

  onSubscriptionItemTap(BuildContext context, ItemModel item) {
    String strMessage = "You had choosen " + item.description.toString();
    print(strMessage);
    Toast.show('$strMessage', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  generatePlanApiCall(String participants, String objectives, String drillTime,
      String noOfDrills, String skillLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    if (userdata != null) {
      final jsonResponse = json.decode(userdata);
      LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
      if (loginResponse.data != null) {
        setState(() {
          userId = loginResponse.data.user.userId.toString();
          userName = loginResponse.data.user.username.toString();
        });
      } else {}
    } else {
      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>parsdata is null>>>>>>>>>>>>>>>>>>>>');
    }
    setState(() {
      _isInAsyncCall = true;
    });
    print("Username before generate plan ... ${userName}");
    GetDrillResponse getDrills = await generatePlan(participants, objectives,
        drillTime, noOfDrills, skillLevel, userId, userName);

    prefs.setString(Constants.GENARATE_PLAN_DATA, jsonEncode(getDrills));

    if (getDrills.status == "true") {
      _isInAsyncCall = false;
      /* prefs.setBool(Constants.IS_GENARATE_PLAN, true);
      prefs.setBool(Constants.IS_SAVED_PLAN, false);
      widget.genratePlanPressed();
      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>cxcxcc>>>>STATUS TRUE>>>>>>>>>>>>>>>>>>>>' +
              getDrills.message);
      Toast.show("${getDrills.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          */
      prefs.setString(Constants.VIEW_PLAN, "true");
      prefs.setString(Constants.PLAN_ID, getDrills.data[0].planid.toString());
      prefs.setString(
          Constants.PLAN_NAME, getDrills.data[0].planname.toString());
      prefs.setBool(Constants.IS_SAVED_PLAN, true);
      prefs.setBool(Constants.IS_GENARATE_PLAN, false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          ModalRoute.withName("dashboard"));
      Toast.show("Plan automatically generated and saved", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          getDrills.message);
      Toast.show("${getDrills.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
