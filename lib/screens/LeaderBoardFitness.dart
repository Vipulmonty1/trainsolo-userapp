import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/fitness_response.dart';
import 'package:trainsolo/model/get_global_leader_board_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'LeaderBoardTimeTrained.dart';

class LeaderBoardFitness extends StatefulWidget {
  final String pagename;

  LeaderBoardFitness({@required this.pagename});

  LeaderBoardFitnessPage createState() => LeaderBoardFitnessPage();
}

class LeaderBoardFitnessPage extends State<LeaderBoardFitness> {
  FitnessData _chosenValue;
  bool _isInAsyncCall = false;
  List<LeaderBoardData> leaderBoardlist = [];
  LeaderBoardData firstRank;
  LeaderBoardData secondRank;
  LeaderBoardData thirdRank;
  List<FitnessData> fitnessList = [];
  String userId;

  Widget buildPageView() {
    return Container(
      child: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
                      child: DropdownButton<FitnessData>(
                        dropdownColor: Colors.black,
                        iconEnabledColor: Colors.white, elevation: 5,
                        value: _chosenValue,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        items: fitnessList.map<DropdownMenuItem<FitnessData>>(
                            (FitnessData value) {
                          return DropdownMenuItem<FitnessData>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(value.name),
                            ),
                          );
                        }).toList(),
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            _chosenValue != null ? _chosenValue.name : "",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        onChanged: (FitnessData value) {
                          _chosenValue = value;
                          getFitnessLeaderBoardByFitnessId(
                              userId, _chosenValue.id);
                          setState(() {});
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
                            width: 10,
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
                    itemCount: leaderBoardlist
                        .length, // Number of widget to be created.
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getFitnessLeaderBoard();
  }

  Future<void> _getFitnessLeaderBoard() async {
    setState(() {
      _isInAsyncCall = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      userId = loginResponse.data.user.userId.toString();

      FitnessResponse fitnessResponse = await getFitnessList();
      if (fitnessResponse.status == "true") {
        _isInAsyncCall = false;
        Toast.show("${fitnessResponse.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        fitnessList = fitnessResponse.data;
        getFitnessLeaderBoardByFitnessId(
            loginResponse.data.user.userId.toString(), fitnessList[0].id);
      } else {
        _isInAsyncCall = false;

        Toast.show("${fitnessResponse.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  getFitnessLeaderBoardByFitnessId(String userId, String fitnessId) async {
    GetGlobalLeaderBoardResponse globleaderboard =
        await getFitnessLeaderBoard(userId, fitnessId);

    leaderBoardlist = globleaderboard.data;
    if (leaderBoardlist != null) {
      leaderBoardlist.forEach((element) {
        if (element.position == "1") {
          firstRank = element;
        } else if (element.position == "2") {
          secondRank = element;
        } else if (element.position == "3") {
          thirdRank = element;
        }
      });
    }
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

_onItemTap(BuildContext context, LeaderBoardData item) {
  print("this is on tap item and index is " + item.name);
/*  Navigator.push(
      context, MaterialPageRoute(builder: (context) => TrainingOnGoing()));*/
}
