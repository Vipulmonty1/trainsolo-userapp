import 'package:flutter/material.dart';
import 'package:trainsolo/screens/TechHub.dart';
import 'package:trainsolo/screens/TrainFitness.dart';
import 'TrainingPlan.dart';

class Train extends StatefulWidget {
  final VoidCallback onCreatplanPress;
  Train({@required this.onCreatplanPress});
  TrainPage createState() => TrainPage();
}

class TrainPage extends State<Train> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
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
                              "FITNESS",
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
                              "TRAINING PLAN",
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
                              "TECH HUB",
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
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: ExactAssetImage('assets/splash.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: TabBarView(
                children: <Widget>[
                  // ChooseReason(),
                  TrainFitness(),
                  TrainingPlan(onCreatplanPress: widget.onCreatplanPress),
                  TechHub(),
                  // GamesTopTabs(0xff3f51b5),//3f51b5
                  /* MoviesTopTabs(0xffe91e63),*/ //e91e63
                ],
              ))),
    );
  }
}
