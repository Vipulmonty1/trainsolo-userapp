import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_users_response.dart';
import 'package:trainsolo/model/shared_stats_users_data_response.dart';
import 'package:trainsolo/model/training_complete_info.dart';
import 'package:trainsolo/utils/Constants.dart';

import 'TrainingOnGoingComplete.dart';

class SharedStatsDetails extends StatefulWidget {
  final String title;
  final String planID;
  SharedStatsDetails({@required this.title, this.planID});

  SharedStatsDetailsPage createState() => SharedStatsDetailsPage();
}

class SharedStatsDetailsPage extends State<SharedStatsDetails> {
  final searchController = TextEditingController();
  bool _isInAsyncCall = false;
  List<SharedStatsUsersData> _items = [];
  List<UsersData> selectedUserList = [];

  //final List<ItemModel> _items = [];

  void refresh() {
    setState(() {});
  }

  List<bool> _isChecked;
  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    //_isChecked = List<bool>.filled(_items.length, false);
    getPlayersListApiCall(widget.planID.toString());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, size: 28, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      child: Text(
                        widget.title.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'BebasNeue',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 15.0, top: 0, bottom: 10),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    'PLAYERS LIST',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _items.length,
                              // Number of widget to be created.
                              itemBuilder: (context, itemIndex) {
                                return InkWell(
                                    onTap: () {
                                      // put some code here.
                                      _ShowReport(context, _items[itemIndex]);
                                    },
                                    child: Row(
                                      //height: 85,
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
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                            ),
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
                                                            imageUrl: _items[
                                                                            itemIndex]
                                                                        .thumbnailname !=
                                                                    null
                                                                ? Constants
                                                                        .IMAGE_BASE_URL +
                                                                    "/" +
                                                                    _items[itemIndex]
                                                                        .thumbnailname
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
                                                                _items[itemIndex]
                                                                        .username ??
                                                                    "NEW PLAYERS",
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
                                                                        _items[itemIndex]
                                                                            .positioncode,
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
                                                                        _items[itemIndex].iscompleted ==
                                                                                1
                                                                            ? "SESSION REPORT"
                                                                            : "",
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
                                                    value: _items[itemIndex]
                                                                .iscompleted ==
                                                            1
                                                        ? true
                                                        : false,
                                                    onChanged: (val) {
                                                      setState(
                                                        () {
                                                          _isChecked[
                                                              itemIndex] = val;
                                                          //_save(context,userList[itemIndex]);
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
                              }),
                        ),
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

  getPlayersListApiCall(String plnID) async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedStatsUsersResponse getUserListData =
        await getSharedPlanUserList(plnID);
    if (getUserListData.status == "true") {
      _isInAsyncCall = false;
      //Toast.show("${getTeamsListData.message}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      setState(() {
        _items = getUserListData.data;
        _isChecked = List<bool>.filled(_items.length, false);
      });
    } else {
      _isInAsyncCall = false;
    }
  }

  _ShowReport(BuildContext context, SharedStatsUsersData item) async {
    if (item.iscompleted == 1) {
      TrainingCompleteInfo response = await getUserPractiseDuration(
          item.usrid.toString(),
          item.username.toString(),
          item.userplanid.toString());

//      var message = response.message;
      if (response.status == "true") {
        if (response.data != null && response.data.length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TrainingOnGoingComplete(response.data.first)));
        }
      } else {}
    }
  }
}

class playerListWidget extends StatelessWidget {
  const playerListWidget(this.model, this.onItemTap, this.closeItem, {Key key})
      : super(key: key);

  final UsersData model;
  final Function onItemTap;
  final Function closeItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          // Enables taps for child and add ripple effect when child widget is long pressed.
          onTap: onItemTap,
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
                          model.profilepicurl != null
                              ? Constants.IMAGE_BASE_URL +
                                  "/" +
                                  model.profilepicurl
                              : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                        ),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Positioned(
                    top: 17,
                    left: 17,
                    height: 43,
                    width: 43,
                    child: GestureDetector(
                      onTap: closeItem,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 10),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 7.0,
              ),
              Positioned(
                top: 65,
                left: 30,
                height: 43,
                width: 43,
                child: GestureDetector(
                  onTap: closeItem,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        model.username != null ? model.username : 'No Name',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
