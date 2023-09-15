import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/screens/Library.dart';
import 'package:trainsolo/screens/Mission.dart';
import 'package:trainsolo/screens/MyPlans.dart';
import 'package:trainsolo/screens/Profile.dart';
import 'package:trainsolo/screens/Train.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class Dashboard extends StatefulWidget {
  DashboardPage createState() => DashboardPage();
}

class DashboardPage extends State<Dashboard> {
  bool isCreatePlan = false;
  bool isCreateTeams = false;

  @override
  void initState() {
    super.initState();
    faceshard();
  }

  int _currentIndex = 2;
  final List<Widget> _children = [
    //PlaceholderWidget(Colors.black,"Mission"),
    Mission(),
    Library(),
    Train(
        onCreatplanPress: () => {
              print('Callbalck on Da Page :>:>:>:>:>:inside dashboard>:>:>:>:>')
            }),
    MyPlans(),
    Profile(),
  ];

  onTabTapped(int index) {
    print("Current Index: ${index}");
    String logString = "Error";
    switch (index) {
      case 0:
        logString = "Mission";
        break;
      case 1:
        logString = "Library";
        break;
      case 2:
        logString = "Train";
        break;
      case 3:
        logString = "MyPlans";
        break;
      case 4:
        logString = "Profile";
        break;
    }
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Main Tab Change", eventProperties: {"new_tab": logString});
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                canvasColor: const Color(0xffE7E8E9),
                primaryColor: Color.fromARGB(255, 237, 28, 36),
                textTheme: Theme.of(context).textTheme.copyWith(
                    caption: new TextStyle(
                        color: Colors
                            .yellow))), // sets the inactive color of the `BottomNavigationBar`
            child: new BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: onTabTapped, // new
              currentIndex: _currentIndex, // new
              selectedItemColor: Color.fromARGB(255, 237, 28, 36),
              unselectedItemColor: Colors.black,

              items: [
                new BottomNavigationBarItem(
                  icon: Icon(TrainsoloIcons.mission),
                  // ignore: deprecated_member_use
                  title: Text(
                    'Mission',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(TrainsoloIcons.video),
                  // ignore: deprecated_member_use
                  title: Text(
                    'Library',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                new BottomNavigationBarItem(
                    icon: Icon(TrainsoloIcons.train),
                    // ignore: deprecated_member_use
                    title: Text(
                      'Train',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                new BottomNavigationBarItem(
                    icon: Icon(TrainsoloIcons.bookmark_black_24dp_1),
                    // ignore: deprecated_member_use
                    title: Text(
                      'My Plans',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                new BottomNavigationBarItem(
                    icon: Icon(TrainsoloIcons.stats),
                    // ignore: deprecated_member_use
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> faceshard() async {
    //onTabTapped(3);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isCreatePlan = prefs.getBool(Constants.CREATE_PLAN) == null
        ? false
        : prefs.getBool(Constants.CREATE_PLAN);

    if (isCreatePlan) {
      print(":::::::::::::::::::::INSIDE::::::::::DASHBOARD::::DATA::::IF::::");
      onTabTapped(3);
      prefs.setBool(Constants.CREATE_PLAN, false);
    } else {
      onTabTapped(2);
      print(
          ":::::::::::::::::::::INSIDE::::::::::DASHBOARD::::DATA::::ELSE::::");
    }
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String name;

  PlaceholderWidget(this.color, this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: new Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'BebasNeue',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
