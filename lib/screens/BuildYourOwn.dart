import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/common_success.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'CommanList.dart';
import 'Dashboard.dart';
import 'package:toast/toast.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class BuildYourOwn extends StatefulWidget {
  final VoidCallback onButtonPressed;
  final String planId;
  final String planName;
  final List<int> drillIds;
  BuildYourOwn(
      {@required this.onButtonPressed,
      this.planId,
      this.planName,
      this.drillIds});
  BuildYourOwnPage createState() => BuildYourOwnPage();
}

class BuildYourOwnPage extends State<BuildYourOwn>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  bool _isInAsyncCall = false;
  String searchText = '';

  List<int> selectedDrills = [];

  List<Tab> myTabs = <Tab>[
    Tab(text: "ALL"),
    Tab(text: "DRIBBLING"),
    Tab(text: "PASSING"),
    Tab(text: "SHOOTING"),
    Tab(text: "WALL WORK"),
    Tab(text: "JUGGLING"),
    Tab(text: "BALL MASTERY"),
  ];

  final controllerplanName = TextEditingController();

  TabController _tabController;
  CommonList commonList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(() {
      print('my index is' + _tabController.index.toString());
    });
    if (widget.planName != null) {
      controllerplanName.text = widget.planName;
      selectedDrills.addAll(widget.drillIds);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 237, 28, 36),
          onPressed: () {
            Amplitude.getInstance(
                    instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                .logEvent("Build Plan Create Plan Clicked",
                    eventProperties: {"num_drills_in_plan": selectedDrills});
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.black,
                  title: Text(
                    'Save Your Plan',
                    style: TextStyle(color: Color.fromARGB(255, 237, 28, 36)),
                  ), // To display the title it is optional
                  content: TextField(
                    decoration: new InputDecoration(
                        hintText: "Enter your Plan name",
                        labelText: "Plan Name",
                        labelStyle:
                            new TextStyle(color: const Color(0xFF424242)),
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Color.fromARGB(255, 237, 28, 36)))),
                    controller: controllerplanName,
                    style: TextStyle(color: Colors.white),
                  ), // Message which will be pop up on the screen
                  // Action widget which will provide the user to acknowledge the choice
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                      // FlatButton widget is used to make a text to work like a button
                      textColor: Colors.white,
                      onPressed: () {
                        Amplitude.getInstance(
                                instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                            .logEvent("Build Plan Create Plan Cancelled",
                                eventProperties: {
                              "num_drills_in_plan": selectedDrills
                            });
                        Navigator.pop(context);
                      }, // function used to perform after pressing the button
                      child: Text('CANCEL'),
                    ),
                    // ignore: deprecated_member_use
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () async {
                        Amplitude.getInstance(
                                instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                            .logEvent("Build Plan Create Plan Save Clicked",
                                eventProperties: {
                              "num_drills_in_plan": selectedDrills
                            });
                        if (selectedDrills.length > 0) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          String drillIds = selectedDrills.join(', ');

                          var userdata = prefs.getString(Constants.USER_DATA);
                          if (userdata != null) {
                            final jsonResponse = json.decode(userdata);
                            LoginResponse loginResponse =
                                new LoginResponse.fromJson(jsonResponse);
                            if (loginResponse.data != null) {
                              if (widget.planId != null) {
                                updatePlanApiCall(
                                    widget.planId,
                                    loginResponse.data.user.userId,
                                    loginResponse.data.user.username,
                                    controllerplanName.text,
                                    drillIds,
                                    "",
                                    controllerplanName.text.substring(0, 2),
                                    0);
                              } else {
                                createPlanApiCall(
                                    "",
                                    loginResponse.data.user.userId,
                                    loginResponse.data.user.username,
                                    controllerplanName.text,
                                    drillIds,
                                    "",
                                    controllerplanName.text.substring(0, 2),
                                    0);
                              }
                            } else {
                              print(
                                  '>>>>>>>>>>>>>>>>>>>>>>>>>>DATA>>>loginResponse is null>>>>>>>>>>>>>>>>>>>>');
                            }
                            Navigator.pop(context);
                          }
                        } else {}
                      },
                      child: Text('SAVE'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TabBar(
            controller: _tabController,
            indicatorColor: Color.fromARGB(255, 237, 28, 36),
            indicatorWeight: 2.0,
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 20.0),
            unselectedLabelStyle: TextStyle(fontSize: 16.0),
            tabs: myTabs,
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: ExactAssetImage('assets/splash.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TabBarView(
              controller: _tabController,
              children: myTabs.map((Tab tab) {
                final String label = tab.text.toLowerCase();
                commonList = CommonList(
                    categoryName: '$label',
                    onItemSelected: OnItemSelected,
                    fromSelectedItems: fromSelectedItems);
                return commonList;
              }).toList(),

              /* children: [
                CommonList(categoryName: "All"),
                CommonList(categoryName: "passing"),
                CommonList(categoryName: "shooting"),
                CommonList(categoryName: "dribbling"),
                CommonList(categoryName: "Fitness"),
              ],*/
            ),
          ),
        ),
      ),
    );
  }

  void OnItemSelected(Drills selected, bool checked) {
    if (checked) {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Build Plan Drill Added", eventProperties: {
        "drill_name": selected.title,
        "drill_id": selected.drillid
      });
      selectedDrills.add(selected.drillid);
    } else {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Build Plan Drill Removed", eventProperties: {
        "drill_name": selected.title,
        "drill_id": selected.drillid
      });
      selectedDrills.remove(selected.drillid);
    }
    setState(() {});
  }

  bool fromSelectedItems(Drills value) {
    if (selectedDrills.indexOf(value.drillid) < 0) {
      return false;
    }
    return true;
  }

  void createPlanApiCall(
      String planId,
      int userId,
      String userName,
      String planTitle,
      String durationJsonData,
      String totalDuration,
      String thumbNail,
      int isbookd) async {
    setState(() {
      _isInAsyncCall = true;
    });
    CommonSuccess response = await createPlan(
        planId.toString(),
        userId.toString(),
        userName,
        planTitle,
        durationJsonData,
        totalDuration,
        thumbNail,
        isbookd.toString());

    var message = response.message;
    if (response.status == "true") {
      setState(() {
        _isInAsyncCall = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(Constants.CREATE_PLAN, true);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          ModalRoute.withName("dashboard"));
      Toast.show("${message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      Toast.show("${message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void updatePlanApiCall(
      String planId,
      int userId,
      String userName,
      String planTitle,
      String durationJsonData,
      String totalDuration,
      String thumbNail,
      int isbookd) async {
    setState(() {
      _isInAsyncCall = true;
    });
    CommonSuccess response = await updatePlan(
        planId.toString(),
        userId.toString(),
        userName,
        planTitle,
        durationJsonData,
        totalDuration,
        thumbNail,
        isbookd.toString());

    var message = response.message;
    if (response.status == "true") {
      setState(() {
        _isInAsyncCall = false;
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          ModalRoute.withName("dashboard"));
      Toast.show("${message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      Toast.show("${message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
