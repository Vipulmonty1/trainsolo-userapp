import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/controllers/vimeo_player_controller.dart';
import 'package:trainsolo/model/chart_response.dart';
import 'package:trainsolo/model/fitness_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/vimeo_player_flags.dart';

import 'package:trainsolo/utils/Constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:trainsolo/videoplayer/vimeoplayer.dart';
import 'package:trainsolo/videoplayernofullscreen/vimeoplayer.dart';

class FitnessTestRecordProgrss extends StatefulWidget {
  final FitnessData fitnessItems;

  FitnessTestRecordProgrss({@required this.fitnessItems});

  @override
  FitnessTestRecordProgrssState createState() =>
      FitnessTestRecordProgrssState();
}

class FitnessTestRecordProgrssState extends State<FitnessTestRecordProgrss> {
  bool _isInAsyncCall = false;
  VimeoPlayerController controller;
  bool _playerReady = false;
  // ignore: unused_field
  String _videoTitle;
  String _videoId = "";
  // ignore: unused_field
  int _itemCount = 10;
  // ignore: unused_field
  int _textvalueduration;

  List<ChartDataList> chartdata = [
    new ChartDataList(0, 0),
  ];
  // ignore: unused_element
  Widget _chartWidget() {
    List<charts.Series<ChartDataList, int>> seriesList = [
      new charts.Series<ChartDataList, int>(
        id: widget.fitnessItems.name,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (ChartDataList sales, _) => sales.index,
        measureFn: (ChartDataList sales, _) => sales.val,
        data: chartdata,
      )
    ];

    var chart = new charts.LineChart(
      seriesList,
      animate: true,
      behaviors: [
        new charts.SeriesLegend(
          //The legend positions are start on the left and end on the right
          position: charts.BehaviorPosition.top,
          //If the legend entry [horizo ntalfirst] is set to false, the legend entry will grow first as a new row rather than as a new column
          horizontalFirst: false,
          //Padding around each legend entry
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          //Show metrics
          showMeasures: true,
          //Measurement format
          measureFormatter: (num value) {
            return value == null ? '-' : '${value}k';
          },
        ),
      ],
    );

    return new Card(
      child: Container(
        padding: new EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(5.0),
              child: new SizedBox(
                height: 240.0,
                child: chart,
              ),
            ),
            new Center(
              child: new Text(
                'LEVELS',
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1.0), // opacity: opacity
                  fontFamily: 'PingFangBold',
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _videoId = widget.fitnessItems.vimeoid;

    getChartData();
  }

  void getChartData() async {
    setState(() {
      _isInAsyncCall = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    String userId, userName;
    if (loginResponse.data != null) {
      userId = loginResponse.data.user.userId.toString();
      userName = loginResponse.data.user.username.toString();
    }

    ChartResponse fitnessData = await generateFitnessChart(userId, userName);
    //print("Chart Data " + fitnessData.data.toString());
    List<ChartDataList> chData = [];

    /// /fitness/generateChart
    ///
    ///
    if (fitnessData.status == "true") {
      _isInAsyncCall = false;
      int i = 1;
      chData.clear();
      chartdata.clear();
      chData.add(new ChartDataList(0, 0));
      fitnessData.data.forEach((ele) {
        //chData.add(ele.);
        if (ele.testname == widget.fitnessItems.name) {
          chData.add(new ChartDataList(i, int.parse(ele.level.toString())));
          i++;
        }
        //print("F >>>>>>>>>>>>" + ele.level.toString());
      });
      setState(() {
        chartdata = chData;
      });
    } else {
      _isInAsyncCall = false;

      Toast.show("${fitnessData.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        child: getBody(),
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: size.height - 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 280,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: SizedBox.expand(
                          child: FittedBox(
                            child: CachedNetworkImage(
                              imageUrl: widget.fitnessItems.setupimagename !=
                                      null
                                  ? Constants.IMAGE_BASE_URL +
                                      "/images/" +
                                      widget.fitnessItems.setupimagename
                                  : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                              placeholder: (context, url) => Transform.scale(
                                scale: 0.2,
                                child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 237, 28, 36)),
                              ),
                              errorWidget: (context, url, error) =>
                                  Transform.scale(
                                scale: 0.7,
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.85),
                              Colors.black.withOpacity(0.0)
                            ],
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter),
                      ),
                    ),
                    Container(
                      height: 280,
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /* Image.asset("assets/images/titulo_1.webp", width: 300,),*/ // this is for any text or image show on profile pic for that use
                          Container(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 10, // 60%
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            widget.fitnessItems.name ??
                                                "FITNESS TEST",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontFamily: 'BebasNeue',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 8, top: 10.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Training video',
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontSize: 20,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.all(1),
                  child: Container(
                      height: 260,
                      width: double.infinity,
                      margin: const EdgeInsets.all(1),
                      child: Column(
                        children: [
                          //Text(_videoTitle??"No Title"),
                          VimeoPlayerNoFullScreen(
                            id: _videoId,
                            autoPlay: false,
                            looping: true,
                            key: Key(_videoId),
                          ),

                          // Text(_videoTitle + (controller.value.isBuffering ? " Buffering" : controller.value.isPlaying ? " Playing" : " Ready!") ),
                        ],
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 8, top: 10.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Records',
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontSize: 20,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 8, top: 10.0, bottom: 10.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.fitnessItems.explanation,
                          textAlign: TextAlign.left,
                          maxLines: 300,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'HelveticaNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back,
                                  size: 28, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setVideo(String id) {
    print("this is on tap+++++++++++++++++++++++++++" + id.toString());
    _videoTitle = 'Loading...';
    _textvalueduration = 00;
    controller =
        VimeoPlayerController(initialVideoId: id, flags: VimeoPlayerFlags())
          ..addListener(listener);
  }
}
