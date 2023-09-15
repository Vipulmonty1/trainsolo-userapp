import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:trainsolo/model/training_complete_info.dart';

class TrainingOnGoingComplete extends StatefulWidget {
  final trainingCompleteInfo tcompleteInfo;

  TrainingOnGoingComplete(this.tcompleteInfo);

  TrainingOnGoingCompletePage createState() => TrainingOnGoingCompletePage();
}

class TrainingOnGoingCompletePage extends State<TrainingOnGoingComplete> {
  var highschool_text = "Highschool";
  var college_text = "College";
  var other_text = "Other";

  void changeData() {
    setState(() {
      college_text = "College3";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Center(
            child: new ListView(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text("Training Complete",
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
                            Navigator.pop(context);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text("current streak",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w400,
                                ))),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 0.0, bottom: 5.0),
                            child: Text(
                              widget.tcompleteInfo.currentStreak.toString(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 70.0,
                                color: Colors.white,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Image.asset("assets/red_ball.png"),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 0.0, bottom: 5.0),
                            child: Text(
                              widget.tcompleteInfo.alltimeWorkouts.toString(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 70.0,
                                color: Colors.white,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("all-time workouts",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              )),
                        ),
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
                  height: 130,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  width: double.infinity,
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "POWER WORKOUT",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          //Use of SizedBox
                          height: 10,
                        ),
                        Text(
                          widget.tcompleteInfo.completedDate,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            fontFamily: 'HelveticaNeue',
                          ),
                        ),
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: double.infinity,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 0.0),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 5.0, top: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Session time",
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontFamily: 'BebasNeue',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 7.0),
                                        child: Divider(
                                          height: 10,
                                          thickness: 2,
                                          indent: 50,
                                          endIndent: 50,
                                          color:
                                              Color.fromARGB(255, 237, 28, 36),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, bottom: 5.0),
                                        child: Text(
                                          widget.tcompleteInfo.sessionTime,
                                          style: TextStyle(
                                            fontSize: 70.0,
                                            color: Colors.white,
                                            fontFamily: 'BebasNeue',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${widget.tcompleteInfo.globalAvgSessionTime}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontFamily: 'HelveticaNeue',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 0.0),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 5.0, top: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "DRILLS COMPLETED",
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontFamily: 'BebasNeue',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Divider(
                                          height: 10,
                                          thickness: 2,
                                          indent: 50,
                                          endIndent: 50,
                                          color:
                                              Color.fromARGB(255, 237, 28, 36),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, bottom: 5.0),
                                        child: Text(
                                          widget.tcompleteInfo.drillsCompleted
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 70.0,
                                            color: Colors.white,
                                            fontFamily: 'BebasNeue',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${widget.tcompleteInfo.globalAvgDrillsCompleted}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontFamily: 'HelveticaNeue',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  width: double.infinity,
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              'LEVEL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    bottom: 10.0,
                                    top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0,
                                              top: 8.0,
                                              bottom: 8.0,
                                              right: 0.0),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: SizedBox.expand(
                                                child: FittedBox(
                                                  child: Image.asset(
                                                      "assets/yellow_star.png"),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 45,
                                          left: 45,
                                          height: 43,
                                          width: 43,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, bottom: 0.0),
                                            child: Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Text(
                                                '${widget.tcompleteInfo.levelNo}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontFamily: 'BebasNeue',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      //Use of SizedBox
                                      height: 2,
                                    ),
                                    SfSliderTheme(
                                      data: SfSliderThemeData(
                                        activeTrackHeight: 10,
                                        inactiveTrackHeight: 10,
                                        trackCornerRadius: 5,
                                        overlayColor: Colors.transparent,
                                        activeDividerRadius: 1,
                                        activeDividerStrokeWidth: 20,
                                        thumbStrokeWidth: 10,
                                        thumbColor: Colors.transparent,
                                        activeTrackColor: Colors.yellow[800],
                                        inactiveTrackColor: Colors.white,
                                      ),
                                      child: SfSlider(
                                        min: 0.0,
                                        max: widget.tcompleteInfo.barForLevel,
                                        value: widget.tcompleteInfo.levelNo,
                                        onChanged: (dynamic newValue) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      //Use of SizedBox
                                      height: 2,
                                    ),
                                    Text(
                                        "${widget.tcompleteInfo.remainingLevelUpStr}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontFamily: 'HelveticaNeue',
                                          fontWeight: FontWeight.w400,
                                        )),
                                    SizedBox(
                                      //Use of SizedBox
                                      height: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
