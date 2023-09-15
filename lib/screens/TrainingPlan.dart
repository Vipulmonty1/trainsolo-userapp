import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/screens/BuildYourOwn.dart';
import 'package:trainsolo/screens/PlanPreferences.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'TrainingPlanSet.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class TrainingPlan extends StatefulWidget {
  final VoidCallback onCreatplanPress;
  TrainingPlan({@required this.onCreatplanPress});
  TrainingPlanPage createState() => TrainingPlanPage();
}

class TrainingPlanPage extends State<TrainingPlan> {
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Train Page Training Plan Tab Loaded");
    getsharedPrif();
  }

  pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  Widget buildPageView() {
    return PageView(
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: <Widget>[
          PlanPreferences(
            onBuildOwnPlanPress: () => pageController.animateToPage(
              2,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            ),
            genratePlanPressed: () => pageController.animateToPage(
              1,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            ),
          ),
          TrainingPlanSet(
            onButtonPressed: () => pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            ),
            onCreatePlansPressed: widget.onCreatplanPress,
          ),
          BuildYourOwn(
            onButtonPressed: () => pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            ),
          )
        ],
        physics: new NeverScrollableScrollPhysics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: buildPageView(),
    );
  }

  Future<void> getsharedPrif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parsdata = prefs.getString(Constants.VIEW_PLAN);
    if (parsdata == "true") {
      print(":::::::::::::::::::::trannig plan::::::::::::::DATA::::IF::::");
      setState(() {
        pageController.animateToPage(
          1,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        prefs.setString(Constants.VIEW_PLAN, "false");
      });
    } else {
      setState(() {
        //pageChanged(0);
        prefs.setString(Constants.VIEW_PLAN, "false");
      });

      print(":::::::::::::::::::::trannig plan::::::::::::::DATA::::ELSE::::");
    }
  }
}
