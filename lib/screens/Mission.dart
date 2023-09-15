import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/main.dart';
import 'package:trainsolo/model/mission_list_response.dart';
import 'package:trainsolo/screens/MissionCause.dart';
import 'package:trainsolo/screens/MissionLeaderBoard.dart';

class Mission extends StatefulWidget {
  MissionPage createState() => MissionPage();
}

class MissionPage extends State<Mission> with SingleTickerProviderStateMixin {
  bool _isInAsyncCall = false;
  TabController _controller;
  List<MissonListData> missionList = [];
  ScrollController _scrollController;

  MissonListData missioninfo;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: ModalProgressHUD(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: SizedBox.expand(
                      child: FittedBox(
                        child: Image.asset('assets/missionimmage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Container(
                    decoration: new BoxDecoration(color: Colors.black),
                    child: new TabBar(
                      controller: _controller,
                      labelStyle: TextStyle(fontSize: 20.0),
                      unselectedLabelStyle: TextStyle(fontSize: 20.0),
                      indicatorColor: Color.fromARGB(255, 237, 28, 36),
                      indicatorWeight: 2.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        new Tab(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "Mission",
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
                              "LeaderBoard",
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
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.70 - 40,
                  color: Colors.black,
                  width: double.infinity,
                  child: TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      MissionCause(missiondata: missioninfo),
                      MissionLeaderBoard(),
                    ],
                  ),
                ),
              ],
            ),
            inAsyncCall: _isInAsyncCall,
            color: Colors.black,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(
              color: Color.fromARGB(255, 237, 28, 36),
            ),
          ),
        ));
  }

  Future<void> clearPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
        ModalRoute.withName("/"));
  }
}
