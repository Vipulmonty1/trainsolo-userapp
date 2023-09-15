import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/chart_response.dart';
import 'package:trainsolo/model/fitness_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/get_users_response.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FitnessRecords extends StatefulWidget {
  final String title;
  FitnessRecords({@required this.title});
  FitnessRecordsPage createState() => FitnessRecordsPage();
}

class FitnessRecordsPage extends State<FitnessRecords> {
  final searchController = TextEditingController();
  bool _isInAsyncCall = false;
  List<FitnessData> fitnessList = [];
  List<ChartDataList> chartdata = [
    new ChartDataList(1, 15),
  ];

  void refresh() {
    setState(() {});
  }

  // ignore: unused_field
  List<bool> _isChecked;
  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    fetchAlbum();
  }

  Future<List<ChartDataList>> getChartData(String strName) async {
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

    List<ChartDataList> chData = [];
    if (fitnessData.status == "true") {
      _isInAsyncCall = false;
      int i = 1;
      chData.clear();
      chartdata.clear();
      chData.add(new ChartDataList(0, 0));
      fitnessData.data.forEach((ele) {
        //chData.add(ele.);
        if (ele.testname == strName) {
          chData.add(new ChartDataList(i, int.parse(ele.level.toString())));
          i++;
        }
      });
    } else {}
    chartdata = chData;
    return chartdata;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, size: 28, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      child: Text(
                        widget.title.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'BebasNeue',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: fitnessList.length,
                              // Number of widget to be created.
                              itemBuilder: (context, itemIndex) {
                                return Container(
                                  height: 330,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  width: double.infinity,
                                  child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, left: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                fitnessList[itemIndex].name,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                  fontFamily: 'BebasNeue',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0,
                                              top: 0.0,
                                              bottom: .0,
                                              right: 0.0),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                                bottom: 10.0),
                                            child: _chartWidget(
                                                fitnessList[itemIndex]
                                                    .name
                                                    .toString()),
                                          ),
                                        ),
                                      ]),
                                );
                              }),
                        ),
                      ],
                    ),
                  ))
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

  Widget _chartWidget(String strFitTestName) {
    List<charts.Series<ChartDataList, int>> seriesList = [
      // ignore: missing_required_param
      new charts.Series<ChartDataList, int>(
        id: strFitTestName,
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
                height: 200.0,
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

  fetchAlbum() async {
    setState(() {
      _isInAsyncCall = true;
    });

    FitnessResponse fitnessData = await getFitnessList();

    if (fitnessData.status == "true") {
      _isInAsyncCall = false;
      Toast.show("${fitnessData.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        fitnessList = fitnessData.data;
      });
    } else {
      _isInAsyncCall = false;

      Toast.show("${fitnessData.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  onChanged(BuildContext context, UsersData item) {
    print("this is on tap onChanged and index is " + item.username);
  }
}
