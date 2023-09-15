import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/ItemModel.dart';
import 'package:trainsolo/model/common_success.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/get_plan_info_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/screens/BuildYourOwn.dart';
import 'package:trainsolo/screens/Dashboard.dart';
import 'package:trainsolo/screens/TrainingOnGoing.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:trainsolo/utils/Constants.dart';
import '../api/api_service.dart';
import 'dart:convert';
import 'dart:async';

import 'SharePlan.dart';
import 'SubscriptionBlocker.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

// import 'package:path/path.dart';

class TrainingPlanSet extends StatefulWidget {
  final VoidCallback onButtonPressed;
  final VoidCallback onCreatePlansPressed;

  TrainingPlanSet({@required this.onButtonPressed, this.onCreatePlansPressed});

  TrainingPlanSetPage createState() => TrainingPlanSetPage();
}

class TrainingPlanSetPage extends State<TrainingPlanSet> {
  bool _buildOwnPlanPressed = false;
  bool _startTrainingPressed = false;
  bool _isInAsyncCall = false;
  bool bookmark = false;
  int userId;
  String userName;
  int isbook = 0;
  bool isSavedPlan = false;
  bool isGenaratePlan = false;

  final controllerplanName = TextEditingController();

  List<Drills> drillList = [];
  List<Drills> drillListFromPlan = [];
  List<int> drillIdList = [];
  List<String> drilltitle = [];

