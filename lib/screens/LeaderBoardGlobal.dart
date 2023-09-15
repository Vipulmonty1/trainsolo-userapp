import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_global_leader_board_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:trainsolo/utils/Constants.dart';

class LeaderBoardGlobal extends StatefulWidget {
  final String pagename;

  LeaderBoardGlobal({@required this.pagename});

  LeaderBoardGlobalPage createState() => LeaderBoardGlobalPage();
}

class LeaderBoardGlobalPage extends State<LeaderBoardGlobal> {
  bool _isInAsyncCall = false;
  List<LeaderBoardData> leaderBoardlist = [];
  LeaderBoardData firstRank = LeaderBoardData();
  LeaderBoardData secondRank = LeaderBoardData();
  LeaderBoardData thirdRank = LeaderBoardData();
  LeaderBoardData currentUser = LeaderBoardData();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: currentUser != null
                      ? ItemWidget(currentUser, () {
                          _onItemTap(context, currentUser);
                        })
                      : SizedBox(
                          //Use of SizedBox
                          height: 1,
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("2nd",
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
                                  child: CachedNetworkImage(
                                    imageUrl: secondRank.profilePhoto != null
                                        ? Constants.IMAGE_BASE_URL +
                                            "/" +
                                            secondRank.profilePhoto
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
                        SizedBox(
                          //Use of SizedBox
                          height: 2,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 100),
                          child: Text(secondRank.name ?? "",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(secondRank.desc ?? "",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              TrainsoloIcons.crown,
                              color: Colors.yellow,
                              size: 35.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, top: 0.0, bottom: 8.0, right: 0.0),
                            child: Container(
                              width: 95,
                              height: 95,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    child: CachedNetworkImage(
                                      imageUrl: firstRank.profilePhoto != null
                                          ? Constants.IMAGE_BASE_URL +
                                              "/" +
                                              firstRank.profilePhoto
                                          : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                                      placeholder: (context, url) =>
                                          Transform.scale(
                                        scale: 0.2,
                                        child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                255, 237, 28, 36)),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Transform.scale(
                                        scale: 1.5,
                                        child: Icon(Icons.image,
                                            color: Colors.grey),
                                      ),
                                    ),
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
                            child: Text(firstRank.name ?? "First Rank Name",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Text(firstRank.desc ?? "First Rank tagline",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: 'HelveticaNeue',
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("3rd",
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
                                child: CachedNetworkImage(
                                  imageUrl: thirdRank.profilePhoto != null
                                      ? Constants.IMAGE_BASE_URL +
                                          "/" +
                                          thirdRank.profilePhoto
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
                                    scale: 5,
                                    child:
                                        Icon(Icons.image, color: Colors.grey),
                                  ),
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
                          child: Text(thirdRank.name ?? "Third Rank Name",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(thirdRank.desc ?? "Third Rank Tagline",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ],
                    ),
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
                      itemBuilder: (context, itemIndex) =>
                          ItemWidget(leaderBoardlist[itemIndex], () {
                        _onItemTap(context, leaderBoardlist[itemIndex]);
                      }),
                    ))
              ],
            ),
          )),
    );
  }

  Future<void> getglobaliderboardlist() async {
    setState(() {
      _isInAsyncCall = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      GetGlobalLeaderBoardResponse globleaderboard =
          await getGlobalLeaderBoard(loginResponse.data.user.userId.toString());
      List<LeaderBoardData> leaderBoardlist1 = [];
      if (globleaderboard.status == "true") {
        _isInAsyncCall = false;
        Toast.show("${globleaderboard.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

        leaderBoardlist1 = globleaderboard.data;
        firstRank = new LeaderBoardData();
        secondRank = new LeaderBoardData();
        thirdRank = new LeaderBoardData();
        currentUser = new LeaderBoardData();

        leaderBoardlist1.forEach((element) {
          if (element.position == "1") {
            firstRank = element;
            //leaderBoardlist.remove(element);
          } else if (element.position == "2") {
            secondRank = element;
            //leaderBoardlist.remove(element);
          } else if (element.position == "3") {
            thirdRank = element;
            //leaderBoardlist.remove(element);
          } else if (element.usrid.toString() ==
              loginResponse.data.user.userId.toString()) {
            currentUser = element;
            //leaderBoardlist.remove(element);
          }
        });

        leaderBoardlist = leaderBoardlist1
            .where((element) =>
                int.parse(element.position) > 3 &&
                element.usrid.toString() !=
                    loginResponse.data.user.userId.toString())
            .toList();
        setState(() {});
      } else {
        _isInAsyncCall = false;

        Toast.show("${globleaderboard.message}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getglobaliderboardlist();
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
  /* Navigator.push(
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
        child: this.model.position != null
            ? Container(
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
                                  left: 20.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                  right: 20.0),
                              child: Text(
                                  model != null && model.position != null
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
                                  left: 8.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                  right: 20.0),
                              child: Container(
                                width: 60,
                                height: 80,
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
                                              color: Color.fromARGB(
                                                  255, 237, 28, 36)),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Transform.scale(
                                          scale: 1.5,
                                          child: Icon(Icons.image,
                                              color: Colors.grey),
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
                ))
            : SizedBox(
                //Use of SizedBox
                height: 1,
              ));
  }
}
