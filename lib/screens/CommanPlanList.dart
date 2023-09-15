import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/model/get_plan_list_by_id_response.dart';
import 'package:trainsolo/screens/Dashboard.dart';
import 'package:trainsolo/screens/SharePlan.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/utils/RevenueCatUtilities.dart';

import 'SubscriptionBlocker.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class CommanPlanList extends StatefulWidget {
  final List<Plan> planList;
  //final List<Plan> completedplanList;
  //final List<Plan> SharedplanList;

  CommanPlanList({List<Plan> planList}) : this.planList = planList ?? [];
  //CompletedPlanList({List<Plan> completedplanList}) : this.planList = completedplanList ?? [];
  //CompletedPlanList({List<Plan> SharedplanList}) : this.planList = SharedplanList ?? [];

  CommanPlanListPage createState() => CommanPlanListPage();
}

class CommanPlanListPage extends State<CommanPlanList> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildPageView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ListView.builder(
                    // Widget which creates [ItemWidget] in scrollable list.
                    itemCount: widget
                        .planList.length, // Number of widget to be created.
                    itemBuilder: (context, itemIndex) =>
                        ItemWidget(widget.planList[itemIndex], () {
                      _onItemTap(context, widget.planList[itemIndex]);
                    }, () {
                      _shareItem(context, widget.planList[itemIndex]);
                    }, () {
                      _save(context, widget.planList[itemIndex]);
                    }),
                  )))
        ],
      ),
    );
  }

  void pageChanged(int index) {
    setState(() {
      //bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: buildPageView(),
    );
  }

  Future<void> _blockWithSubscriptionMyPlans(
      BuildContext context, Plan item) async {
    bool shouldRenderSubscription = await checkAPIBlocker();
    bool userEntitled = await checkNonFitnessAccess();
    if (userEntitled || !shouldRenderSubscription) {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("My Plans Plan Clicked");
      _loadPlan(item);
    } else {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Subscription Blocker Rendered",
              eventProperties: {"source": "my_plans_plan_clicked"});
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return SubscriptionBlocker(() => _loadPlan(item));
          });
    }
  }

  _onItemTap(BuildContext context, Plan item) {
    print("this is on tap item and index is " + item.plantitle);
    print("this is on tap item and index is " + item.planid.toString());
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _blockWithSubscriptionMyPlans(context, item));
  }

  _loadPlan(Plan item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.VIEW_PLAN, "true");
    prefs.setString(Constants.PLAN_ID, item.planid.toString());
    prefs.setString(Constants.PLAN_NAME, item.plantitle.toString());
    prefs.setBool(Constants.IS_SAVED_PLAN, true);
    prefs.setBool(Constants.IS_GENARATE_PLAN, false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
        ModalRoute.withName("dashboard"));
  }

  _shareItem(BuildContext context, Plan item) async {
    // dynamicLink has been generated. share it with others to use it accordingly.
    // Share.share('$dynamicLink');
    // print("Dynamic Link: $dynamicLink");
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("My Plans Share Plan Clicked");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SharePlan(
                planid: item.planid.toString(), planName: item.plantitle)));
  }

  _save(BuildContext context, Plan item) {
    print("this is on tap _save and index is " + item.plantitle);
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this._shareItem, this._save,
      {Key key})
      : super(key: key);

  final Plan model;
  final Function onItemTap;
  final Function _shareItem;
  final Function _save;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: Container(
          height: 90,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: Container(
                      child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 237, 28, 36),
                              border: Border.all(
                                color: Color.fromARGB(255, 237, 28, 36),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Center(
                            child: Text(
                              model.thumbnailname,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.plantitle,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(
                                //Use of SizedBox
                                height: 10,
                              ),
                              Text(
                                  model.drillsjsondata != null
                                      ? "Drills: " +
                                          getlenth(model.drillsjsondata)
                                      : "Drills: 0",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4.0), //icon for share and save  list
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(7.0),
                                    child: GestureDetector(
                                      onTap: _shareItem,
                                      child: Icon(
                                        Icons.ios_share,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(7.0),
                                      child: GestureDetector(
                                        onTap: _save,
                                        child: Icon(
                                          TrainsoloIcons.bookmark_remove_white,
                                          color: model.isbookmarked != 1
                                              ? Colors.white
                                              : Color.fromARGB(
                                                  255, 237, 28, 36),
                                          size: 24.0,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                  model.totalduration != null
                                      ? "Time:" + model.totalduration
                                      : "Time:0Hr 0Min",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              )
            ],
          )),
    );
  }

  String getlenth(String drillsjsondata) {
    String drill = drillsjsondata.split(',').length.toString();
    return drill;
  }
}
