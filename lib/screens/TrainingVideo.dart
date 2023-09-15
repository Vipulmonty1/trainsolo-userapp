import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/videoplayer/vimeoplayer.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

// ignore: must_be_immutable
class TrainingVideo extends StatefulWidget {
  final Drills drillItem;
  final List<Drills> drillList;
  final String videoID;
  Function onPressed;
  bool ma;
  TrainingVideo(
      {@required this.drillItem,
      this.drillList,
      this.videoID,
      this.onPressed,
      this.ma = false});

  TrainingOnGoingPage createState() => TrainingOnGoingPage();
}

class TrainingOnGoingPage extends State<TrainingVideo> {
  int _duration = 60;
  bool timerStarted = false;
  Timer t;

  Drills nextElem;

  @override
  void initState() {
    // _duration = widget.drillItem.durations;
    if (widget.ma) {
      print("MA video loaded");
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Training Training Ongoing Match Analysis Video Loaded",
              eventProperties: {
            "drill_name": widget.drillItem.title,
            "drill_rest": widget.drillItem.durations,
            "drill_rounds": widget.drillItem.roundrequired,
            "drill_reps": widget.drillItem.repsrequired
          });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    print("didUpdateWidget  is is :::::::::::::::::::::::::::::::" +
        '${widget.drillItem}');
    _duration = 60;
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            VimeoPlayer(
                id: widget.videoID, autoPlay: false, key: Key(widget.videoID)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ROUNDS:${widget.drillItem.roundrequired}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.w400,
                    )),
                SizedBox(
                  width: 40,
                ),
                Text("REPS:${widget.drillItem.repsrequired}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.w400,
                    ))
              ],
            ),
            // SizedBox(
            //   height: 1,
            // ),
            Text("REST",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'BebasNeue',
                  fontWeight: FontWeight.w400,
                )),
            Container(
              width: 70,
              height: 2,
              color: Color.fromARGB(255, 237, 28, 36),
            ),
            SizedBox(
              height: 13,
            ),
            /*  Text(_videoTitle + (controller.value.isBuffering ? " Buffering" : controller.value.isPlaying ? " Playing" : " Ready!") ),*/

            Text(_getTimestamp(_duration),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontFamily: 'BebasNeue',
                  fontWeight: FontWeight.w400,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      // ignore: unnecessary_statements
                      Amplitude.getInstance(
                              instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                          .logEvent(
                              "Training Training Ongoing Previous Video Clicked",
                              eventProperties: {
                            "drill_name": widget.drillItem.title,
                            "drill_rest": widget.drillItem.durations,
                            "drill_rounds": widget.drillItem.roundrequired,
                            "drill_reps": widget.drillItem.repsrequired
                          });
                      stopTimer;
                      widget.onPressed(false);
                    },
                    child: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 40,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        // timerStarted ? stopTimer() : startTimer();
                        if (timerStarted) {
                          Amplitude.getInstance(
                                  instanceName:
                                      Constants.AMPLITUDE_INSTANCE_NAME)
                              .logEvent(
                                  "Training Training Ongoing Timer Stop Clicked",
                                  eventProperties: {
                                "drill_name": widget.drillItem.title,
                                "drill_rest": widget.drillItem.durations,
                                "drill_rounds": widget.drillItem.roundrequired,
                                "drill_reps": widget.drillItem.repsrequired
                              });
                          stopTimer();
                        } else {
                          Amplitude.getInstance(
                                  instanceName:
                                      Constants.AMPLITUDE_INSTANCE_NAME)
                              .logEvent(
                                  "Training Training Ongoing Timer Start Clicked",
                                  eventProperties: {
                                "drill_name": widget.drillItem.title,
                                "drill_rest": widget.drillItem.durations,
                                "drill_rounds": widget.drillItem.roundrequired,
                                "drill_reps": widget.drillItem.repsrequired
                              });
                          startTimer();
                        }
                      },
                      child: Icon(
                        timerStarted ? Icons.timer_off : Icons.timer,
                        color: Colors.white,
                        size: 50,
                      ),
                      backgroundColor: Color.fromARGB(255, 237, 28, 36),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Amplitude.getInstance(
                              instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                          .logEvent(
                              "Training Training Ongoing Next Drill Clicked",
                              eventProperties: {
                            "drill_name": widget.drillItem.title,
                            "drill_rest": widget.drillItem.durations,
                            "drill_rounds": widget.drillItem.roundrequired,
                            "drill_reps": widget.drillItem.repsrequired
                          });
                      stopTimer();
                      widget.onPressed(true);
                    },
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  String _getTimestamp(int duration) {
    var position =
        _printDuration(new Duration(seconds: (duration ?? 0).round()));

    return '$position';
  }

  void stopTimer() {
    timerStarted = false;
    if (t != null) {
      t.cancel();
    }
    setState(() {});
  }

  void startTimer() {
    timerStarted = true;
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      _duration--;

      print(_duration);
      if (_duration == 0) {
        _duration = widget.drillItem.durations;
        timerStarted = false;
        timer.cancel();
      }

      setState(() {});
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    var ret = '';

    String twoDigitHours = twoDigits(duration.inHours.remainder(60));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (twoDigitHours != '00') {
      ret += '$twoDigitHours:';
    }
    ret += '$twoDigitMinutes:';
    ret += '$twoDigitSeconds';

    return ret == '' ? '0:00' : ret;
  }
}
