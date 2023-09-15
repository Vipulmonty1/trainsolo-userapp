import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_teams_list_response.dart';
import 'package:trainsolo/model/get_users_response.dart';
import 'package:trainsolo/model/get_user_data_from_user_id_response.dart';
import 'package:trainsolo/screens/TrainingOnGoing.dart';
import 'package:trainsolo/utils/Constants.dart';

import 'SaveFinalGroup.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class SearchPlayesList extends StatefulWidget {
  final VoidCallback onButtonPressed;
  final Function(List<UsersData>) onDataChange;
  final List<UsersData> playerlist;
  final TeamData teamData;

  SearchPlayesList(
      {@required this.onButtonPressed,
      this.onDataChange,
      this.playerlist,
      this.teamData});
  SearchPlayesListPage createState() => SearchPlayesListPage();
}

class SearchPlayesListPage extends State<SearchPlayesList> {
  final searchController = TextEditingController();
  bool _isInAsyncCall = false;
  List<UsersData> userList = [];
  List<UsersData> selectedUserList = [];
  List<String> teamUserIds = [];
  // TODO: Could become problematic to load all users into memory as service grows
  List<UsersData> storedAllUsers = [];

  void refresh() {
    setState(() {});
  }

  List<bool> _isChecked;
  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    loadPlayers();
    // getPlayersListApiCall("");
  }

  loadPlayers() async {
    setState(() {
      _isInAsyncCall = true;
    });
    GetUsersResponse getUserListData = await getUserList();

    if (getUserListData.status == "true") {
      _isInAsyncCall = false;
      //Toast.show("${getTeamsListData.message}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      setState(() {
        userList = getUserListData.data;
        storedAllUsers = getUserListData.data;
        if (widget.teamData != null && widget.teamData.players != null) {
          teamUserIds = widget.teamData.players.split(",");
        }
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          getUserListData.message);
    }
  }

  bool fromSelectedItems(String userid) {
    if (teamUserIds.indexOf(userid) < 0) {
      return false;
    }
    return true;
  }

  void removeUser(String userid) {
    if (userid == null) {
      return;
    }
    setState(() {
      teamUserIds.remove(userid);
    });
  }

  void OnItemSelected(String userid, bool checked) {
    setState(() {
      if (checked) {
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .logEvent("Teams Player Added",
                eventProperties: {"user_id": userid});
        teamUserIds.add(userid);
      } else {
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .logEvent("Teams Player Removed",
                eventProperties: {"user_id": userid});
        teamUserIds.remove(userid);
      }
    });
  }

  searchPlayers(String searchVal) async {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Teams Search Players",
            eventProperties: {"user_search_query": searchVal});
    GetUsersResponse getUserListData = await getUserList();
    setState(() {
      if (searchVal.isNotEmpty) {
        userList = userList
            .where((user) => user.username.contains(searchVal))
            .toList();
        print("Length of user list: ${userList.length}");
      } else {
        _isInAsyncCall = true;
        if (getUserListData.status == "true") {
          _isInAsyncCall = false;
        }
        userList = getUserListData.data;
      }
    });
  }

  Future<List<UsersData>> convertUserIdsToUsersData() async {
    setState(() {
      _isInAsyncCall = true;
    });
    List<UsersData> initialList = [];
    GetUsersResponse getUserListData = await getUserList();
    if (getUserListData.status == "true") {
      _isInAsyncCall = false;
      for (UsersData usersData in getUserListData.data) {
        if (teamUserIds.contains(usersData.usrid.toString())) {
          initialList.add(usersData);
        }
      }
    }
    return initialList;
  }

  // Future<UsersData> convertSingleUserIdToUsersData(String userId) async {
  //   for (UsersData usersData in storedAllUsers) {
  //     if ()
  //   }
  // }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Team user ids: ${teamUserIds}");
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBar(
                // title: Text(' Back to Teamlist'), // You can add title here
                // leading: new IconButton(
                //   icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
                //   onPressed: () => {
                //     print("Back button was clicked ..."),
                //     widget.backButtonPressed()
                //   },
                // ),
                backgroundColor: Colors.black
                    .withOpacity(0.3), //You can make this transparent
                elevation: 0.0, //No shadow
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 5.0,
                                  left: 5.0,
                                  right: 5.0),
                              child: _GooglePlayAppBar(),
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, bottom: 5.0),
                          child: Text(
                              teamUserIds.length.toString() +
                                  " players selected",
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0,
                                        top: 0.0,
                                        bottom: 0.0,
                                        right: 0.0),
                                    child: Container(
                                      height: 95.0,
                                      child: ListView.builder(
                                          key: ObjectKey(teamUserIds),
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: teamUserIds.length,
                                          itemBuilder: (context, itemIndex) {
                                            print("Building sample ...");

                                            return FutureBuilder(
                                              future: getUserDataFromId(
                                                  teamUserIds[itemIndex]),
                                              builder: (context, snapshot) {
                                                if (snapshot.data != null) {
                                                  return playerListWidget(
                                                      snapshot.data.username,
                                                      snapshot
                                                          .data.profilepicurl,
                                                      removeUser,
                                                      teamUserIds[itemIndex]);
                                                  // snapshot.data is what being return from the above async function
                                                  // True: Return your UI element with Name and Avatar here for number in Contacts
                                                } else {
                                                  return playerListWidget(null,
                                                      null, removeUser, null);
                                                  // False: Return UI element withouut Name and Avatar
                                                }
                                              },
                                            );
                                            // print(
                                            //     "Building list player widget ...");
                                            // print("CURRENT INDEX: $itemIndex");
                                            // print(
                                            //     "Current team user ids: $teamUserIds");
                                            // return playerListWidget(
                                            //   teamUserIds[itemIndex],
                                            //   () {
                                            //     // _onItemSelectedTap(
                                            //     //     context,
                                            //     //     selectedUserList[
                                            //     //         itemIndex]);
                                            //     print("Disabled ...");
                                            //   },
                                            //   () {
                                            //     // _closeItemSelected(
                                            //     //     context,
                                            //     //     selectedUserList[
                                            //     //         itemIndex]);
                                            //     print("is this the x click?");
                                            //     setState(() {
                                            //       teamUserIds.remove(
                                            //           teamUserIds[itemIndex]);
                                            //     });
                                            //   },
                                            // );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
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
                                                left: 5.0,
                                                right: 5.0,
                                                bottom: 5.0,
                                                top: 0.0),
                                            padding: const EdgeInsets.all(1.0),
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
                                                                  color: Colors
                                                                      .red),
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
                                                CheckboxItemWidget(
                                                    userList[itemIndex]
                                                        .usrid
                                                        .toString(),
                                                    fromSelectedItems,
                                                    OnItemSelected),
                                              ],
                                            )),
                                          ),
                                        )
                                      ],
                                    ));
                              }
                              /* ItemWidget(userList[itemIndex], () {
                                      _onItemTap(context, userList[itemIndex],);
                                    }, () {
                                      _shareItem(context, userList[itemIndex]);
                                    }, () {
                                      _save(context, userList[itemIndex]);
                                    }, () {
                                      onChanged(context, userList[itemIndex]);
                                    }, itemIndex),
                              )*/
                              ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                onPressed: () async {
                                  print("Team user ids ... ${teamUserIds}");
                                  if (teamUserIds != null) {
                                    // if (widget.onDataChange != null) {
                                    //   widget.onDataChange(selectedUserList);
                                    // }
                                    List<UsersData> teamUsersData =
                                        await convertUserIdsToUsersData();
                                    print(
                                        "Widget team data: ${widget.teamData}");
                                    if (widget.teamData != null) {
                                      Amplitude.getInstance(
                                              instanceName: Constants
                                                  .AMPLITUDE_INSTANCE_NAME)
                                          .logEvent(
                                              "Teams Completed Player Modification",
                                              eventProperties: {
                                            "num_players": teamUserIds.length
                                          });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SaveFinalGroup(
                                                    teamData: widget.teamData,
                                                    playerlist: teamUsersData,
                                                    onButtonPressed: () {},
                                                  )
                                              // builder: (context) => TrainingOnGoing()
                                              ));
                                    } else {
                                      // widget.onButtonPressed();
                                      Amplitude.getInstance(
                                              instanceName: Constants
                                                  .AMPLITUDE_INSTANCE_NAME)
                                          .logEvent(
                                              "Teams Completed Player Modification",
                                              eventProperties: {
                                            "num_players": teamUserIds.length
                                          });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SaveFinalGroup(
                                                    playerlist: teamUsersData,
                                                    onButtonPressed: () {},
                                                  )
                                              // builder: (context) => TrainingOnGoing()
                                              ));
                                      initState();
                                    }
                                  } else {
                                    print(
                                        "inside list of user selected :::::::::List is Null:::::::");
                                  }
                                },
                                /* onPressed: () {
                            //  widget.onButtonPressed();
                            },*/
                                child: const Icon(Icons.arrow_forward),
                                backgroundColor:
                                    Color.fromARGB(255, 237, 28, 36),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
    );
  }

  Widget _GooglePlayAppBar() {
    return Container(
        height: 40.0,
        child: TextField(
          // onSubmitted: (String value) async {
          //   setState(() {
          //     getPlayersListApiCall(value);
          //   });
          // },
          // controller: searchController,
          /*onChanged: onItemChanged,*/
          onSubmitted: (String value) async {
            // print("Value submitted: $value");
            // getPlayersListApiCall(value);
            searchPlayers(value);
          },
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15.0),
            hintText: 'Search users',
            border: new UnderlineInputBorder(
                borderSide:
                    new BorderSide(color: Color.fromARGB(255, 237, 28, 36))),
            hintStyle: TextStyle(color: Colors.white),
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton(
                //     icon: Icon(Icons.search, color: Colors.white),
                //     onPressed: () {
                //       setState(() {
                //         getPlayersListApiCall(searchTerm)
                //         // fetchAlbum(searchController.text);
                //
                //         //     search= searchController.text;
                //         //     Navigator.push(context, MaterialPageRoute(
                //         // builder: (context) => SearchListList(searchText:'$search')));
                //       });
                //     }),
                /* IconButton(
                    icon: Icon(Icons.cancel_rounded, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        searchController.text = "";
                        //  widget.searchText="";
                        Navigator.pop(context);
                      });
                    })*/
              ],
            ),
          ),
        ));
  }

  // getPlayersListApiCall(String searchTerm) async {
  //   setState(() {
  //     _isInAsyncCall = true;
  //   });
  //   GetUsersResponse getUserListData = await getUserList();
  //
  //   if (getUserListData.status == "true") {
  //     _isInAsyncCall = false;
  //     //Toast.show("${getTeamsListData.message}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  //     setState(() {
  //       userList = getUserListData.data;
  //       _isChecked = List<bool>.filled(userList.length, false);
  //
  //       if (searchTerm.isNotEmpty) {
  //         userList = userList
  //             .where((item) => item.username.contains(searchTerm))
  //             .toList();
  //       }
  //
  //       if (widget.teamData != null && widget.teamData.players != null) {
  //         List<String> selectedPlayerIds = widget.teamData.players.split(",");
  //
  //         for (UsersData user in userList) {
  //           if (selectedPlayerIds.contains(user.usrid.toString()) ||
  //               addedPlayerIds.contains(user.usrid.toString())) {
  //             selectedUserList.add(user);
  //             _isChecked[userList.indexOf(user)] = true;
  //           }
  //         }
  //       }
  //     });
  //   } else {
  //     _isInAsyncCall = false;
  //     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
  //         getUserListData.message);
  //   }
  // }

  _save(BuildContext context, UsersData item) {
    /*  if (selectedUserList.length == 9) {
      print(
          "Length of list is ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" +
              selectedUserList.length.toString());
      showlimitDialog(context);
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

  _onItemSelectedTap(BuildContext context, UsersData item) {
    print("this is on tap _onItemSelectedTap and index is " + item.username);
  }

  _closeItemSelected(BuildContext context, UsersData item) {
    print("this is on _closeItemSelected item and index is " + item.username);
    bool exists = selectedUserList.any((file) => file.usrid == item.usrid);
    if (exists) {
      selectedUserList.remove(item);
      _isChecked[userList.indexOf(item)] = false;
      refresh();
    }
  }
}

class playerListWidget extends StatelessWidget {
  const playerListWidget(
      this.username, this.profilePicImage, this.onItemDelete, this.userId,
      {Key key})
      : super(key: key);

  final String username;
  final String profilePicImage;
  final Function onItemDelete;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          // Enables taps for child and add ripple effect when child widget is long pressed.
          child: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: 60.0,
                width: 60.0,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new NetworkImage(
                      profilePicImage != null
                          ? Constants.IMAGE_BASE_URL + "/" + profilePicImage
                          : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                    ),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onItemDelete(userId);
                },
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 237, 28, 36),
                          border: Border.all(
                            color: Color.fromARGB(255, 237, 28, 36),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Icon(Icons.close, color: Colors.white, size: 10),
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 7.0,
          ),
          GestureDetector(
            child: Align(
              alignment: Alignment.center,
              child: Text(username != null ? username : 'No Name',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.w400,
                  )),
            ),
          ),
        ],
      )),
    );
  }
}

// class playerListWidget extends StatefulWidget {
//   const playerListWidget(this.teamUserId, this.onItemTap, this.closeItem,
//       {Key key})
//       : super(key: key);
//
//   final String teamUserId;
//   final Function onItemTap;
//   final Function closeItem;
//
//   PlayerListState createState() => PlayerListState();
// }
//
// class PlayerListState extends State<playerListWidget> {
//   UserDataFromId model;
//
//   @override
//   initState() {
//     print("State for player list widget:}");
//     super.initState();
//     createUserDataFromId();
//   }
//
//   Future<UserDataFromId> createUserDataFromId() async {
//     print("Widget team user id: ${widget.teamUserId}");
//     UserDataFromId getUserData = await getUserDataFromId(widget.teamUserId);
//     print("Get user data: ${getUserData}");
//     setState(() {
//       model = getUserData;
//     });
//     print("Model: $model");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(
//           // Enables taps for child and add ripple effect when child widget is long pressed.
//           onTap: widget.onItemTap,
//           child: Column(
//             children: [
//               Stack(
//                 children: <Widget>[
//                   Container(
//                     height: 60.0,
//                     width: 60.0,
//                     decoration: new BoxDecoration(
//                       image: DecorationImage(
//                         image: new NetworkImage(
//                           model != null && model.profilepicurl != null
//                               ? Constants.IMAGE_BASE_URL +
//                                   "/" +
//                                   model.profilepicurl
//                               : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
//                         ),
//                         fit: BoxFit.fill,
//                       ),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: widget.closeItem,
//                     child: Align(
//                         alignment: Alignment.bottomRight,
//                         child: Container(
//                           width: 20.0,
//                           height: 20.0,
//                           decoration: BoxDecoration(
//                               color: Color.fromARGB(255, 237, 28, 36),
//                               border: Border.all(
//                                 color: Color.fromARGB(255, 237, 28, 36),
//                               ),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5))),
//                           child: Center(
//                             child: Icon(Icons.close,
//                                 color: Colors.white, size: 10),
//                           ),
//                         )),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 7.0,
//               ),
//               GestureDetector(
//                 onTap: widget.closeItem,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                       model != null && model.username != null
//                           ? model.username
//                           : 'No Name',
//                       maxLines: 1,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontFamily: 'Helvetica',
//                         fontWeight: FontWeight.w400,
//                       )),
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }

class CheckboxItemWidget extends StatelessWidget {
  const CheckboxItemWidget(this.userId, this.fromSelectedItems, this.onChanged,
      {Key key})
      : super(key: key);

  final String userId;
  final Function fromSelectedItems;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
        child: Checkbox(
          value: fromSelectedItems(userId),
          onChanged: (val) => {print("Val: $val"), onChanged(userId, val)},
        ),
        data: ThemeData(
          primarySwatch: Colors.green,
          unselectedWidgetColor: Colors.white, // Your color
        ));
  }
}
