import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:readmore/readmore.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:trainsolo/model/mission_list_response.dart';
import 'package:trainsolo/screens/MissionDetailsPersonal.dart';
import 'package:trainsolo/screens/MissionDetailsVideo.dart';
import 'package:trainsolo/videoplayer/vimeoplayer.dart';

class MissionDetails extends StatefulWidget {
  final MissonListData missioninfo;
  final int tabIndex;

  const MissionDetails({@required this.missioninfo, this.tabIndex});

  MissionDetailsPage createState() => MissionDetailsPage();
}

class MissionDetailsPage extends State<MissionDetails>
    with SingleTickerProviderStateMixin {
  bool _isInAsyncCall = false;
  TabController _controller;
  MissonListData missioninfo;
  bool bookmark = false;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _controller.index = this.widget.tabIndex;
    //getPersonalStatsApiCall();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double _value = 5.0;
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: new Text(
          "Mission Details",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'BebasNeue',
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: new IconButton(
          icon: Icon(Icons.arrow_back, size: 28, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 25, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    color: Colors.white,
                    child: Image.network(
                      widget.missioninfo != null ? widget.missioninfo.logo : "",
                      height: 132,
                      width: 332,
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(widget.missioninfo.name,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w400,
                    )),
                ReadMoreText(widget.missioninfo.desc,
                    trimLines: 20,
                    textAlign: TextAlign.left,
                    colorClickableText: Color.fromARGB(255, 237, 28, 36),
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w200,
                    )),
                SizedBox(
                  height: 16,
                ),
                Text(
                    widget.missioninfo.sessiontocomplete.toString() +
                        " / " +
                        widget.missioninfo.totalmissionsession.toString() +
                        " Sessions Contributed - Community Objective",
                    maxLines: 3,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w400,
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
                    min: 0.0,
                    max: widget.missioninfo.totalmissionsession,
                    value: widget.missioninfo.sessiontocomplete == 0
                        ? 0.0
                        : widget.missioninfo.sessiontocomplete,
                    onChanged: (dynamic newValue) {
                      setState(() {
                        _value = newValue;
                      });
                    },
                  ),
                ),
                Text(
                    widget.missioninfo.contributors.toString() +
                        " Contributors",
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w400,
                    )),
                SizedBox(
                  height: 24,
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                TabBar(
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
                          "Details",
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
                          "PERSONAL",
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
                Container(
                  height: 225,
                  child: TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      MissionDetailsVideo(
                          videoID: widget.missioninfo.mediaurl,
                          logo: widget.missioninfo.logo),
                      // VimeoPlayer(id: id),
                      MissionDetailsPersonal(
                          videoID: "0", missioninfo: widget.missioninfo)
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
    //         Column(
    //           children: [
    //             Container(
    //               decoration: new BoxDecoration(color: Colors.black),
    //               child: new TabBar(
    //                 controller: _controller,
    //                 labelStyle: TextStyle(fontSize: 25.0),
    //                 unselectedLabelStyle: TextStyle(fontSize: 20.0),
    //                 indicatorColor: Color.fromARGB(255, 237, 28, 36),
    //                 indicatorWeight: 3.0,
    //                 indicatorSize: TabBarIndicatorSize.label,
    //                 tabs: [
    //                   new Tab(
    //                     child: Container(
    //                       margin: const EdgeInsets.only(bottom: 5.0),
    //                       child: Text(
    //                         "Details",
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontFamily: 'BebasNeue',
    //                           fontWeight: FontWeight.w400,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   new Tab(
    //                     child: Container(
    //                       margin: const EdgeInsets.only(bottom: 5.0),
    //                       child: Text(
    //                         "PERSONAL",
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontFamily: 'BebasNeue',
    //                           fontWeight: FontWeight.w400,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //         Flexible(
    //           flex: 1,
    //           child: Container(
    //             height: 400,
    //             color: Colors.black,
    //             width: double.infinity,
    //             child: TabBarView(
    //               controller: _controller,
    //               children: <Widget>[
    //                 MissionDetailsVideo(videoID: widget.missioninfo.mediaurl, logo: widget.missioninfo.logo),
    //                 MissionDetailsPersonal(
    //                     videoID: "0", missioninfo: widget.missioninfo)
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     inAsyncCall: _isInAsyncCall,
    //     color: Colors.black,
    //     opacity: 0.5,
    //     progressIndicator: CircularProgressIndicator(
    //       color: Color.fromARGB(255, 237, 28, 36),
    //     ),
    //   ),
    // ),
    // );
  }
}
