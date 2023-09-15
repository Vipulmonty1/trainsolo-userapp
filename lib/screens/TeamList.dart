import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_teams_list_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/utils/Constants.dart';

import 'SearchPlayesList.dart';

class TeamList extends StatefulWidget {
  final VoidCallback genratePlanPressed;

  TeamList({@required /* this.onBuildOwnPlanPress,*/ this.genratePlanPressed});

  TeamListPage createState() => TeamListPage();
}

class TeamListPage extends State<TeamList> {
  bool _isInAsyncCall = false;
  List<TeamData> teamsList = [];
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
                    itemCount:
                        teamsList.length, // Number of widget to be created.
                    itemBuilder: (context, itemIndex) =>
                        ItemWidget(teamsList[itemIndex], () {
                      _onItemTap(context, teamsList[itemIndex]);
                    }, () {
                      _shareItem(context, teamsList[itemIndex]);
                    }, () {
                      _save(context, teamsList[itemIndex]);
                    }),
                  )))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getTeamsListApiCall();
  }

  void pageChanged(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        child: buildPageView(),
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 237, 28, 36),
        label: Text("Create Team"),
        onPressed: widget.genratePlanPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _onItemTap(BuildContext context, TeamData item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPlayesList(
                  teamData: item,
                  onButtonPressed: () {},
                )
            // builder: (context) => TrainingOnGoing()
            ));
  }

  getTeamsListApiCall() async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    GetTeamsListResponse getTeamsListData =
        await getTeamsListByUser(loginResponse.data.user.userId.toString());

    if (getTeamsListData.status == "true") {
      _isInAsyncCall = false;
      setState(() {
        teamsList = getTeamsListData.data;
      });
    } else {
      _isInAsyncCall = false;
    }
  }
}

_shareItem(BuildContext context, TeamData item) {
  print("this is on tap _shareItem and index is " + item.teamname);
}

_save(BuildContext context, TeamData item) {
  print("this is on tap _save and index is " + item.teamname);
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this._shareItem, this._save,
      {Key key})
      : super(key: key);

  final TeamData model;
  final Function onItemTap;
  // ignore: unused_field
  final Function _shareItem;
  // ignore: unused_field
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
                      color: Colors.white24,
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
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Center(
                            child: Text(
                              model.teamname != null
                                  ? model.teamname.substring(0, 2)
                                  : "TM",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
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
                              Text(
                                  model.teamname != null
                                      ? model.teamname
                                      : "TEAM",
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
                                  model.players != null
                                      ? "No. of Players: " +
                                          getlenth(model.players)
                                      : "No. of Players: 0",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          )),
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
