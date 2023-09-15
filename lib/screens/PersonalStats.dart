import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:trainsolo/model/personal_stats_response.dart';
import 'package:trainsolo/screens/Dashboard.dart';
import 'package:trainsolo/screens/FitnessRecords.dart';

import 'package:trainsolo/utils/Constants.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class PersonalStats extends StatefulWidget {
  final USERData userpersonaldata;

  PersonalStats({@required this.userpersonaldata});

  PersonalStatsPage createState() => PersonalStatsPage();
}

class PersonalStatsPage extends State<PersonalStats> {
  bool _isInAsyncCall = false;
  double _value = 5.0;
  var highschool_text = "Highschool";
  var college_text = "College";
  var other_text = "Other";

  void changeData() {
    setState(() {
      college_text = "College3";
    });
  }

  @override
  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Profile Personal Stats Tab Loaded");
    print("User data: ${widget.userpersonaldata}");
    // getPersonalStatsApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: ModalProgressHUD(
          child: Container(
            // margin: const EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: double.infinity,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 0.0),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(
                                  'LEVEL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        bottom: 10.0,
                                        top: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0,
                                                  top: 8.0,
                                                  bottom: 8.0,
                                                  right: 0.0),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: SizedBox.expand(
                                                    child: FittedBox(
                                                      child: Image.asset(
                                                          "assets/yellow_star.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 45,
                                              left: 45,
                                              height: 43,
                                              width: 43,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0, bottom: 0.0),
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  child: Text(
                                                    widget.userpersonaldata !=
                                                            null
                                                        ? widget
                                                            .userpersonaldata
                                                            .levelno
                                                            .toString()
                                                        : "1",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontFamily: 'BebasNeue',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          //Use of SizedBox
                                          height: 2,
                                        ),
                                        SfSliderTheme(
                                          data: SfSliderThemeData(
                                            activeTrackHeight: 10,
                                            inactiveTrackHeight: 10,
                                            trackCornerRadius: 5,
                                            overlayColor: Colors.transparent,
                                            activeDividerRadius: 1,
                                            activeDividerStrokeWidth: 20,
                                            thumbStrokeWidth: 10,
                                            thumbColor: Colors.transparent,
                                            activeTrackColor:
                                                Colors.yellow[800],
                                            inactiveTrackColor: Colors.white,
                                          ),
                                          child: SfSlider(
                                            min: 1.0,
                                            max: 10.0,
                                            value: _value,
                                            onChanged: (dynamic newValue) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          //Use of SizedBox
                                          height: 2,
                                        ),
                                        Text(
                                            widget.userpersonaldata != null &&
                                                    (widget.userpersonaldata
                                                                .remaininglevelupstr !=
                                                            null &&
                                                        widget.userpersonaldata
                                                                .remaininglevelupstr !=
                                                            0.0)
                                                ? widget.userpersonaldata
                                                    .remaininglevelupstr
                                                : "10 Sessions to Level 2",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontFamily: 'HelveticaNeue',
                                              fontWeight: FontWeight.w400,
                                            )),
                                        SizedBox(
                                          //Use of SizedBox
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      width: double.infinity,
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              //flex: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 0.0),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 5.0, top: 10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Streak",
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.white,
                                              fontFamily: 'BebasNeue',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 10.0),
                                            child: Divider(
                                              height: 10,
                                              thickness: 2,
                                              indent: 50,
                                              endIndent: 50,
                                              color: Color.fromARGB(
                                                  255, 255, 0, 0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 10.0),
                                            child: Text(
                                              widget.userpersonaldata != null &&
                                                      widget.userpersonaldata
                                                              .personalstreak !=
                                                          null
                                                  ? widget.userpersonaldata
                                                          .personalstreak
                                                          .toString() +
                                                      "Days"
                                                  : "0 Days",
                                              style: TextStyle(
                                                fontSize: 60.0,
                                                color: Colors.white,
                                                fontFamily: 'BebasNeue',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              //flex: 1,
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 20, 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 0.0),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 5.0, top: 10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "best Streak",
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.white,
                                              fontFamily: 'BebasNeue',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 10.0),
                                            child: Divider(
                                              height: 10,
                                              thickness: 2,
                                              indent: 50,
                                              endIndent: 50,
                                              color: Color.fromARGB(
                                                  255, 255, 0, 0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 10.0),
                                            child: Text(
                                              widget.userpersonaldata != null &&
                                                      widget.userpersonaldata
                                                              .personalstreak !=
                                                          null
                                                  ? widget.userpersonaldata
                                                          .personalstreak
                                                          .toString() +
                                                      "Days"
                                                  : "0 Days",
                                              style: TextStyle(
                                                fontSize: 60.0,
                                                color: Colors.white,
                                                fontFamily: 'BebasNeue',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                    ButtonTheme(
                      minWidth: 150.0,
                      height: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0),
                        // ignore: deprecated_member_use
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "trainsolosoccerhelp@gmail.com",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'HelveticaNeue',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 150.0,
                      height: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0),
                        // ignore: deprecated_member_use
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                child: Text(
                                  "Terms and Conditions",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'HelveticaNeue',
                                  ),
                                ),
                                onTap: () => {
                                      Amplitude.getInstance(
                                              instanceName: Constants
                                                  .AMPLITUDE_INSTANCE_NAME)
                                          .logEvent(
                                              "Profile Terms and Conditions Clicked"),
                                      launch(
                                          'https://www.trainsolosoccer.com/terms-and-conditions')
                                    }),
                          ],
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 150.0,
                      height: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0),
                        // ignore: deprecated_member_use
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                child: Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'HelveticaNeue',
                                  ),
                                ),
                                onTap: () => {
                                      Amplitude.getInstance(
                                              instanceName: Constants
                                                  .AMPLITUDE_INSTANCE_NAME)
                                          .logEvent(
                                              "Profile Privacy Policy Clicked"),
                                      launch(
                                          'https://www.trainsolosoccer.com/privacy-policy')
                                    }),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 20),
                    // Container(
                    //   height: 40,
                    //   child: InkWell(
                    //       child: Text("Terms and Conditions",
                    //           style:
                    //               TextStyle(color: Colors.white, fontSize: 14)),
                    //       onTap: () => launch(
                    //           'https://www.trainsolosoccer.com/terms-and-conditions')),
                    // ),
                    // SizedBox(height: 20),
                    // Container(
                    //   height: 50,
                    //   child: InkWell(
                    //       child: Text("Privacy Policy",
                    //           style:
                    //               TextStyle(color: Colors.white, fontSize: 14)),
                    //       onTap: () => launch(
                    //           'https://www.trainsolosoccer.com/privacy-policy')),
                    // ),
                  ],
                ),
              ),
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

  Future<void> getSharpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.VIEW_TECH_HUB, "true");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
        ModalRoute.withName("dashboard"));
  }
}
