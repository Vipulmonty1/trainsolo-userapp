import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_plan_list_by_id_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/screens/CommanPlanList.dart';
import 'package:trainsolo/screens/Dashboard.dart';
import 'package:trainsolo/utils/Constants.dart';
import '../api/api_service.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class MyPlansSaved extends StatefulWidget {
  MyPlansSavedPage createState() => MyPlansSavedPage();
}

class MyPlansSavedPage extends State<MyPlansSaved>
    with SingleTickerProviderStateMixin {
  bool _isInAsyncCall = false;
  // ignore: unused_field
  TabController _tabController;

  List<Plan> planList = [];
  List<Plan> completedplanList = [];
  List<Plan> sharedPlanList = [];

  @override
  @override
  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("My Plans Page My Plans Tab Loaded");
    _tabController = new TabController(vsync: this, length: 3);
    getPlanlist();
    getCompletedPlanlist();
    getSharedPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: ModalProgressHUD(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Color.fromARGB(255, 237, 28, 36),
                onPressed: () {
                  gotoGenratePlan();
                },
              ),
              appBar: AppBar(
                backgroundColor: Colors.black,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TabBar(
                        indicatorColor: Color.fromARGB(255, 237, 28, 36),
                        indicatorWeight: 2.0,
                        isScrollable: true,
                        labelStyle: TextStyle(fontSize: 25.0),
                        //For Selected tab
                        unselectedLabelStyle: TextStyle(fontSize: 20.0),
                        tabs: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                "SAVED",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                "HISTORY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                "SHARED",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Container(
                constraints: BoxConstraints.expand(),
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TabBarView(
                    children: [
                      CommanPlanList(planList: planList),
                      CommanPlanList(planList: completedplanList),
                      CommanPlanList(planList: sharedPlanList)
                    ],
                  ),
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
        ));
  }

  Future<void> getPlanlist() async {
    setState(() {
      _isInAsyncCall = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      GetPlanListByIdResponse getPlans = await getPlansById(
          loginResponse.data.user.userId.toString(),
          loginResponse.data.user.username.toString(),
          "Active");

      if (getPlans.status == "true") {
        _isInAsyncCall = false;

        // Toast.show("${getDrills.message}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        setState(() {
          planList = getPlans.data;
        });
      } else {
        _isInAsyncCall = false;
      }
    }
  }

  Future<void> getCompletedPlanlist() async {
    setState(() {
      _isInAsyncCall = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      GetPlanListByIdResponse getPlans = await getPlansById(
          loginResponse.data.user.userId.toString(),
          loginResponse.data.user.username.toString(),
          "Completed");

      if (getPlans.status == "true") {
        _isInAsyncCall = false;

        // Toast.show("${getDrills.message}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        setState(() {
          completedplanList = getPlans.data;
        });
      } else {
        _isInAsyncCall = false;
      }
    }
  }

  Future<void> getSharedPlan() async {
    setState(() {
      _isInAsyncCall = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      GetPlanListByIdResponse getPlans = await getPlansById(
          loginResponse.data.user.userId.toString(),
          loginResponse.data.user.username.toString(),
          "Shared");

      if (getPlans.status == "true") {
        _isInAsyncCall = false;

        // Toast.show("${getDrills.message}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        setState(() {
          sharedPlanList = getPlans.data;
        });
      } else {
        _isInAsyncCall = false;
      }
    }
  }

  Future<void> gotoGenratePlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.IS_GENARATE_PLAN, true);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
        ModalRoute.withName("dashboard"));
  }
}
