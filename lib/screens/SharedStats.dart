import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/shared_stats_response.dart';
import 'package:trainsolo/screens/SharedStatsDetails.dart';
import 'package:trainsolo/utils/Constants.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class SharedStats extends StatefulWidget {
  SharedStatsPage createState() => SharedStatsPage();
}

class SharedStatsPage extends State<SharedStats> {
  List<SharedStatsData> sharedStatsData = [];
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Profile Shared Stats Tab Loaded");
    getSharedStatsCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        child: buildPageView(),
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
    );
  }

  Widget buildPageView() {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: ListView.builder(
                      // Widget which creates [ItemWidget] in scrollable list.
                      itemCount: sharedStatsData
                          .length, // Number of widget to be created.
                      itemBuilder: (context, itemIndex) =>
                          ItemWidget(sharedStatsData[itemIndex], () {
                        _onItemTap(context, sharedStatsData[itemIndex]);
                      }, () {
                        _report(context, sharedStatsData[itemIndex]);
                      }, () {
                        _save(context, sharedStatsData[itemIndex]);
                      }),
                    )),
              ),
            ),
          ]),
    );
  }

  Future<void> getSharedStatsCall() async {
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

      SharedStatsResponse sharedStatsresponse =
          await getSharedStats(userId, userName);
      print(sharedStatsresponse.data);
      if (sharedStatsresponse.status == "true") {
        setState(() {
          _isInAsyncCall = false;
        });
        Toast.show("${sharedStatsresponse.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        setState(() {
          sharedStatsData = sharedStatsresponse.data;
        });
      } else {
        setState(() {
          _isInAsyncCall = false;
        });
        print(
            "::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>INSIDE getSharedStatsCall>>>>>>>>>>>>>FAIL>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        Toast.show("${sharedStatsresponse.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }
}

_onItemTap(BuildContext context, SharedStatsData item) {
  print("this is on tap item and index is " + item.plantitle);
  String itemName = item.plantitle.toString();
  String planID = item.planid.toString();
  Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
      .logEvent("Profile Shared Stats Report Clicked",
          eventProperties: {"plan_id": planID});
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SharedStatsDetails(
            title: '$itemName',
            planID: '$planID',
          )));
}

_report(BuildContext context, SharedStatsData item) {
  print("this is on tap _shareItem and index is " + item.plantitle);
}

_save(BuildContext context, SharedStatsData item) {
  print("this is on tap _save and index is " + item.plantitle);
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this._report, this._save,
      {Key key})
      : super(key: key);

  final SharedStatsData model;
  final Function onItemTap;
  final Function _report;
  // ignore: unused_field
  final Function _save;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: Container(
          height: 90,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: Container(
                      child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 237, 28, 36),
                              border: Border.all(
                                color: Color.fromARGB(255, 237, 28, 36),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Center(
                            child: Text(
                              model.plantitle != null
                                  ? model.plantitle.substring(0, 2)
                                  : "TM",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  model.plantitle != null
                                      ? model.plantitle
                                      : "TEAM",
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(
                                //Use of SizedBox
                                height: 10,
                              ),
                              Text(
                                  model.drillsjsondata != null
                                      ? "Drills: " +
                                          getlenth(model.drillsjsondata)
                                      : "Drills: 0",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                            onTap: _report,
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text("REPORT",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'HelveticaNeue',
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            )),
                      )
                    ],
                  )),
                ),
              )
            ],
          )),
    );
  }

  String getlenth(String drillsjsondata) {
    String drill = drillsjsondata.split(',').length.toString();
    return drill;
  }
}
