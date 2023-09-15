import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/controllers/vimeo_player_controller.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/common_success.dart';
import 'package:trainsolo/model/vimeo_player_flags.dart';

import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:trainsolo/utils/CircleProgress.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/videoplayer/vimeoplayer.dart';
import 'package:trainsolo/videoplayernofullscreen/vimeoplayer.dart';
import '../api/api_service.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

class TechHubTimeTrial extends StatefulWidget {
  final Drills drillItem;
  final VoidCallback onBackCallback;
  TechHubTimeTrial({@required this.drillItem, this.onBackCallback});

  TechHubTimeTrialPage createState() => TechHubTimeTrialPage();
}

class TechHubTimeTrialPage extends State<TechHubTimeTrial>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation<double> animation;
  VimeoPlayerController controller;
  bool _playerReady = false;
  // ignore: unused_field
  String _videoTitle;
  // ignore: unused_field
  String _videoId = "567780291";
  bool _isInAsyncCall = false;
  int resetvalue = 99;
  // ignore: unused_field
  int _textvalueduration;
  // ignore: unused_field
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController dayController = TextEditingController()
    ..text = "May, 2 — May, 21";
  TextEditingController goalsController = TextEditingController()
    ..text = "10 Goals";
  String userId = "";
  String userName = "";
  String drillId = "0";
  getCurrentDate() {
    FocusScope.of(context).requestFocus(FocusNode());

    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2020, 1, 1),
        maxTime: DateTime(
          2050,
          12,
        ),
        theme: DatePickerTheme(
            headerColor: Color.fromARGB(255, 237, 28, 36),
            backgroundColor: Colors.black,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      setState(() {
        dayController = TextEditingController()
          ..text = date.toString().substring(0, 19);
        _displayTextInputDialog(context);
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  @override
  void initState() {
    setdata();
    _videoId = widget.drillItem.vimeoid;
    resetvalue = widget.drillItem.durations;
    progressController = AnimationController(
        vsync: this,
        duration:
            Duration(seconds: resetvalue != null ? resetvalue.toInt() : 0));
    if (resetvalue != null) {
      animation = Tween<double>(begin: resetvalue.toDouble(), end: 0)
          .animate(progressController)
            ..addListener(() {
              setState(() {
                if (animation.value == 0.0) {}
              });
            });

      startTimer();
    }
    super.initState();
  }

  void listener() async {
    if (_playerReady) {
      setState(() {
        // this._videoTitle = controller.value.videoTitle??'No title';
        this._textvalueduration = controller.value.videoPosition.round();
      });
    }
  }

  @override
  void dispose() {
    this.controller.removeListener(listener);
    this.controller.dispose();
    this.progressController.dispose();
    super.dispose();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'BebasNeue',
                        fontWeight: FontWeight.w400,
                      )),
                ),
                Expanded(
                  flex: 0,
                  child: Positioned(
                      child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Icon(Icons.close,
                                color: Colors.black, size: 10),
                          ),
                        )),
                  )),
                ),
              ],
            ),
            content: Container(
              child: Column(
                children: [
                  Container(
                    width: 320,
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: dayController,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BebasNeue',
                        fontWeight: FontWeight.w400,
                      ),
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'May, 2 — May, 21',
                        suffixStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'HelveticaNeue',
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'HelveticaNeue',
                        ),
                        suffixIcon: IconButton(
                          onPressed: getCurrentDate,
                          icon: Icon(Icons.calendar_today_outlined,
                              color: Colors.white),
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: 320,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        autocorrect: true,
                        controller: goalsController,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'BebasNeue',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Your Goals',
                          suffixIcon: Icon(TrainsoloIcons.football,
                              color: Colors.white),
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.transparent,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                        ),
                      )),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Row contents horizontally,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: FloatingActionButton.extended(
                          backgroundColor: Color.fromARGB(255, 237, 28, 36),
                          label: Text("Save"),
                          onPressed: () {
                            saveDataToTechHubApiCall(
                                context,
                                userId,
                                userName,
                                drillId,
                                dayController.text.toString(),
                                goalsController.text.toString());
                            //  Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                        ),
                      ),
                      SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: FloatingActionButton.extended(
                          backgroundColor: Color.fromARGB(255, 237, 28, 36),
                          label: Text("Share"),
                          onPressed: () {
                            //Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          );
        });
  }

  String codeDialog;
  String valueText;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 200,
                            child: Align(
                              alignment: Alignment.center,
                              child: CustomPaint(
                                foregroundPainter: CircleProgress(
                                    animation != null ? animation.value : 0),
                                // this will add custom painter after child
                                child: InkWell(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    child: Center(
                                        child: Text(
                                      "${animation != null ? animation.value.toInt() : 0}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  onTap: () {
                                    if (progressController.isAnimating) {
                                      progressController.stop(canceled: false);
                                      progressController.reset();
                                    } else {
                                      progressController.forward();
                                    }
                                    print(
                                        "tapped on container:::::::::::::::::::::::::::::::::::::::::::::::::::::");
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Align(
                              alignment: Alignment.center,
                              child: _buildCircle(context),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                      "Restart",
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
                                          instanceName:
                                              Constants.AMPLITUDE_INSTANCE_NAME)
                                      .logEvent(
                                          "Tech Hub Restart Button Clicked"),
                                  setState(() {
                                    if (progressController.isAnimating) {
                                      progressController.stop(canceled: false);
                                      progressController.reset();
                                      progressController.forward();
                                    } else {
                                      progressController.reset();
                                      progressController.forward();
                                    }
                                  }),
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.white)),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: ButtonTheme(
                          //     minWidth: 150.0,
                          //     height: 50.0,
                          //     // ignore: deprecated_member_use
                          //     child: RaisedButton(
                          //       textColor: Colors.black,
                          //       color: Colors.grey,
                          //       child: new Column(
                          //         children: [
                          //           Text(
                          //             "Setup & Advice",
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 14,
                          //               fontFamily: 'HelveticaNeue',
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       onPressed: () => {
                          //         setState(() {}),
                          //       },
                          //       shape: new RoundedRectangleBorder(
                          //           borderRadius:
                          //               new BorderRadius.circular(8.0),
                          //           side: BorderSide(color: Colors.white)),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: VimeoPlayerNoFullScreen(
                                                  id: _videoId,
                                                  autoPlay: false,
                                                  looping: true,
                                                  key: Key(_videoId),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          0.0),
                                                              child: Text(
                                                                  widget.drillItem
                                                                              .title !=
                                                                          null
                                                                      ? widget
                                                                          .drillItem
                                                                          .title
                                                                      : 'No title',
                                                                  maxLines: 2,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'HelveticaNeue',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  )),
                                                            ),
                                                            Text(
                                                                widget.drillItem
                                                                            .drilldescription !=
                                                                        null
                                                                    ? widget
                                                                        .drillItem
                                                                        .drilldescription
                                                                    : '',
                                                                maxLines: 200,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'HelveticaNeue',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      /*Expanded(
                                                        flex: 0,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 4.0),
                                                          //icon for share and save  list
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              7.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        _save,
                                                                    child: Icon(
                                                                      Icons
                                                                          .description,
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            7.0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      _shareItem,
                                                                  child: Icon(
                                                                    TrainsoloIcons
                                                                        .share,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 24.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )*/
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 0.0,
                                                          bottom: 0.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child:
                                                                    IconButton(
                                                                  icon:
                                                                      Container(
                                                                    width: 20,
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/medal_first.png"),
                                                                            fit: BoxFit.cover)),
                                                                  ),
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                /* Icon(
                                                Icons.admin_panel_settings,
                                                color: Colors.white),*/
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child: Text(
                                                                    widget.drillItem.bronze !=
                                                                            null
                                                                        ? widget.drillItem.bronze.toString() +
                                                                            "+"
                                                                        : '0',
                                                                    maxLines: 2,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'HelveticaNeue',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    )),
                                                              ),
                                                            ],
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child:
                                                                    IconButton(
                                                                  icon:
                                                                      Container(
                                                                    width: 20,
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/medal_second.png"),
                                                                            fit: BoxFit.cover)),
                                                                  ),
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                /* Icon(
                                                Icons.admin_panel_settings,
                                                color: Colors.white),*/
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Text(
                                                                    widget.drillItem.silver !=
                                                                            null
                                                                        ? widget.drillItem.silver.toString() +
                                                                            "+"
                                                                        : '0',
                                                                    maxLines: 2,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'HelveticaNeue',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    )),
                                                              ),
                                                            ],
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child:
                                                                    IconButton(
                                                                  icon:
                                                                      Container(
                                                                    width: 20,
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/medal_thired.png"),
                                                                            fit: BoxFit.cover)),
                                                                  ),
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                /* Icon(
                                                Icons.admin_panel_settings,
                                                color: Colors.white),*/
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Text(
                                                                    widget.drillItem.gold !=
                                                                            null
                                                                        ? widget.drillItem.gold.toString() +
                                                                            "+"
                                                                        : '0',
                                                                    maxLines: 2,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'HelveticaNeue',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    )),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        size: 28, color: Colors.white),
                                    onPressed: () {
                                      //widget.onBackCallback();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    "Time Trial",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'BebasNeue',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                  // profile image on top if we want to show on top profile image
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
      ),
    );
  }

  void startTimer() async {
    if (animation.value == 100) {
      progressController.reverse();
    } else {
      progressController.forward();
    }
  }

  // ignore: missing_return
  Future<String> setdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      userId = loginResponse.data.user.userId.toString();
      userName = loginResponse.data.user.username.toString();
      print(
          "::::::::::::::::::::::::::::::::::::::::userId:::::::::::::::::::" +
              loginResponse.data.user.userId.toString());
      print(
          "::::::::::::::::::::::::::::::::::::::::username:::::::::::::::::::" +
              loginResponse.data.user.username.toString());
    }
    print("About to set drill id ...");
    drillId = widget.drillItem.drillid != null
        ? widget.drillItem.drillid.toString()
        : "0";
    print("Drill id:$drillId");
    print("About to set vimeo id");
    var id = widget.drillItem.vimeoid;
    print("Vimeo id:$id");
    setVideo(id);
  }

  void setVideo(String id) {
    _videoTitle = 'Loading...';
    _textvalueduration = 00;
    print("About to instantiate VimeoPlayerController");
    controller = VimeoPlayerController(
        initialVideoId: id.toString(), flags: VimeoPlayerFlags())
      ..addListener(listener);
  }

  void _shareItem() {}
  void _save() {}
  // ignore: unused_element
  void _taptoRecord() {}
  saveDataToTechHubApiCall(BuildContext context, String userid, String username,
      String drillid, String date, String goals) async {
    CommonSuccess apiResponse =
        await saveDataToTechHub(userid, username, drillid, date, goals);
    setState(() {
      _isInAsyncCall = true;
    });
    if (apiResponse.status == "true") {
      _isInAsyncCall = false;
      // print('not null' + registrationresponse.message);
      Toast.show("${apiResponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      Navigator.pop(context);
      widget.onBackCallback();
    } else {
      _isInAsyncCall = false;
      //print('null'+registrationresponse.message);
      Toast.show("${apiResponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      Navigator.pop(context);
    }
  }
}

Widget _buildCircle(BuildContext context) {
  return SizedBox(
    width: 160,
    height: 160,
    child: CustomPaint(
      painter: CirclePainter(),
    ),
  );
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 4
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
