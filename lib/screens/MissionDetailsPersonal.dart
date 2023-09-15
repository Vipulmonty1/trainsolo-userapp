import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/mission_list_response.dart';

class MissionDetailsPersonal extends StatefulWidget {
  final String videoID;
  final MissonListData missioninfo;
  MissionDetailsPersonal({@required this.videoID, this.missioninfo});

  MissionDetailsPersonalPage createState() => MissionDetailsPersonalPage();
}

class MissionDetailsPersonalPage extends State<MissionDetailsPersonal> {
  bool timerStarted = false;
  Timer t;

  Drills nextElem;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    print("didUpdateWidget  is is :::::::::::::::::::::::::::::::" +
        '${widget.videoID}');

    if (widget != oldWidget) {}

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double _value = 5.0;
    return Scaffold(
      backgroundColor: Colors.black,
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Your contribution',
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        style: TextStyle(
                          color: Color.fromARGB(255, 237, 28, 36),
                          fontSize: 20,
                          fontFamily: 'BebasNeue',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                            widget.missioninfo.usersessionscnt != 0
                                ? (widget.missioninfo.usersessionscnt *
                                            100 /
                                            widget.missioninfo.personsessions)
                                        .toString() +
                                    " %"
                                : "0 %",
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ),
                  ],
                )),
            SfSliderTheme(
              data: SfSliderThemeData(
                activeTrackHeight: 8.0,
                inactiveTrackHeight: 8.0,
                trackCornerRadius: 5,
                overlayColor: Colors.transparent,
                activeDividerRadius: 1,
                thumbColor: Colors.transparent,
                activeTrackColor: Color.fromARGB(255, 237, 28, 36),
                inactiveTrackColor: Colors.white,
              ),
              child: SfSlider(
                min: 0,
                max: widget.missioninfo.sessiontocomplete == 0
                    ? widget.missioninfo.totalmissionsession
                    : widget.missioninfo.sessiontocomplete,
                value: widget.missioninfo.usersessionscnt,
                onChanged: (dynamic newValue) {
                  setState(() {
                    _value = newValue;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Text(
                  widget.missioninfo.usersessionscnt.toString() +
                      " / " +
                      widget.missioninfo.personsessions.toString() +
                      " sessions contributed",
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w700,
                  )),
            ),
            SizedBox(
              height: 14,
            ),

          ],
    ),);
  }

  void stopTimer() {
    timerStarted = false;
    if (t != null) {
      t.cancel();
    }
    setState(() {});
  }
}
