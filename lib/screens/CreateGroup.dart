import 'package:flutter/material.dart';
import 'package:trainsolo/model/get_users_response.dart';
import 'package:trainsolo/screens/SaveFinalGroup.dart';
import 'package:trainsolo/screens/SearchPlayesList.dart';
import 'package:trainsolo/screens/TeamList.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

class CreateGroup extends StatefulWidget {
  CreateGroupPage createState() => CreateGroupPage();
}

class CreateGroupPage extends State<CreateGroup> {
  List<UsersData> newlistData = [];
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );
  List<UsersData> playerlist = [];
  void onDataChange(List<UsersData> userList) {
    setState(() => playerlist = userList);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

/*  void onDataChange(List<UsersData> data) {
    setState(() => data = newData);
  }*/

  Widget buildPageView() {
    print("Page controler while being built ... $pageController");
    return PageView(
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: <Widget>[
          TeamList(
            genratePlanPressed: () {
              Amplitude.getInstance(
                      instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                  .logEvent("Teams Create Team Clicked");
              pageController.jumpToPage(1);
            },
          ),
          SearchPlayesList(
            onButtonPressed: () {
              pageController.jumpToPage(2);
            },
            onDataChange: onDataChange,
            playerlist: playerlist,
          ),
          SaveFinalGroup(
            onButtonPressed: () {
              pageController.jumpToPage(0);
              /*pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            );*/
            },
            onDataChange: onDataChange,
            playerlist: playerlist,
          )
        ],
        physics: new NeverScrollableScrollPhysics());
  }

  @override
  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("My Plans Page Teams Tab Loaded");
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: buildPageView(),
    );
  }
}
