import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/model/get_all_t_h_drill_records_response.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:trainsolo/utils/Constants.dart';
import '../api/api_service.dart';
import 'package:toast/toast.dart';

class TechHubDrillRecord extends StatefulWidget {
  TechHubDrillRecordPage createState() => TechHubDrillRecordPage();
}

class TechHubDrillRecordPage extends State<TechHubDrillRecord> {
  bool _isInAsyncCall = false;
  GlobalKey<PageContainerState> key = GlobalKey();
  String userId = "";
  String userName = "";
  String drillId = "0";
  List<Drills> drillList = [];

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    fetchAlbum();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: new BoxDecoration(color: Colors.black),
        child: ModalProgressHUD(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, size: 28, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      "Drill Records",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'BebasNeue',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                    // profile image on top if we want to show on top profile image
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      height: 50, // <-- Your width
                      child: ButtonTheme(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: Color.fromARGB(255, 237, 28, 36),
                          child: new Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 3.0, right: 3.0),
                                child: Icon(
                                  TrainsoloIcons.football,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              Text(
                                "NEW DRILLS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => {
                            Navigator.pop(context),
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 237, 28, 36))),
                        ),
                      ),
                    )),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: drillList.length,
                  itemBuilder: (context, itemIndex) =>
                      ItemWidget(drillList[itemIndex], () {
                    _onItemTap(context, drillList[itemIndex], drillList);
                  }, () {
                    _shareItem(context, drillList[itemIndex], _isInAsyncCall);
                  }, () {
                    _taptoRecord(context, drillList[itemIndex]);
                  }, () {
                    _save(context, drillList[itemIndex]);
                  }),
                ),
              )
            ],
          ),
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

  fetchAlbum() async {
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
    }
    GetAllTHDrillRecordsResponse getallthdrillrecords =
        await getAllTHDrillRecords(userName, userId);

    if (getallthdrillrecords.status == "true") {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS TRUE>>>>>>>>>>>>>>>>>>>>');
      Toast.show("${getallthdrillrecords.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        drillList = getallthdrillrecords.data;
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          getallthdrillrecords.message);
      Toast.show("${getallthdrillrecords.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

    /* if(widget.categoryName != null){

     // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SEARCH TEXT IS >>>>>>INSIDE COMMON>>>>>>>>>>>>>>'+widget.searchText);


    }else{


     // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SEARCH TEXT IS >>>>>>INSIDE COMMON>>>>>>>>>>>>>>'+widget.searchText);


    }*/
  }
}

_onItemTap(BuildContext context, Drills item, List<Drills> drillList) {
  print("this is on tap item and index is " + item.title);

  /*Navigator.push(context, MaterialPageRoute(
      builder: (context) => FitnessTestRecordProgrss()));*/
}

_shareItem(BuildContext context, Drills item, bool isInAsyncCall) {
  print("this is on tap _shareItem and index is " + item.title);
  //deleteDrill(item,context,isInAsyncCall);
}

_taptoRecord(BuildContext context, Drills item) {
  print("this is on tap _taptoRecord and index is " + item.title);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

_save(BuildContext context, Drills item) {
  print("this is on tap save and index is " + item.title);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this._shareItem,
      this._taptoRecord, this._save,
      {Key key})
      : super(key: key);

  final Drills model;
  final Function onItemTap;
  final Function _shareItem;
  final Function _taptoRecord;
  final Function _save;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: Container(
        height: 370,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: new BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 0.0, right: 0.0, left: 0.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox.expand(
                                child: FittedBox(
                                  child: CachedNetworkImage(
                                    imageUrl: model.thumbnail != null
                                        ? model.thumbnail
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
                                      scale: 0.7,
                                      child:
                                          Icon(Icons.image, color: Colors.grey),
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: GestureDetector(
                                    onTap: _shareItem,
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 0.0, bottom: 0.0, right: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                        child: Text(
                                            model.title != null
                                                ? model.title
                                                : 'No title',
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'HelveticaNeue',
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ),
                                      Text(
                                          model.drilldescription != null
                                              ? model.drilldescription
                                              : 'Some more information about the mission',
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontFamily: 'HelveticaNeue',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    //icon for share and save  list
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(7.0),
                                            child: GestureDetector(
                                              onTap: _save,
                                              child: Icon(
                                                Icons.description,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                            )),
                                        Padding(
                                          padding: EdgeInsets.all(7.0),
                                          child: GestureDetector(
                                            onTap: _shareItem,
                                            child: Icon(
                                              TrainsoloIcons.share,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 0.0, bottom: 0.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: IconButton(
                                              icon: Container(
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/medal_first.png"),
                                                        fit: BoxFit.cover)),
                                              ),
                                              onPressed: () {},
                                            ),
                                            /* Icon(
                                                Icons.admin_panel_settings,
                                                color: Colors.white),*/
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Text(
                                                model.bronze != null
                                                    ? model.bronze.toString() +
                                                        "+"
                                                    : '0',
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'HelveticaNeue',
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: IconButton(
                                              icon: Container(
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/medal_second.png"),
                                                        fit: BoxFit.cover)),
                                              ),
                                              onPressed: () {},
                                            ),
                                            /* Icon(
                                                Icons.admin_panel_settings,
                                                color: Colors.white),*/
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                                model.silver != null
                                                    ? model.silver.toString() +
                                                        "+"
                                                    : '0',
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'HelveticaNeue',
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: IconButton(
                                              icon: Container(
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/medal_thired.png"),
                                                        fit: BoxFit.cover)),
                                              ),
                                              onPressed: () {},
                                            ),
                                            /* Icon(
                                                Icons.admin_panel_settings,
                                                color: Colors.white),*/
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                                model.gold != null
                                                    ? model.gold.toString() +
                                                        "+"
                                                    : '0',
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'HelveticaNeue',
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: _taptoRecord,
                                child: Container(
                                  width: 70,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius:
                                        new BorderRadius.circular(7.0),
                                  ),
                                  child: Center(
                                    child: Text("Tap to record",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontFamily: 'HelveticaNeue',
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
