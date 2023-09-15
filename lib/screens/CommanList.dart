import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/screens/TrainingOnGoing.dart';
import 'package:trainsolo/screens/SubscriptionBlocker.dart';
import 'package:trainsolo/utils/RevenueCatUtilities.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

// ignore: must_be_immutable
class CommonList extends StatefulWidget {
  final String categoryName;
  Function onItemSelected;
  Function fromSelectedItems;

  CommonList(
      {@required this.categoryName,
      @required this.onItemSelected,
      @required this.fromSelectedItems});
  CommonListPage createState() => CommonListPage();
}

class CommonListPage extends State<CommonList> {
  bool _isInAsyncCall = false;
  List<Drills> drillList, drills = [];
  final searchController = TextEditingController();
  String search = '';

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    fetchAlbum();
  }

  Widget buildPageView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5),
            height: 40.0,
            child: TextField(
              controller: searchController,
              onSubmitted: (String value) async {
                updateStateForSearch();
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
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
                      updateStateForSearch();
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    }),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ListView.builder(
                    itemCount: drills.length, // Number of widget to be created.
                    itemBuilder: (context, itemIndex) =>
                        ItemWidget(drills[itemIndex], () {
                      _onItemTap(context, drills[itemIndex], drills);
                    }, () {
                      _closeItem(context, drills[itemIndex], _isInAsyncCall);
                    }, () {
                      _analysis(context, drills[itemIndex]);
                    }, widget.onItemSelected, widget.fromSelectedItems),
                  )))
        ],
      ),
    );
  }

  Future<void> _blockWithSubscriptionBuild(
      BuildContext context, Drills item, bool analysisClicked) async {
    bool shouldRenderSubscription = await checkAPIBlocker();
    bool userEntitled = await checkNonFitnessAccess();
    if (userEntitled || !shouldRenderSubscription) {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Build Plan Drill Clicked", eventProperties: {
        "drill_name": item.title,
        "drill_id": item.drillid,
        "analysis_clicked": analysisClicked
      });
      int landingTab = 0;
      if (analysisClicked) {
        landingTab = 1;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TrainingOnGoing(
                  drillItem: item,
                  drillList: drillList,
                  tabControllerIndex: landingTab)
              // builder: (context) => TrainingOnGoing()
              ));
    } else {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Subscription Blocker Rendered",
              eventProperties: {"source": "train_build_plan_drill_clicked"});
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return SubscriptionBlocker(() => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TrainingOnGoing(drillItem: item, drillList: drillList)
                    // builder: (context) => TrainingOnGoing()
                    )));
          });
    }
  }

  void pageChanged(int index) {
    setState(() {
      //bottomSelectedIndex = index;
    });
  }

  void updateStateForSearch() {
    search = searchController.text;
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Build Plan Search Query",
            eventProperties: {"search_query": searchController.text});
    drills = drillList
        .where((element) =>
            element.title.toLowerCase().contains(search.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        child: buildPageView(),
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
    );
  }

  fetchAlbum() async {
    setState(() {
      _isInAsyncCall = true;
    });
    GetDrillResponse getDrills = await getDrillByCategory(widget.categoryName);

    if (getDrills.status == "true") {
      _isInAsyncCall = false;
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Build Plan Category Loaded",
              eventProperties: {"drill_category": widget.categoryName});
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS TRUE>>>>>>>>>>>>>>>>>>>>' +
          widget.categoryName);
      Toast.show("${getDrills.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        drillList = getDrills.data;
        drills = List.castFrom(drillList);
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          getDrills.message);
      Toast.show("${getDrills.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

    /* if(widget.categoryName != null){

     // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SEARCH TEXT IS >>>>>>INSIDE COMMON>>>>>>>>>>>>>>'+widget.searchText);


    }else{


     // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SEARCH TEXT IS >>>>>>INSIDE COMMON>>>>>>>>>>>>>>'+widget.searchText);


    }*/
  }

  _onItemTap(BuildContext context, Drills item, List<Drills> drillList) {
    print("this is on tap item and index is " + item.title);
    /* Navigator.of(context).pushNamed("trainingOngoing");*/
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _blockWithSubscriptionBuild(context, item, false));
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             TrainingOnGoing(drillItem: item, drillList: drillList)
    //         // builder: (context) => TrainingOnGoing()
    //         ));

    /* builder: (context) =>  VimeoPlayerWidget(
        videoId: '395212534',
        newKey: UniqueKey(),
      )));*/
  }

  _analysis(BuildContext context, Drills item) {
    print("this is on tap _analysis and index is " + item.title);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _blockWithSubscriptionBuild(context, item, true));
    /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
  }
}
/*deleteDrill(Drills item,BuildContext context, bool isInAsyncCall) async {

  isInAsyncCall = true;

  GetDrillResponse getDrills = await getDrillByCategory(item.i);

  if (getDrills.status=="true") {
    isInAsyncCall = false;
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS TRUE>>>>>>>>>>>>>>>>>>>>' + widget.categoryName);
    Toast.show("${getDrills.message}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

  } else {
    isInAsyncCall = false;
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>'+getDrills.message);
    Toast.show("${getDrills.message}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }

  */ /* if(widget.categoryName != null){

     // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SEARCH TEXT IS >>>>>>INSIDE COMMON>>>>>>>>>>>>>>'+widget.searchText);


    }else{


     // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SEARCH TEXT IS >>>>>>INSIDE COMMON>>>>>>>>>>>>>>'+widget.searchText);


    }*/ /*


}*/

_closeItem(BuildContext context, Drills item, bool isInAsyncCall) {
  print("this is on tap _closeItem and index is " + item.title);
  //deleteDrill(item,context,isInAsyncCall);
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this.closeItem, this.analysis,
      this.onItemSelected, this.fromSelectedItems,
      {Key key})
      : super(key: key);

  final Drills model;
  final Function onItemTap;
  final Function closeItem;
  final Function analysis;
  final Function onItemSelected;
  final Function fromSelectedItems;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: Container(
          height: 130,
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
                  child: Stack(
                    children: <Widget>[
                      Container(
                          child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 8.0, bottom: 8.0, right: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              model.title != null
                                                  ? model.title
                                                  : 'No title',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                          Text(
                                              model.drilldescription != null
                                                  ? model.drilldescription
                                                  : 'No description',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 0,
                                      child: GestureDetector(
                                          onTap: analysis,
                                          child: Container(
                                            width: 70,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                            ),
                                            child: Center(
                                              child: Text("Analysis",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'HelveticaNeue',
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ),
                                          )))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, right: 5.0, left: 0.0),
                              child: ClipRRect(
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
                                            color: Color.fromARGB(
                                                255, 237, 28, 36)),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Transform.scale(
                                        scale: 0.7,
                                        child: Icon(Icons.image,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                      Positioned(
                        right: 10,
                        child: Theme(
                          child: Checkbox(
                            value: fromSelectedItems(model),
                            onChanged: (val) {
                              onItemSelected(model, val);
                            },
                          ),
                          data: ThemeData(
                            primarySwatch: Colors.green,
                            unselectedWidgetColor:
                                Color.fromARGB(255, 237, 28, 36), // Your color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
