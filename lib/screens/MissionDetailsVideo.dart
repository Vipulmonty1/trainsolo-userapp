import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/videoplayer/vimeoplayer.dart';

class MissionDetailsVideo extends StatefulWidget {
  final String videoID;
  final String logo;

  MissionDetailsVideo({@required this.videoID, this.logo});

  MissionDetailsVideoPage createState() => MissionDetailsVideoPage();
}

class MissionDetailsVideoPage extends State<MissionDetailsVideo> {
  bool timerStarted = false;
  Timer t;

  Drills nextElem;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
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
      body: VimeoPlayer(
          id: widget.videoID,
          looping: true,
          autoPlay: false,
          thumbNail: widget.logo,
          key: Key(widget.videoID)),
    );
  }

  void stopTimer() {
    timerStarted = false;
    if (t != null) {
      t.cancel();
    }
    setState(() {});
  }
}
