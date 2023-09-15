import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/get_t_h_drills_by_category_response.dart';
import 'package:trainsolo/screens/TechHubTimeTrial.dart';
import 'package:trainsolo/trainsolo_icons_icons.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/utils/RevenueCatUtilities.dart';
import '../api/api_service.dart';
import 'package:toast/toast.dart';

import 'SubscriptionBlocker.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

class TechHubDrillCategoryWise extends StatefulWidget {
  final String tabName;
  final String categoryName;
  final VoidCallback onBackCallbackTechHubBegginer;

  TechHubDrillCategoryWise(
      {@required this.tabName,
      this.categoryName,
      this.onBackCallbackTechHubBegginer});

  TechHubDrillCategoryWisePage createState() => TechHubDrillCategoryWisePage();
}

class TechHubDrillCategoryWisePage extends State<TechHubDrillCategoryWise> {
  bool _isInAsyncCall = false;
  GlobalKey<PageContainerState> key = GlobalKey();
  List<Drills> drillList = [];
  final searchController = TextEditingController();
  String search;
  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    fetchAlbum("");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: new BoxDecoration(color: Colors.black),
          padding: EdgeInsets.only(top: 25.0),
          child: ModalProgressHUD(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: _GooglePlayAppBar(),
                ),
                SizedBox(
                  //Use of SizedBox
                  height: 10,
                ),
                Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: 100,
                      height: 30, // <-- Your width
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
                                  TrainsoloIcons.drill_record,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              Text(
                                "Shuffle",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => {
                            Amplitude.getInstance(
                                    instanceName:
                                        Constants.AMPLITUDE_INSTANCE_NAME)
                                .logEvent("Tech Hub Shuffle Clicked"),
                            fetchAlbum("")
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 237, 28, 36))),
                        ),
                      ),
                    )),
                SizedBox(
                  //Use of SizedBox
                  height: 10,
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: drillList.length,
                    // Number of widget to be created.
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
      ),
    );
  }

  fetchAlbum(String strSearch) async {
    List<Drills> outPutDrills = [];
    setState(() {
      _isInAsyncCall = true;
    });
    GetTHDrillsByCategoryResponse getTechHubDrills =
        await getTHDrillsByCategory(widget.tabName, widget.categoryName);

    if (getTechHubDrills.status == "true") {
      _isInAsyncCall = false;
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Tech Hub Drill Category Clicked",
              eventProperties: {"drill_category": widget.categoryName});
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS TRUE>>>>>>>>>>>>>>>>>>>>' +
          widget.categoryName);
      Toast.show("${getTechHubDrills.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        drillList = getTechHubDrills.data;

        if (strSearch.isEmpty) {
          // if the search field is empty or only contains white-space, we'll display all users
          outPutDrills = drillList;
        } else {
          outPutDrills = drillList
              .where((drills) => drills.title
                  .toString()
                  .toLowerCase()
                  .contains(strSearch.toLowerCase()))
              .toList();
          // we use the toLowerCase() method to make it case-insensitive
        }
        shuffle(outPutDrills, 0, outPutDrills.length);
      });
    } else {
      _isInAsyncCall = false;

      Toast.show("${getTechHubDrills.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void shuffle(List elements, int start, int end) {
    List<Drills> outPutDrills = [];
    Random random = Random();
    end ??= elements.length;
    var length = end - start;
    while (length > 1) {
      var pos = random.nextInt(length);
      length--;
      var tmp1 = elements[start + pos];
      elements[start + pos] = elements[start + length];
      elements[start + length] = tmp1;
      if (outPutDrills.length < int.parse(Constants.LIMIT_DRILLS)) {
        outPutDrills.add(tmp1);
      }
    }
    drillList = outPutDrills;
  }

  Future<void> _blockWithSubscriptionTechHub(
      BuildContext context, Drills item) async {
    bool shouldRenderSubscription = await checkAPIBlocker();
    bool userEntitled = await checkNonFitnessAccess();
    if (userEntitled || !shouldRenderSubscription) {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Tech Hub Drill Clicked", eventProperties: {
        "drill_name": item.title,
        "drill_id": item.drillid
      });
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new TechHubTimeTrial(
                  drillItem: item,
                  onBackCallback: widget.onBackCallbackTechHubBegginer)));
    } else {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Subscription Blocker Rendered",
              eventProperties: {"source": "tech_hub_drill_clicked"});
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return SubscriptionBlocker(() => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new TechHubTimeTrial(
                        drillItem: item,
                        onBackCallback:
                            widget.onBackCallbackTechHubBegginer))));
          });
    }
  }

  _onItemTap(BuildContext context, Drills item, List<Drills> drillList) {
    print("this is on tap item and index is " + item.title);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _blockWithSubscriptionTechHub(context, item));

    /* Navigator.push(context, MaterialPageRoute(
        builder: (context) => new TechHubTimeTrial(drillItem:item)
    ));*/
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

  Widget _GooglePlayAppBar() {
    return Container(
        height: 50.0,
        child: TextField(
          controller: searchController,
          onSubmitted: (String value) async {
            setState(() {
              search = searchController.text;
              fetchAlbum(search);
              searchController.text = "";
            });
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15.0),
            border: OutlineInputBorder(),
            hintText: 'Search Drills',
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
                  Amplitude.getInstance(
                          instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                      .logEvent("Tech Hub Search Drills Query",
                          eventProperties: {
                        "search_query": searchController.text
                      });
                  setState(() {
                    search = searchController.text;
                    fetchAlbum(search);
                    searchController.text = "";
                  });
                }),
          ),
        ));
  }
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
        height: 380,
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
                                            const EdgeInsets.only(top: 0.0),
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
                                              : '',
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
                                // Expanded(
                                //   flex: 0,
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(bottom: 4.0),
                                //     //icon for share and save  list
                                //     child: Row(
                                //       children: [
                                //         Padding(
                                //             padding: EdgeInsets.all(7.0),
                                //             child: GestureDetector(
                                //               onTap: _save,
                                //               child: Icon(
                                //                 Icons.description,
                                //                 color: Colors.white,
                                //                 size: 24.0,
                                //               ),
                                //             )),
                                //         Padding(
                                //           padding: EdgeInsets.all(7.0),
                                //           child: GestureDetector(
                                //             onTap: _shareItem,
                                //             child: Icon(
                                //               TrainsoloIcons.share,
                                //               color: Colors.white,
                                //               size: 24.0,
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // )
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
                            // GestureDetector(
                            //     onTap: onItemTap,
                            //     child: Container(
                            //       width: 70,
                            //       height: 25,
                            //       decoration: BoxDecoration(
                            //         border: Border.all(
                            //           color: Colors.white,
                            //         ),
                            //         borderRadius:
                            //             new BorderRadius.circular(7.0),
                            //       ),
                            //       child: Center(
                            //         child: Text("Tap to record",
                            //             maxLines: 1,
                            //             style: TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 10,
                            //               fontFamily: 'HelveticaNeue',
                            //               fontWeight: FontWeight.w400,
                            //             )),
                            //       ),
                            //     )),
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
