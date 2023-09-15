import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_global_leader_board_response.dart';
import 'package:trainsolo/model/get_team_by_userId.dart';
import 'package:trainsolo/model/login_response.dart';

import 'package:trainsolo/utils/Constants.dart';
import 'package:toast/toast.dart';

class LeaderBoardTimeTrained extends StatefulWidget {
  final String pagename;

  LeaderBoardTimeTrained({@required this.pagename});

  LeaderBoardTimeTrainedPage createState() => LeaderBoardTimeTrainedPage();
}

class LeaderBoardTimeTrainedPage extends State<LeaderBoardTimeTrained> {
  Team _chosenValue;
  bool _isInAsyncCall = false;
  List<LeaderBoardData> leaderBoardlist = [];
  LeaderBoardData firstRank;
  LeaderBoardData secondRank;
  LeaderBoardData thirdRank;
  List<Team> teams = [];

  Widget buildPageView() {
    return Container(
      color: Colors.black,
      child: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(
            color: Color.fromARGB(255, 237, 28, 36),
          ),
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 10.0, bottom: 5.0),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(0.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Team>(
                          dropdownColor: Colors.black,
                          iconEnabledColor: Colors.white, elevation: 5,
                          value: _chosenValue,
                          //elevation: 5,
                          style: TextStyle(color: Colors.white),
                          items:
                              teams.map<DropdownMenuItem<Team>>((Team value) {
                            return DropdownMenuItem<Team>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(value.teamName),
                              ),
                            );
                          }).toList(),
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              _chosenValue != null ? _chosenValue.teamName : "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          onChanged: (Team value) {
                            setState(() {
                              _chosenValue = value;
                              _getTeamsLeaderBoard("", value.teamId);
                            });
                          },
                        ),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    secondRank != null
                        ? LeaderBoardRankItemWidget(secondRank, "2nd")
                        : SizedBox(
                            width: 10,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26.0),
                      child: firstRank != null
                          ? LeaderBoardRankItemWidget(firstRank, "1st")
                          : SizedBox(
                              height: 10,
                            ),
                    ),
                    thirdRank != null
                        ? LeaderBoardRankItemWidget(thirdRank, "3rd")
                        : SizedBox(
                            width: 10,
                          )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      // Widget which creates [ItemWidget] in scrollable list.
                      itemCount: leaderBoardlist != null
                          ? leaderBoardlist.length
                          : 0, // Number of widget to be created.
                      itemBuilder: (context, itemIndex) => ItemWidget(
                        leaderBoardlist[itemIndex],
                        () {
                          _onItemTap(context, leaderBoardlist[itemIndex]);
                        },
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    getTeamsList();
  }

  Future<void> getTeamsList() async {
    setState(() {
      _isInAsyncCall = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      GetTeamByUserIdResponse teamByUserIdResponse =
          await getTeamsByUserId(loginResponse.data.user.userId.toString());
      if (teamByUserIdResponse.status == "true") {
        _isInAsyncCall = false;
        Toast.show("${teamByUserIdResponse.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        teams = teamByUserIdResponse.data;

        if (teams != null && teams.length > 0) {
          _chosenValue = teams[0];
          _getTeamsLeaderBoard(
              loginResponse.data.user.userId.toString(), teams[0].teamId);
        }
      } else {
        _isInAsyncCall = false;

        Toast.show("${teamByUserIdResponse.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  _getTeamsLeaderBoard(String userId, int teamId) async {
    if (userId == "") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdata = prefs.getString(Constants.USER_DATA);
      final jsonResponse = json.decode(userdata);
      LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
      if (loginResponse.data != null) {
        userId = loginResponse.data.user.userId.toString();
      }
    }
    GetGlobalLeaderBoardResponse globleaderboard =
        await getTimeTrainedLeaderBoard(userId, teamId);
    firstRank = null;
    secondRank = null;
    thirdRank = null;
    List<LeaderBoardData> leaderBoardlist1 = [];
    leaderBoardlist1 = globleaderboard.data;

    if (leaderBoardlist1 != null) {
      leaderBoardlist1.forEach((element) {
        if (element.position == "1") {
          firstRank = element;
        } else if (element.position == "2") {
          secondRank = element;
        } else if (element.position == "3") {
          thirdRank = element;
        }
      });
    }
    leaderBoardlist = leaderBoardlist1
        .where((element) => int.parse(element.position) > 3)
        .toList();
    setState(() {});
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
}

class LeaderBoardRankItemWidget extends StatelessWidget {
  final LeaderBoardData model;
  final String position;
  const LeaderBoardRankItemWidget(
    this.model,
    this.position, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(position,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: 'HelveticaNeue',
                fontWeight: FontWeight.w400,
              )),
          SizedBox(
            //Use of SizedBox
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 0.0, top: 8.0, bottom: 8.0, right: 0.0),
            child: Container(
              width: 75,
              height: 75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox.expand(
                  child: FittedBox(
                    child: Image.network(
                        Constants.IMAGE_BASE_URL + "/" + model.profilePhoto),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            //Use of SizedBox
            height: 2,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 100),
            child: Text(model.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w400,
                )),
          ),
          SizedBox(
            //Use of SizedBox
            height: 2,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 100),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
            child: Text(model.desc,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w400,
                )),
          ),
        ],
      ),
    );
  }
}

_onItemTap(BuildContext context, LeaderBoardData item) {
  print("this is on tap item and index is " + item.name);
/*  Navigator.push(
      context, MaterialPageRoute(builder: (context) => TrainingOnGoing()));*/
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, {Key key}) : super(key: key);

  final LeaderBoardData model;
  final Function onItemTap;

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
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 8.0, bottom: 8.0, right: 20.0),
                        child: Text(
                            model.position != null
                                ? model.position.toString()
                                : "0",
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, bottom: 8.0, right: 20.0),
                        child: Container(
                          width: 75,
                          height: 75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: SizedBox.expand(
                              child: FittedBox(
                                child: CachedNetworkImage(
                                  imageUrl: model.profilePhoto != null
                                      ? Constants.IMAGE_BASE_URL +
                                          "/" +
                                          model.profilePhoto
                                      : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                                  placeholder: (context, url) =>
                                      Transform.scale(
                                    scale: 0.2,
                                    child: CircularProgressIndicator(
                                        color:
                                            Color.fromARGB(255, 237, 28, 36)),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Transform.scale(
                                    scale: 1.5,
                                    child:
                                        Icon(Icons.image, color: Colors.grey),
                                  ),
                                ),
                                fit: BoxFit.fill,
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
                              Text(model.name,
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
                              Text(model.desc,
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
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
