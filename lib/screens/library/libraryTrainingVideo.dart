import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trainsolo/model/get_videos_by_category_response.dart';
import 'package:trainsolo/videoplayer/vimeoplayer.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

// ignore: must_be_immutable
class LibraryTrainingVideo extends StatefulWidget {
  final VideoData videoData;
  final List<VideoData> videoDataList;
  final String videoID;
  Function onPressed;
  LibraryTrainingVideo(
      {@required this.videoData,
      this.videoDataList,
      this.videoID,
      this.onPressed});

  TrainingOnGoingPage createState() => TrainingOnGoingPage();
}

class TrainingOnGoingPage extends State<LibraryTrainingVideo> {
  int _duration = 0;
  bool timerStarted = false;
  Timer t;

  VideoData nextElem;

  @override
  void initState() {
    print("vimeo is is " + '${widget.videoData}');
    super.initState();
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
            /* Text(_videoTitle),*/
            VimeoPlayer(
              id: widget.videoID,
              autoPlay: false,
              key: Key(widget.videoID),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ROUND:${widget.videoData.rounds ?? "-"}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.w400,
                    )),
                SizedBox(
                  width: 40,
                ),
                Text("REPS:${widget.videoData.reps ?? "-"}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.w400,
                    ))
              ],
            ),
            SizedBox(
              height: 14,
            ),
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

//buttom button
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      print("Previous video: ${widget.videoData.videotitle}");
                      Amplitude.getInstance(
                              instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                          .logEvent("Library Training Previous Video Clicked",
                              eventProperties: {
                            "drill_name": widget.videoData.videotitle,
                            "drill_library_id": widget.videoData.libid,
                            "drill_rounds": widget.videoData.rounds,
                            "drill_reps": widget.videoData.reps
                          });
                      widget.onPressed(false);
                      if (mounted) {
                        setState(() {});
                      }
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
                          print("Timer video: ${widget.videoData.videotitle}");
                          Amplitude.getInstance(
                                  instanceName:
                                      Constants.AMPLITUDE_INSTANCE_NAME)
                              .logEvent("Library Training Timer Stop Clicked",
                                  eventProperties: {
                                "drill_name": widget.videoData.videotitle,
                                "drill_library_id": widget.videoData.libid,
                                "drill_rounds": widget.videoData.rounds,
                                "drill_reps": widget.videoData.reps
                              });
                          stopTimer();
                        } else {
                          print("Timer video: ${widget.videoData.videotitle}");
                          Amplitude.getInstance(
                                  instanceName:
                                      Constants.AMPLITUDE_INSTANCE_NAME)
                              .logEvent("Library Training Timer Start Clicked",
                                  eventProperties: {
                                "drill_name": widget.videoData.videotitle,
                                "drill_library_id": widget.videoData.libid,
                                "drill_rounds": widget.videoData.rounds,
                                "drill_reps": widget.videoData.reps
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
                      print("Next video: ${widget.videoData.videotitle}");
                      Amplitude.getInstance(
                              instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                          .logEvent("Library Training Next Video Clicked",
                              eventProperties: {
                            "drill_name": widget.videoData.videotitle,
                            "drill_library_id": widget.videoData.libid,
                            "drill_rounds": widget.videoData.rounds,
                            "drill_reps": widget.videoData.reps
                          });
                      widget.onPressed(true);
                      if (mounted) {
                        setState(() {});
                      }
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
    if (mounted) {
      setState(() {});
    }
  }

  void startTimer() {
    timerStarted = true;
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      _duration++;

      // if (_duration == 10000) {
      //   _duration = 0;
      //   timerStarted = false;
      //   t.cancel();
      // }
      if (mounted) {
        setState(() {});
      }
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
