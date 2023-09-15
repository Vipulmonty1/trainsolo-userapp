import 'package:flutter/material.dart';

import 'package:trainsolo/screens/TechHubBeginner.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

class TechHub extends StatefulWidget {
  TechHubPage createState() => TechHubPage();
}

class TechHubPage extends State<TechHub> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> myTabs = <Tab>[
    Tab(text: "BEGINNER"),
    Tab(text: "INTERMEDIATE"),
    Tab(text: "ADVANCED"),
  ];

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Train Page Tech Hub Page Loaded");
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                  controller: _tabController,
                  indicatorColor: Color.fromARGB(255, 237, 28, 36),
                  indicatorWeight: 2.0,
                  isScrollable: true,
                  labelStyle: TextStyle(fontSize: 16.0),
                  //For Selected tab
                  unselectedLabelStyle: TextStyle(fontSize: 16.0),
                  tabs: myTabs,
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
              controller: _tabController,
              children: myTabs.map((Tab tab) {
                final String label = tab.text.toLowerCase();
                return TechHubBeginner(categoryName: '$label');
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
