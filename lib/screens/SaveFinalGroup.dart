import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/common_success.dart';
import 'package:trainsolo/model/get_teams_list_response.dart';
import 'package:trainsolo/model/get_users_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/utils/Constants.dart';

import 'Dashboard.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class SaveFinalGroup extends StatefulWidget {
  final VoidCallback onButtonPressed;
  final Function(List<UsersData>) onDataChange;
  final List<UsersData> playerlist;
  final TeamData teamData;

  SaveFinalGroup(
      {@required this.onButtonPressed,
      this.onDataChange,
      this.playerlist,
      this.teamData});

  SaveFinalGroupPage createState() => SaveFinalGroupPage();
}

// ignore: unused_element
bool _isInAsyncCall = false;
String userId = "";
String userName = "";
List<UsersData> selectedUserList = [];
List<int> playerIDList = [];

class SaveFinalGroupPage extends State<SaveFinalGroup>
    with SingleTickerProviderStateMixin {
  final newGroupController = TextEditingController();
  final groupNameController = TextEditingController();

  @override
  void initState() {
    //getSelectedPlayer();
    super.initState();
    if (widget.teamData != null) {
      groupNameController.text = widget.teamData.teamname;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // AppBar(
          //   title: Text(''), // You can add title here
          //   leading: new IconButton(
          //     icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
          //     onPressed: () => {widget.backButtonPressed()},
          //   ),
          //   backgroundColor:
          //       Colors.black.withOpacity(0.3), //You can make this transparent
          //   elevation: 0.0, //No shadow
          // ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 100.0, bottom: 10.0),
            child: _NewGroup(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            child: _GroupName(),
          ),
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Align(
                alignment: Alignment.topLeft,
                child:
                    Text('Participants: ' + widget.playerlist.length.toString(),
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w400,
                        )),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, mainAxisSpacing: 12),
                itemCount: widget.playerlist.length,
                itemBuilder: (context, itemIndex) =>
                    ServiceItem(widget.playerlist[itemIndex]),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  if (groupNameController.text.isEmpty) {
                    Amplitude.getInstance(
                            instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                        .logEvent("Team Group Name Not Entered");
                    Toast.show('Enter your group name', context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Amplitude.getInstance(
                            instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                        .logEvent("Team Group Name Entered", eventProperties: {
                      "num_players": widget.playerlist.length
                    });
                    playerIDList.clear();

                    widget.playerlist.forEach((element) {
                      playerIDList.add(element.usrid);
                    });

                    String players = playerIDList.join(',');
                    String groupName = groupNameController.text.toString();
                    if (widget.teamData != null) {
                      updateTeamApiCall(players, groupName, widget.teamData);
                    } else {
                      createTeamApiCall(players, groupName);
                    }
                    setState(() {
                      groupNameController.text = "";
                      //selectedUserList.clear();
                    });
                  }
                },
                child: const Icon(Icons.arrow_forward),
                backgroundColor: Color.fromARGB(255, 237, 28, 36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _NewGroup() {
    return Container(
        height: 40.0,
        child: TextField(
          controller: newGroupController,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'BebasNeue',
            fontWeight: FontWeight.w400,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 0.0),
            hintText: 'NEW GROUP',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'BebasNeue',
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide:
                    new BorderSide(color: Color.fromARGB(255, 237, 28, 36))),
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'BebasNeue',
              fontWeight: FontWeight.w400,
            ),
          ),
        ));
  }

  Widget _GroupName() {
    return Container(
        height: 40.0,
        child: TextField(
          controller: groupNameController,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w400,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 0.0),
            hintText: 'Type your group name here',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide:
                    new BorderSide(color: Color.fromARGB(255, 237, 28, 36))),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.w400,
            ),
          ),
        ));
  }

  getSelectedPlayer() async {
    print(
        "::::::::::::::::::::::::::::::::::::INSIDE GET DATA FROM PREFRENCE:::::::::::::::::");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String musicsString =
        await prefs.getString(Constants.TEAM_PLAYER_DATA);
    final jsonMap = json.decode(musicsString);
    selectedUserList = (jsonMap as List)
        .map((itemWord) => UsersData.fromJson(itemWord))
        .toList();
    print("SIZE OF LIST::::::::::::::::::::::::::::::" +
        selectedUserList.length.toString());
    selectedUserList.forEach((element) {
      playerIDList.add(element.usrid);
      print("Selected Players List :::::::::::::::inside save:::::::::::::::" +
          element.username);
    });

    setState(() {});

    //print("List :::::::::::::::length:::::::::::::::"+selectedUserList.length.toString());
  }

  createTeamApiCall(String players, String teamName) async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      userId = loginResponse.data.user.userId.toString();
      userName = loginResponse.data.user.username.toString();
      print(
          "::::::::::::::::::::::::::::::::::::::::userId:::::::::::::::::::" +
              loginResponse.data.user.userId.toString());
      print(
          "::::::::::::::::::::::::::::::::::::::::username:::::::::::::::::::" +
              loginResponse.data.user.username.toString());
      print(
          "::::::::::::::::::::::::::::::::::::::::username:::::::::::::::::::" +
              players.toString());
    }
    CommonSuccess commanResponse =
        await createTeam(userId, userName, teamName, players);

    if (commanResponse.status == "true") {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS TRUE>>>>>>>>>>>>>>>>>>>>');

      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text(
              'Your Group Was Created',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'BebasNeue',
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              /* CupertinoDialogAction(
                  child: Text('Long Text Button'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),*/
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      /* Toast.show("${commanResponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);*/
      // await prefs.remove(Constants.TEAM_PLAYER_DATA);
      widget.playerlist.clear();
      if (widget.onDataChange != null) {
        widget.onDataChange(widget.playerlist);
      }
      // widget.onButtonPressed();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Dashboard(),
        ),
        (route) => false,
      );
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          commanResponse.message);
      Toast.show("${commanResponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  updateTeamApiCall(String players, String teamName, TeamData teamData) async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      userId = loginResponse.data.user.userId.toString();
      userName = loginResponse.data.user.username.toString();
      print(
          "::::::::::::::::::::::::::::::::::::::::userId:::::::::::::::::::" +
              loginResponse.data.user.userId.toString());
      print(
          "::::::::::::::::::::::::::::::::::::::::username:::::::::::::::::::" +
              loginResponse.data.user.username.toString());
      print(
          "::::::::::::::::::::::::::::::::::::::::username:::::::::::::::::::" +
              players.toString());
    }
    CommonSuccess commanResponse =
        await updateTeam(userId, userName, teamName, players, widget.teamData);

    if (commanResponse.status == "true") {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS TRUE>>>>>>>>>>>>>>>>>>>>');
      Toast.show("${commanResponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      // await prefs.remove(Constants.TEAM_PLAYER_DATA);
      widget.playerlist.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Dashboard(),
        ),
        (route) => false,
      );
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          commanResponse.message);
      Toast.show("${commanResponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}

class ServiceItem extends StatefulWidget {
  const ServiceItem(this.model, {Key key}) : super(key: key);
  final UsersData model;

  ServiceItemPage createState() => ServiceItemPage();
}

class ServiceItemPage extends State<ServiceItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: 65.0,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: new NetworkImage(
                  widget.model.profilepicurl != null
                      ? Constants.IMAGE_BASE_URL +
                          "/" +
                          widget.model.profilepicurl
                      : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                ),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                widget.model.username != null
                    ? widget.model.username
                    : 'No title',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w400,
                )),
          ),
        ),
      ],
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      print("HEllo  This checkbox selected:::::::::::::::>>>>>>>>>");
    });
  }
}
