import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';

import 'package:trainsolo/model/mission_leaderboard_response.dart';
import 'package:trainsolo/utils/Constants.dart';

class MissionLeaderBoard extends StatefulWidget {
  MissionLeaderBoardPage createState() => MissionLeaderBoardPage();
}

class MissionLeaderBoardPage extends State<MissionLeaderBoard> {
  List<MissionLeaderBoardData> missionLeaderBoardData = [];
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    getMissionLeaderBoardCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        child: buildPageView(),
        inAsyncCall: _isInAsyncCall,
        //color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
    );
  }

  Widget buildPageView() {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: ListView.builder(
                      // Widget which creates [ItemWidget] in scrollable list.
                      itemCount: missionLeaderBoardData
                          .length, // Number of widget to be created.
                      itemBuilder: (context, itemIndex) =>
                          ItemWidget(missionLeaderBoardData[itemIndex]),
                    )),
              ),
            ),
          ]),
    );
  }

  Future<void> getMissionLeaderBoardCall() async {
    setState(() {
      _isInAsyncCall = true;
    });

    MissionLeaderBoardResponse missionLeaderBoardresponse =
        await getMissionLeaderBoard();
    print(missionLeaderBoardresponse.data);
    if (missionLeaderBoardresponse.status == "true") {
      setState(() {
        _isInAsyncCall = false;
      });
      Toast.show("${missionLeaderBoardresponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        missionLeaderBoardData = missionLeaderBoardresponse.data;
      });
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      print(
          "::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>INSIDE getMissionLeaderBoardCall>>>>>>>>>>>>>FAIL>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      Toast.show("${missionLeaderBoardresponse.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, {Key key}) : super(key: key);

  final MissionLeaderBoardData model;
  // ignore: unused_field

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.

      child: Container(
          height: 90,
          //color: const Color(0xFFFF0000),
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
                          child: Container(
                            width: 60,
                            height: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox.expand(
                                child: FittedBox(
                                  child: CachedNetworkImage(
                                    imageUrl: model.profilepic != null
                                        ? Constants.IMAGE_BASE_URL +
                                            "/" +
                                            model.profilepic
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
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  model.username != null
                                      ? model.username
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
                                  model.sessionCompleted != null
                                      ? "Session Completed: " +
                                          model.sessionCompleted.toString()
                                      : "Session Completed: 0",
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
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          color: Colors.white,
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: SizedBox.expand(
                              child: FittedBox(
                                child: CachedNetworkImage(
                                  imageUrl: model.logo != null
                                      ? model.logo
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
                      )
                    ],
                  )),
                ),
              )
            ],
          )),
    );
  }
}