  String planId = "0";
  String planName = "TRAINING PLAN 1";

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    fetchAlbum();
    // print("About to display text input");
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _displayTextInputDialog(context));
    // print("Finished displaying text input");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: controllerplanName,
                                onSubmitted: (String value) async {
                                  String drillIds = drillIdList.join(', ');
                                  updatePlanApiCall(
                                          planId,
                                          userId,
                                          userName,
                                          controllerplanName.text,
                                          drillIds,
                                          "",
                                          controllerplanName.text
                                              .substring(0, 2),
                                          isbook)
                                      .then((value) =>
                                          getPlanInfoApiCall(value.toString()))
                                      .onError((error, stackTrace) =>
                                          Toast.show(
                                              "Unable to Update Plan Name",
                                              context,
                                              duration: Toast.LENGTH_SHORT,
                                              gravity: Toast.BOTTOM));
                                  planName = controllerplanName.text;
                                },
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'PLAN NAME',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            // IconButton(
                            //   icon: Icon(
                            //     TrainsoloIcons.note,
                            //     color: bookmark
                            //         ? Color.fromARGB(255, 237, 28, 36)
                            //         : Colors.white,
                            //     size: 24.0,
                            //   ),
                            //   iconSize: 30,
                            //   color: Colors.green,
                            //   splashColor: Colors.purple,
                            //   onPressed: () {
                            //     setState(() {
                            //       bookmark = !bookmark;
                            //       if (bookmark) {
                            //         isbook = 1;
                            //       } else {
                            //         isbook = 0;
                            //       }
                            //     });
                            //
                            //     print('IconButton is pressed note');
                            //   },
                            // ),
                            (isSavedPlan != null && isSavedPlan
                                ? Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.ios_share,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                        iconSize: 30,
                                        color: Colors.green,
                                        splashColor: Colors.purple,
                                        onPressed: () {
                                          Amplitude.getInstance(
                                                  instanceName: Constants
                                                      .AMPLITUDE_INSTANCE_NAME)
                                              .logEvent(
                                                  "Training Share Plan Clicked",
                                                  eventProperties: {
                                                "num_plan_drills":
                                                    drillList.length,
                                                "plan_id": planId
                                              });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SharePlan(
                                                          planid:
                                                              planId.toString(),
                                                          planName:
                                                              this.planName)));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          TrainsoloIcons.delete,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                        iconSize: 30,
                                        color: Colors.green,
                                        splashColor: Colors.purple,
                                        onPressed: () {
                                          print('IconButton is pressed delete');

                                          if (planId != null) {
                                            Amplitude.getInstance(
                                                    instanceName: Constants
                                                        .AMPLITUDE_INSTANCE_NAME)
                                                .logEvent(
                                                    "Training Delete Plan Clicked",
                                                    eventProperties: {
                                                  "num_plan_drills":
                                                      drillList.length,
                                                  "plan_id": planId
                                                });
                                            deletePlanApiCall(planId);
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.save,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                      iconSize: 30,
                                      color: Colors.green,
                                      splashColor: Colors.purple,
                                      onPressed: () {
                                        String drillIds =
                                            drillIdList.join(', ');
                                        if (controllerplanName.text.isEmpty) {
                                          Toast.show('Enter training plan name',
                                              context,
                                              duration: Toast.LENGTH_SHORT,
                                              gravity: Toast.BOTTOM);
                                        } else {
                                          createPlanApiCall(
                                              "",
                                              userId,
                                              userName,
                                              controllerplanName.text,
                                              drillIds,
                                              "",
                                              controllerplanName.text
                                                  .substring(0, 2),
                                              isbook);
                                        }

                                        /*
                              if(bookmark){
                                isbook =1;
                              }else{
                                isbook =1;
                              }*/

                                        // generatePlanApiCall("",userId,userName,controllerplanName.text,drillIds,"",titleSort,);

                                        //-----------------------------------api call-----------------/myplans/createPlan---------------------------------------------
                                      },
                                    ),
                                  ))
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isSavedPlan != null && isSavedPlan,
                        child: Container(
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
                                    color: Color.fromARGB(255, 237, 28, 36),
                                    child: new Column(
                                      children: [
                                        Text(
                                          "Start Training",
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
                                      Amplitude.getInstance(
                                              instanceName: Constants
                                                  .AMPLITUDE_INSTANCE_NAME)
                                          .logEvent(
                                              "Training Start Training Clicked",
                                              eventProperties: {
                                            "num_plan_drills": drillList.length,
                                            "plan_id": planId
                                          }),
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TrainingOnGoing(
                                                    drillItem:
                                                        drillListFromPlan[0],
                                                    drillList:
                                                        drillListFromPlan,
                                                    planId: planId,
                                                  )
                                              // builder: (context) => TrainingOnGoing()
                                              )),
                                      setState(() {
                                        _startTrainingPressed =
                                            !_startTrainingPressed;
                                      }),
                                    },
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: _startTrainingPressed
                                                ? Color.fromARGB(
                                                    255, 237, 28, 36)
                                                : Color.fromARGB(
                                                    255, 255, 0, 0))),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Visibility(
                                  visible: true,
                                  child: ButtonTheme(
                                    minWidth: 120.0,
                                    height: 50.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      textColor: Colors.black,
                                      color: _buildOwnPlanPressed
                                          ? Color.fromARGB(255, 237, 28, 36)
                                          : Colors.transparent,
                                      child: new Column(
                                        children: [
                                          Text(
                                            "Add Drill",
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
                                            .logEvent(
                                                "Training Add Drill Clicked",
                                                eventProperties: {
                                              "num_plan_drills":
                                                  drillList.length,
                                              "plan_id": planId
                                            }),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BuildYourOwn(
                                                      planId: planId,
                                                      planName: planName,
                                                      drillIds: drillIdList,
                                                      onButtonPressed: () {},
                                                    )
                                                // builder: (context) => TrainingOnGoing()
                                                ))
                                      },
                                      /*onPressed: () => {
                            setState(() {
                              _buildOwnPlanPressed = !_buildOwnPlanPressed;

                            }),
                          },*/
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          side: BorderSide(
                                              color: _buildOwnPlanPressed
                                                  ? Color.fromARGB(
                                                      255, 255, 0, 0)
                                                  : Colors.white)),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                      Divider(
                        height: 10,
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.white,
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListView.builder(
                        // Widget which creates [ItemWidget] in scrollable list.
                        itemCount: isSavedPlan != null && isSavedPlan
                            ? drillListFromPlan.length
                            : drillList.length,
                        itemBuilder: (context, itemIndex) => isSavedPlan
                            ? ItemPlanWidget(drillListFromPlan[itemIndex], () {
                                _onItemTapPlan(
                                    context,
                                    drillListFromPlan[itemIndex],
                                    drillListFromPlan,
                                    planId);
                              }, () {
                                _closeItemPlan(
                                    context, drillListFromPlan[itemIndex]);
                              }, () {
                                _analysisPlan(
                                    context,
                                    drillListFromPlan[itemIndex],
                                    drillListFromPlan,
                                    planId);
                              }, itemIndex)
                            : ItemWidget(drillList[itemIndex], () {
                                _onItemTap(context, drillList[itemIndex],
                                    drillList, planId);
                              }, () {
                                _closeItem(context, drillList[itemIndex]);
                              }, () {
                                _analysis(context, drillList[itemIndex]);
                              }, itemIndex),
                        // Number of widget to be created.
                        //itemBuilder: (context, itemIndex) =>ItemWidget(_items[itemIndex], () {_onItemTap(context, itemIndex);},(){_closeItem(context, itemIndex);},(){_analysis(context, itemIndex);})
                        shrinkWrap: true,
                      )))
            ],
          ),
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    // TODO: refactor into its own widget
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return SubscriptionBlocker(() => print("Callback"));
        });
  }

  onSubscriptionItemTap(BuildContext context, ItemModel item) {
    // String strMessage = "You had choosen " + item.description.toString();
    // print(strMessage);
    // Toast.show('$strMessage', context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  void fetchAlbum() async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var genratePlandata = prefs.getString(Constants.GENARATE_PLAN_DATA);
    planId = prefs.getString(Constants.PLAN_ID);
    planName = prefs.getString(Constants.PLAN_NAME);
    var userdata = prefs.getString(Constants.USER_DATA);
    isSavedPlan = prefs.getBool(Constants.IS_SAVED_PLAN);
    isGenaratePlan = prefs.getBool(Constants.IS_GENARATE_PLAN);
    // var isDeepLink = prefs.getString(Constants.IS_DEEP_LINK);
    print("Is saved plan:${isSavedPlan}");
    print("Plan Name:${planName}");
    setState(() {
      if (isSavedPlan) {
        controllerplanName.text = planName.toString();
        planId = planId;
      }
    });

    if (isSavedPlan) {
      getPlanInfoApiCall(planId);
    }
    if (isGenaratePlan) {
      if (genratePlandata != null) {
        print(
            '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>INSIDE GENRATE PLAN DATA>>>>>>>>>>>>>>>>>>>>');

        final jsonResponse = json.decode(genratePlandata);
        GetDrillResponse getDrills =
            new GetDrillResponse.fromJson(jsonResponse);
        if (getDrills.data != null) {
          _isInAsyncCall = false;
          setState(() {
            drillList = getDrills.data;
            drillList.forEach((element) {
              drillIdList.add(element.drillid);
              drilltitle.add(element.title.substring(0, 2));
            });
          });
          drillList.forEach((element) {
            print(
                '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>genrate plan list>>>>>>>>>>>>>>>>>>>>' +
                    element.title);
          });
        } else {}
        /*setState(() {
        drillList=getDrills.data;
      });*/
      } else {
        print(
            '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>INSIDE API CALL>>>>>>>>>>>>>>>>>>>>');
      }
    }

    if (userdata != null) {
      final jsonResponse = json.decode(userdata);
      LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
      if (loginResponse.data != null) {
        setState(() {
          userId = loginResponse.data.user.userId;
          userName = loginResponse.data.user.username;
        });
      } else {
        print(
            '>>>>>>>>>>>>>>>>>>>>>>>>>>DATA>>>loginResponse is null>>>>>>>>>>>>>>>>>>>>');
      }
      /*setState(() {
        drillList=getDrills.data;
      });*/
    } else {
      //  print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>userdata is null>>>>>>>>>>>>>>>>>>>>');
    }
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
      widget.onCreatePlansPressed();
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

  void getPlanInfoApiCall(String planId) async {
    this.planId = planId;
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>plan drill list>>>>>>>>>>>>>>>>>>>>' +
        planId);
    setState(() {
      _isInAsyncCall = true;
    });
    GetPlanInfoResponse getPlanInfoResponse = await getPlanInfo(planId);

    // var message = response.message;
    if (getPlanInfoResponse.status == "true") {
      if (getPlanInfoResponse.data != null) {
        setState(() {
          _isInAsyncCall = false;
          drillListFromPlan = getPlanInfoResponse.data;
          drillListFromPlan.forEach((element) {
            drillIdList.add(element.drillid);
            print(
                '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>plan drill list>>>>>>>>>>>>>>>>>>>>' +
                    element.title);
          });
        });
      }
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
    }
  }

  void deletePlanApiCall(String planId) async {
    print(
        '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>plan Delete from list>>>>>>>>>>>>>>>>>>>>' +
            planId);
    setState(() {
      _isInAsyncCall = true;
    });
    CommonSuccess response = await deletePlan(planId);

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
      widget.onCreatePlansPressed();
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text(
              'your plan was deleted',
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

      /*Toast.show("${message}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);*/
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      Toast.show("${message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  _closeItemPlan(BuildContext context, Drills item) {
    drillIdList.remove(item.drillid);

    String drillIds = drillIdList.join(', ');
    updatePlanApiCall(planId, userId, userName, controllerplanName.text,
            drillIds, "", controllerplanName.text.substring(0, 2), isbook)
        .then((value) => getPlanInfoApiCall(value.toString()))
        .onError((error, stackTrace) => Toast.show(
            "Unable to Delete Item From Plan", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM));
    drillIdList.clear();
  }

  _closeItem(BuildContext context, Drills item) {}

  Future<int> updatePlanApiCall(
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
      Toast.show("${message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      Toast.show("${message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    return response.data['NEW_PLAN_ID'];
  }
}

_onItemTap(
    BuildContext context, Drills item, List<Drills> drillList, String planId) {
  print("this is on tap item and index is " + item.title);

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TrainingOnGoing(
              drillItem: item, drillList: drillList, planId: planId)
          // builder: (context) => TrainingOnGoing()
          ));
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

_analysis(BuildContext context, Drills item) {
  print("reg this is on tap _analysis and index is " + item.title);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

_onItemTapPlan(
    BuildContext context, Drills item, List<Drills> drillList, String planId) {
  print("this is on tap item and index is " + item.title);

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TrainingOnGoing(
                drillItem: item,
                drillList: drillList,
                planId: planId,
              )
          // builder: (context) => TrainingOnGoing()
          ));
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

_analysisPlan(
    BuildContext context, Drills item, List<Drills> drillList, String planId) {
  print("plan version this is on tap _analysis and index is " + item.title);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TrainingOnGoing(
                drillItem: item,
                drillList: drillList,
                planId: planId,
                tabControllerIndex: 1,
              )
          // builder: (context) => TrainingOnGoing()
          ));
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      this.model, this.onItemTap, this.closeItem, this.analysis, this.itemIndex,
      {Key key})
      : super(key: key);

  final Drills model;
  final Function onItemTap;
  final Function closeItem;
  final Function analysis;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: Container(
          height: 130,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Column(
                        children: [
                          Text("Drill",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              )),
                          Text(
                              '${model.drillid != null ? (itemIndex + 1).toString() : '-'}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      )),
                    ),
                    Dash(
                        direction: Axis.vertical,
                        length: 83,
                        dashLength: 3,
                        dashColor: Colors.white),
                  ],
                ),
              ),
