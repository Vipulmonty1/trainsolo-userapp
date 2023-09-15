import 'package:flutter/material.dart';

import 'package:trainsolo/screens/LeaderBoardGlobal.dart';
import 'package:trainsolo/screens/LeaderBoardTimeTrained.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

class LeaderBoard extends StatefulWidget {
  LeaderBoardPage createState() => LeaderBoardPage();
}

class LeaderBoardPage extends State<LeaderBoard>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("My Plans Page Leaderboard Tab Loaded");
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: TabBar(
                  indicatorColor: Color.fromARGB(255, 237, 28, 36),
                  indicatorWeight: 2.0,
                  isScrollable: true,
                  labelStyle: TextStyle(fontSize: 25.0),
                  //For Selected tab
                  unselectedLabelStyle: TextStyle(fontSize: 20.0),
                  tabs: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: new Text(
                          "GLOBAL",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: new Text(
                          "TIME TRAINED",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                    // Container(
                    //     margin: const EdgeInsets.only(bottom: 8.0),
                    //     child: new Text(
                    //       "FITNESS",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontFamily: 'BebasNeue',
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     )),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TabBarView(
              children: [
                LeaderBoardGlobal(pagename: "global"),
                LeaderBoardTimeTrained(pagename: "TimeTrained"),
                //LeaderBoardFitness(pagename: "fitness"),
                /*CommanPlanList(pagename: "fitness"),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
