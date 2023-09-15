import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/training_complete_info.dart';
import 'package:trainsolo/screens/TrainingOnGoingComplete.dart';
import 'package:trainsolo/screens/TrainingVideo.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

// ignore: must_be_immutable
class TrainingOnGoing extends StatefulWidget {
  Drills drillItem;
  final List<Drills> drillList;
  String planId;
  int tabControllerIndex;
  TrainingOnGoing(
      {@required this.drillItem,
      this.drillList,
      this.planId,
      this.tabControllerIndex = 0});
  TrainingOnGoingPage createState() => TrainingOnGoingPage();
}

class TrainingOnGoingPage extends State<TrainingOnGoing>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  DateTime startTime = DateTime.now();
  DateTime endTime;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(
        length: 2, vsync: this, initialIndex: widget.tabControllerIndex);
    // _controller.addListener(() {
    //   print('my index is' + _controller.index.toString());
    //   // if (_controller.index == 1) {
    //   //   Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
    //   //       .logEvent(
    //   //           "Training Training Ongoing Gameplay Clicked Half This Event",
    //   //           eventProperties: {
    //   //         "drill_name": widget.drillItem.title,
    //   //         "drill_rest": widget.drillItem.durations,
    //   //         "drill_rounds": widget.drillItem.roundrequired,
    //   //         "drill_reps": widget.drillItem.repsrequired
    //   //       });
    //   // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    print("IN THE TRAINING ON GOING PAGE>>>>>>>>>>>>>>" +
        '${widget.drillItem.vimeoid}');
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new ListView(
        children: <Widget>[
          Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text("TRAINING ONGOING",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'BebasNeue',
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      InkWell(
                        child: Container(
                          width: 40,
                          padding: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Icon(Icons.close,
                                color: Colors.white, size: 30),
                          ),
                        ),
                        onTap: () {
                          Amplitude.getInstance(
                                  instanceName:
                                      Constants.AMPLITUDE_INSTANCE_NAME)
                              .logEvent("Training Training Ongoing Exited",
                                  eventProperties: {
                                "drill_name": widget.drillItem.title,
                                "drill_rest": widget.drillItem.durations,
                                "drill_rounds": widget.drillItem.roundrequired,
                                "drill_reps": widget.drillItem.repsrequired
                              });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0, top: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                          "drill ${widget.drillList.indexOf(widget.drillItem) + 1}/${widget.drillList.length}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontSize: 16,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          )),
                      SizedBox(height: 8),
                      Text(widget.drillItem.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          )),
                      ReadMoreText(widget.drillItem.drilldescription,
                          trimLines: 3,
                          textAlign: TextAlign.left,
                          colorClickableText: Color.fromARGB(255, 237, 28, 36),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'HelveticaNeue',
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
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
          ),
          new Container(
            decoration: new BoxDecoration(color: Colors.black),
            child: new TabBar(
              controller: _controller,
              labelStyle: TextStyle(fontSize: 25.0),
              unselectedLabelStyle: TextStyle(fontSize: 20.0),
              indicatorColor: Color.fromARGB(255, 237, 28, 36),
              indicatorWeight: 3.0,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                new Tab(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "Lesson",
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
                      "GamePlay",
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
          new Container(
            height: 500,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                TrainingVideo(
                  drillItem: widget.drillItem ?? null,
                  drillList: widget.drillList ?? null,
                  videoID: widget.drillItem.vimeoid ?? null,
                  onPressed: (bool next) {
                    onPressNextPrevious(next);
                  },
                ),
                TrainingVideo(
                    drillItem: widget.drillItem ?? null,
                    drillList: widget.drillList ?? null,
                    videoID: widget.drillItem.matchanalysisid ??
                        widget.drillItem.vimeoid,
                    onPressed: (bool next) {
                      onPressNextPrevious(next);
                    },
                    ma: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onPressNextPrevious(bool next) {
    endTime = DateTime.now();
    int i = widget.drillList.indexOf(widget.drillItem);

    if (i >= 0 && i < widget.drillList.length) {
      updatePractiseData(widget.planId, widget.drillItem.drillid, startTime,
          endTime, widget.drillItem.recid);
    }

    if (next && i <= widget.drillList.length) {
      i++;
    } else if (i >= 0) {
      i--;
    }

    widget.drillItem = widget.drillList[i];

    setState(() {
      startTime = DateTime.now();
      print("IN THE TRAINING ON GOING PAGE>>>>>>>>INSIDE CALL>>>>>>" +
          '${widget.drillItem.vimeoid}');
    });
  }

  void updatePractiseData(String planId, int drillId, DateTime startDate,
      DateTime endDate, int recId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    if (userdata != null) {
      final jsonResponse = json.decode(userdata);
      LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);

      TrainingCompleteInfo response = await addingUserPractiseDuration(
        loginResponse.data.user.userId.toString(),
        loginResponse.data.user.username,
        drillId,
        planId,
        recId,
        startDate,
        endDate,
      );

      if (response.status == "true") {
        if (response.data != null && response.data.length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TrainingOnGoingComplete(response.data.first)));
        }
      } else {}
    }
  }
}