/* Material( // pause button (round)
                                borderRadius: BorderRadius.circular(50), // change radius size
                                color: Colors.blue, //button colour
                                child: InkWell(
                                  splashColor: Colors.blue[900], // inkwell onPress colour
                                  child: SizedBox(
                                    width: 35,height: 35, //customisable size of 'button'
                                    child: Icon(Icons.pause,color: Colors.white,size: 16,),
                                  ),
                                  onTap: () {}, // or use onPressed: () {}
                                ),
                              ),*/
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
                  child: Stack(
                    children: <Widget>[
                      Container(
                          child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 8.0, bottom: 8.0, right: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              model.title != null
                                                  ? model.title
                                                  : 'No title',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                          Text(
                                              model.drilldescription != null
                                                  ? model.drilldescription
                                                  : 'No description',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 0,
                                      child: GestureDetector(
                                          onTap: analysis,
                                          child: Container(
                                            width: 70,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                            ),
                                            child: Center(
                                              child: Text("Analysis",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'HelveticaNeue',
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ),
                                          )))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, right: 5.0, left: 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    child: CachedNetworkImage(
                                      imageUrl: model.thumbnail != null
                                          ? model.thumbnail
                                          : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                                      placeholder: (context, url) =>
                                          Transform.scale(
                                        scale: 0.2,
                                        child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                255, 237, 28, 36)),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Transform.scale(
                                        scale: 0.7,
                                        child: Icon(Icons.image,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                      Positioned(
                        child: GestureDetector(
                          onTap: closeItem,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 237, 28, 36),
                                      border: Border.all(
                                        color: Color.fromARGB(255, 237, 28, 36),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 10),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class ItemPlanWidget extends StatelessWidget {
  const ItemPlanWidget(this.model, this.onItemTapPlan, this.closeItemPlan,
      this.analysisPlan, this.itemIndex,
      {Key key})
      : super(key: key);

  final Drills model;
  final Function onItemTapPlan;
  final Function closeItemPlan;
  final Function analysisPlan;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTapPlan,
      child: Container(
          height: 130,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Column(
                        children: [
                          Text("Drill",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              )),
                          Text(
                              '${model.drillid != null ? (itemIndex + 1).toString() : '-'}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      )),
                    ),
                    Dash(
                        direction: Axis.vertical,
                        length: 83,
                        dashLength: 3,
                        dashColor: Colors.white),
                  ],
                ),
              ),
/* Material( // pause button (round)
                                borderRadius: BorderRadius.circular(50), // change radius size
                                color: Colors.blue, //button colour
                                child: InkWell(
                                  splashColor: Colors.blue[900], // inkwell onPress colour
                                  child: SizedBox(
                                    width: 35,height: 35, //customisable size of 'button'
                                    child: Icon(Icons.pause,color: Colors.white,size: 16,),
                                  ),
                                  onTap: () {}, // or use onPressed: () {}
                                ),
                              ),*/
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
                  child: Stack(
                    children: <Widget>[
                      Container(
                          child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 8.0, bottom: 8.0, right: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              model.title != null
                                                  ? model.title
                                                  : 'No title',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                          Text(
                                              model.drilldescription != null
                                                  ? model.drilldescription
                                                  : 'No description',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 0,
                                      child: GestureDetector(
                                          onTap: analysisPlan,
                                          child: Container(
                                            width: 70,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                            ),
                                            child: Center(
                                              child: Text("Analysis",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'HelveticaNeue',
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ),
                                          )))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, right: 5.0, left: 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    child: CachedNetworkImage(
                                      imageUrl: model.thumbnail != null
                                          ? model.thumbnail
                                          : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                                      placeholder: (context, url) =>
                                          Transform.scale(
                                        scale: 0.2,
                                        child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                255, 237, 28, 36)),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Transform.scale(
                                        scale: 0.7,
                                        child: Icon(Icons.image,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                      Positioned(
                        child: GestureDetector(
                          onTap: closeItemPlan,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 237, 28, 36),
                                      border: Border.all(
                                        color: Color.fromARGB(255, 237, 28, 36),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 10),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
