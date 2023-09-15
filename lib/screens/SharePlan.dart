import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/model/get_teams_list_response.dart';
import 'package:trainsolo/model/get_users_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/single_app_param_response.dart';
import 'package:trainsolo/utils/Constants.dart';
import '../api/api_service.dart';
import '../model/common_success.dart';
import 'package:toast/toast.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class SharePlan extends StatefulWidget {
  final String planid;
  final String planName;
  SharePlan({@required this.planid, @required this.planName});

  SharePlanPage createState() => SharePlanPage();
}

List<int> playerIDList = [];
List<int> teamIDList = [];

class SharePlanPage extends State<SharePlan> {
  void refresh() {
    setState(() {
      players = "";
    });
  }

  bool _isInAsyncCall = false;
  GlobalKey<PageContainerState> key = GlobalKey();
  List<bool> _isCheckedUser;
  List<bool> _isCheckedTeam;
  bool _whomToSharePressed = true;

  List<UsersData> userList = [];
  List<UsersData> selectedUserList = [];
  List<TeamData> teamsList = [];
  List<TeamData> selectedTeamList = [];
  final PageController _pageController = PageController();
  int id = 0;
  bool navigateToPage = false;
  String shareWith = "USERS";
  String players;
  String teams;

  final searchController = TextEditingController();
  String search;

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    getPlayersListApiCall("");
    getTeamsListApiCall("");
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
          child: Container(
              color: Colors.black,
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                      child: Row(children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              size: 28, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'SHARE WITH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                          /*style: GoogleFonts.poppins(
                                fontSize: 50,
                              ),*/
                        ),
                      ])),
                  Expanded(
                    flex: 0,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ButtonTheme(
                              minWidth: 120.0,
                              height: 30.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                textColor: Colors.black,
                                color: _whomToSharePressed
                                    ? Colors.white
                                    : Colors.transparent,
                                child: new Row(
                                  children: [
                                    Text(
                                      "USERS",
                                      style: TextStyle(
                                        color: _whomToSharePressed
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (!_whomToSharePressed) {
                                      _whomToSharePressed = true;
                                    }
                                    shareWith = "USERS";
                                  });

                                  if (_pageController.hasClients) {
                                    _pageController.animateToPage(
                                      1,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.white)),
                              ),
                            ),
                            SizedBox(width: 20),
                            ButtonTheme(
                              minWidth: 120.0,
                              height: 30.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                textColor: Colors.black,
                                color: !_whomToSharePressed
                                    ? Colors.white
                                    : Colors.transparent,
                                child: new Row(
                                  children: [
                                    Text(
                                      "TEAMS",
                                      style: TextStyle(
                                        color: !_whomToSharePressed
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  setState(() {
                                    shareWith = "TEAMS";
                                    if (_whomToSharePressed) {
                                      _whomToSharePressed = false;
                                    }
                                  });

                                  if (_pageController.hasClients) {
                                    _pageController.animateToPage(
                                      1,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.white)),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: _GooglePlayAppBar(),
                  ),
                  Expanded(
                      flex: 1,
                      child: _whomToSharePressed
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: userList.length,
                              // Number of widget to be created.
                              itemBuilder: (context, itemIndex) {
                                return Container(
                                    height: 85,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 5.0,
                                                bottom: 5.0,
                                                top: 0.0),
                                            padding: const EdgeInsets.all(1.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: Container(
                                                child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 8.0,
                                                          bottom: 8.0,
                                                          right: 8.0),
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: SizedBox.expand(
                                                        child: FittedBox(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: userList[
                                                                            itemIndex]
                                                                        .profilepicurl !=
                                                                    null
                                                                ? Constants
                                                                        .IMAGE_BASE_URL +
                                                                    "/" +
                                                                    userList[
                                                                            itemIndex]
                                                                        .profilepicurl
                                                                : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Transform
                                                                        .scale(
                                                              scale: 0.2,
                                                              child: CircularProgressIndicator(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          237,
                                                                          28,
                                                                          36)),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Transform
                                                                        .scale(
                                                              scale: 1.5,
                                                              child: Icon(
                                                                  Icons.image,
                                                                  color: Colors
                                                                      .grey),
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
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                userList[itemIndex]
                                                                        .username ??
                                                                    "NEW PLAYES",
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'HelveticaNeue',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                )),
                                                            SizedBox(
                                                              //Use of SizedBox
                                                              height: 3,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          2.0),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 22.0,
                                                                    height:
                                                                        22.0,
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromARGB(255, 237, 28, 36),
                                                                        border: Border.all(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              237,
                                                                              28,
                                                                              36),
                                                                        ),
                                                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        userList[itemIndex].positioncode ??
                                                                            "CM",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              'BebasNeue',
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                        userList[itemIndex]
                                                                            .timespent,
                                                                        maxLines:
                                                                            1,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'HelveticaNeue',
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Theme(
                                                  child: Checkbox(
                                                    value: _isCheckedUser[
                                                        itemIndex],
                                                    onChanged: (val) {
                                                      setState(
                                                        () {
                                                          _isCheckedUser[
                                                              itemIndex] = val;
                                                          _save(
                                                              context,
                                                              userList[
                                                                  itemIndex]);
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  data: ThemeData(
                                                    primarySwatch: Colors.green,
                                                    unselectedWidgetColor: Colors
                                                        .white, // Your color
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ),
                                        )
                                      ],
                                    ));
                              })
                          : ListView.builder(
                              // Widget which creates [ItemWidget] in scrollable list.
                              itemCount: teamsList
                                  .length, // Number of widget to be created.
                              itemBuilder: (context, itemIndex) {
                                return Container(
                                    height: 90,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              margin: const EdgeInsets.all(5.0),
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white24,
                                                ),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        8.0),
                                              ),
                                              child: Container(
                                                  child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      decoration: BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255, 255, 0, 0),
                                                          border: Border.all(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    0,
                                                                    0),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: Center(
                                                        child: Text(
                                                          teamsList[itemIndex]
                                                                      .teamname !=
                                                                  null
                                                              ? teamsList[
                                                                      itemIndex]
                                                                  .teamname
                                                                  .substring(
                                                                      0, 2)
                                                              : "TM",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'BebasNeue',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              teamsList[itemIndex]
                                                                          .teamname !=
                                                                      null
                                                                  ? teamsList[
                                                                          itemIndex]
                                                                      .teamname
                                                                  : "TEAM",
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'HelveticaNeue',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              )),
                                                          SizedBox(
                                                            //Use of SizedBox
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              teamsList[itemIndex]
                                                                          .players !=
                                                                      null
                                                                  ? "No. of Players: " +
                                                                      getlenth(teamsList[
                                                                              itemIndex]
                                                                          .players)
                                                                  : "No. of Players: 0",
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'HelveticaNeue',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              )),
                                                        ],
                                                      )),
                                                  Theme(
                                                    child: Checkbox(
                                                      value: _isCheckedTeam[
                                                          itemIndex],
                                                      onChanged: (val) {
                                                        setState(
                                                          () {
                                                            _isCheckedTeam[
                                                                    itemIndex] =
                                                                val;
                                                            _saveTeams(
                                                                context,
                                                                teamsList[
                                                                    itemIndex]);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    data: ThemeData(
                                                      primarySwatch:
                                                          Colors.green,
                                                      unselectedWidgetColor: Colors
                                                          .white, // Your color
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              },
                            )),
                  Expanded(
                    flex: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            if (_whomToSharePressed) {
                              Amplitude.getInstance(
                                      instanceName:
                                          Constants.AMPLITUDE_INSTANCE_NAME)
                                  .logEvent("Internal Share Clicked");
                              playerIDList.clear();
                              if (selectedUserList != null) {
                                selectedUserList.forEach((element) {
                                  playerIDList.add(element.usrid);
                                });
                                players = playerIDList.join(',');
                                updateSharingPlanApiCall(
                                    widget.planid, players, "", "USERS");
                              } else {}
                            } else {
                              teamIDList.clear();
                              if (selectedTeamList != null) {
                                selectedTeamList.forEach((element) {
                                  teamIDList.add(element.teamid);
                                });
                                teams = teamIDList.join(',');
                                updateSharingPlanApiCall(
                                    widget.planid, "", teams, this.shareWith);
                              } else {}
                            }
                          },
                          backgroundColor: Color.fromARGB(255, 237, 28, 36),
                          label: Text("Share"),

                          //child: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          onPressed: () async {
                            Amplitude.getInstance(
                                    instanceName:
                                        Constants.AMPLITUDE_INSTANCE_NAME)
                                .logEvent("External Share Clicked");
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var userdata = prefs.getString(Constants.USER_DATA);
                            final jsonResponse = json.decode(userdata);
                            LoginResponse loginResponse =
                                new LoginResponse.fromJson(jsonResponse);

                            var dynamicLink = await createDynamicLink(
                                planId: widget.planid.toString(),
                                userId:
                                    loginResponse.data.user.userId.toString(),
                                username: loginResponse.data.user.username,
                                planName: widget.planName);
                            // dynamicLink has been generated. share it with others to use it accordingly.
                            print(
                                "Dynamic Link returned by method: ${dynamicLink}");
                            String stringDynamicLink = dynamicLink.toString();
                            print("String dynamic link: ${stringDynamicLink}");
                            Share.share('$stringDynamicLink');
                            // Clipboard.setData(
                            //     ClipboardData(text: stringDynamicLink));
                            // showCupertinoDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return CupertinoAlertDialog(
                            //       content: Text(
                            //         'Sharable Link Copied to Clipboard!',
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //           color: Colors.black,
                            //           fontFamily: 'BebasNeue',
                            //           fontSize: 18.0,
                            //           fontWeight: FontWeight.w400,
                            //         ),
                            //       ),
                            //       actions: <Widget>[
                            //         CupertinoDialogAction(
                            //           child: Text('OK'),
                            //           onPressed: () {
                            //             Navigator.of(context).pop();
                            //           },
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                            // Share.share(
                            //     'https://trainsolosoccer.page.link/test1');
                            // print("Dynamic Link: $dynamicLink");
                          },
                          backgroundColor: Color.fromARGB(255, 237, 28, 36),
                          label: Text("Share on other app"),
                          //child: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  )
                ],
              )),
          inAsyncCall: _isInAsyncCall,
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(
            color: Color.fromARGB(255, 237, 28, 36),
          ),
        ),
      ),
    );
  }

  Widget _GooglePlayAppBar() {
    return Container(
        height: 50.0,
        child: TextField(
          controller: searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15.0),
            border: OutlineInputBorder(),
            hintText: 'Search ' + shareWith,
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.white, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  setState(() {
                    search = searchController.text;
                    if (shareWith == "USERS")
                      getPlayersListApiCall(search);
                    else
                      getTeamsListApiCall(search);
                    //fetchAlbum(search);
                    searchController.text = "";
                  });
                }),
          ),
        ));
  }

  String getlenth(String drillsjsondata) {
    String drill = drillsjsondata.split(',').length.toString();
    return drill;
  }

  getPlayersListApiCall(String strSearch) async {
    setState(() {
      _isInAsyncCall = true;
    });
    List<UsersData> outputList = [];
    GetUsersResponse getUserListData = await getUserList();

    if (getUserListData.status == "true") {
      _isInAsyncCall = false;
      //Toast.show("${getTeamsListData.message}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      setState(() {
        userList = getUserListData.data;
        if (strSearch.isEmpty) {
          // if the search field is empty or only contains white-space, we'll display all users
          outputList = userList;
        } else {
          outputList = userList
              .where((drills) => drills.username
                  .toString()
                  .toLowerCase()
                  .contains(strSearch.toLowerCase()))
              .toList();
          // we use the toLowerCase() method to make it case-insensitive
        }
        userList = outputList;
        _isCheckedUser = List<bool>.filled(userList.length, false);
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          getUserListData.message);
    }
  }

  getTeamsListApiCall(String strSearch) async {
    setState(() {
      _isInAsyncCall = true;
    });
    List<TeamData> outputList = [];
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
        if (strSearch.isEmpty) {
          // if the search field is empty or only contains white-space, we'll display all users
          outputList = teamsList;
        } else {
          outputList = teamsList
              .where((drills) => drills.teamname
                  .toString()
                  .toLowerCase()
                  .contains(strSearch.toLowerCase()))
              .toList();
          // we use the toLowerCase() method to make it case-insensitive
        }
        teamsList = outputList;
        _isCheckedTeam = List<bool>.filled(teamsList.length, false);
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          getTeamsListData.message);
    }
  }

  _save(BuildContext context, UsersData item) {
    /*if(selectedUserList.length==9){
      print("Length of list is ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"+selectedUserList.length.toString());
      //showlimitDialog(context);
    }*/
    bool exists = selectedUserList.any((file) => file.usrid == item.usrid);
    if (exists) {
      selectedUserList.remove(item);
      refresh();
    } else {
      selectedUserList.add(item);
      refresh();
    }
  }

  _saveTeams(BuildContext context, TeamData item) {
    /*if(selectedUserList.length==9){
      print("Length of list is ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"+selectedUserList.length.toString());
      //showlimitDialog(context);
    }*/
    bool exists = selectedTeamList.any((file) => file.teamid == item.teamid);
    if (exists) {
      selectedTeamList.remove(item);
      refresh();
    } else {
      selectedTeamList.add(item);
      refresh();
    }
  }

  Future<Uri> createDynamicLink(
      {@required String planId,
      String userId,
      String username,
      String planName}) async {
    print("Plan Name:$planName");
    SingleAppParamResponse appIdData = await getSingleAppParam('APP_STORE_ID');
    String appStoreId = '447188370';
    if (appIdData != null && appIdData.data[0]['PAR_VALUE'] != null) {
      appStoreId = appIdData.data[0]['PAR_VALUE'];
    }
    // appStoreId = "1582909254";
    print("App Store Id: ${appStoreId}");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // This should match firebase but without the username query param
      uriPrefix: 'https://trainsolosoccer.page.link',
      // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
      link: Uri.parse(
          'https://trainsolotest.page.link/planId?planId=$planId&userId=$userId&planName=$planName'),
      androidParameters: AndroidParameters(
        packageName: 'com.trainsolo',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.trainsolo',
        minimumVersion: '1',
        appStoreId: appStoreId,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: '${username} has shared a training plan with you!',
          description:
              "Please download the Trainsolo app to access ${username}'s plan along with hundreds of other drills ...",
          imageUrl: Uri.parse(
              "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg")),
    );
    // final link = await parameters.buildUrl();
    // final ShortDynamicLink shortenedLink =
    //     await DynamicLinkParameters.shortenUrl(
    //   link,
    //   DynamicLinkParametersOptions(
    //       shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    // );
    // print("Shortened Link: ${shortenedLink.shortUrl}");
    // return shortenedLink.shortUrl;
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri link = shortDynamicLink.shortUrl;
    print("Short Dynamic Link object: ${shortDynamicLink.warnings}");
    print('Dynamic Link that will be shared: $link');
    return link;
    // return 'https://trainsolosoccer.page.link/test1';
  }

  Future<void> updateSharingPlanApiCall(
      String planid, String players, String teams, String sharewith) async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      String userId = loginResponse.data.user.userId.toString();
      String userName = loginResponse.data.user.username.toString();

      CommonSuccess response = await updateSharingPlan(
          userId, userName, planid, players, teams, sharewith);
      if (response.status == "true") {
        setState(() {
          _isInAsyncCall = false;
        });
        print('>>>>>>>>>>>>>>>>INSIDE Fitness LIST API>>>>>>>>>' +
            sharewith +
            '>>>>>>>>>>>>>>>>>NAmE>>>>>');
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              content: Text(
                'Your Plan was Shared!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'BebasNeue',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: <Widget>[
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

        Navigator.pop(context);
        // getFitnessLeaderBoardByFitnessId(loginResponse.data.user.userId.toString(),fitnessList[0].id);
      } else {
        setState(() {
          _isInAsyncCall = false;
        });
        print('>>>>>>>>>>>>>>>>INSIDE Fitness API>>>>>>>>>FALSE>>>>>>>>>>>');
        Toast.show("${response.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }
}
