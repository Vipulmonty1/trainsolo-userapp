import 'package:flutter/material.dart';
import 'package:trainsolo/screens/CreateGroup.dart';
import 'package:trainsolo/screens/LeaderBoard.dart';
import 'package:trainsolo/screens/MyPlansSaved.dart';

class MyPlans extends StatefulWidget {
  MyPlansPage createState() => MyPlansPage();
}

class MyPlansPage extends State<MyPlans> {
  bool isCreatePlan = false;
  bool isCreateTeams = false;
  int initalIndex = 0;

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initalIndex,
      child: Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: Colors.black,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new TabBar(
                      isScrollable: true,
                      labelStyle: TextStyle(fontSize: 25.0),
                      unselectedLabelStyle: TextStyle(fontSize: 20.0),
                      indicatorColor: Color.fromARGB(255, 237, 28, 36),
                      indicatorWeight: 2.0,
                      tabs: <Widget>[
                        Tab(
                          child: Container(
                            child: Text(
                              "MY PLANS",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            child: Text(
                              "LEADERBOARD",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            child: Text(
                              "TEAMS",
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
                  ],
                ),
              ),
            ),
          ),
          body: Container(
              color: Colors.black,
              /*decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: ExactAssetImage('assets/splash.png'),
                  fit: BoxFit.fill,
                ),
              ),*/
              child: TabBarView(
                children: <Widget>[
                  MyPlansSaved(),
                  LeaderBoard(),
                  CreateGroup(),
                ],
              ))),
    );
  }

  setData() async {}
}
