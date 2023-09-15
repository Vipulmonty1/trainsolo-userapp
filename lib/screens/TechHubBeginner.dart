import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_all_tech_hub_response.dart';
import 'package:trainsolo/screens/TechHubDrillCategoryWise.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

class TechHubBeginner extends StatefulWidget {
  final String categoryName;

  TechHubBeginner({@required this.categoryName});
  TechHubBeginnerPage createState() => TechHubBeginnerPage();
}

class TechHubBeginnerPage extends State<TechHubBeginner> {
  bool _isInAsyncCall = false;
  GlobalKey<PageContainerState> key = GlobalKey();
  List<Category> drillList = [];

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: new BoxDecoration(color: Colors.black),
          child: ModalProgressHUD(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: drillList.length,
                    // Number of widget to be created.
                    itemBuilder: (context, itemIndex) =>
                        ItemWidget(drillList[itemIndex], () {
                      _onItemTap(context, drillList[itemIndex], drillList);
                    }, () {
                      _closeItem(context, drillList[itemIndex], _isInAsyncCall);
                    }, () {
                      _analysis(context, drillList[itemIndex]);
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

  fetchAlbum() async {
    setState(() {
      _isInAsyncCall = true;
    });
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Tech Hub Difficulty Loaded",
            eventProperties: {"difficulty": widget.categoryName});
    GetAllTechHubResponse getTechHub = await getAllTechHub(widget.categoryName);

    if (getTechHub.status == "true") {
      _isInAsyncCall = false;
      Toast.show("${getTechHub.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        drillList = getTechHub.data;
      });
    } else {
      _isInAsyncCall = false;
      Toast.show("${getTechHub.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  _onItemTap(BuildContext context, Category item, List<Category> drillList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TechHubDrillCategoryWise(
                tabName: widget.categoryName,
                categoryName: item.category,
                onBackCallbackTechHubBegginer: () => {
                      //goBack(context),
                    })));
  }

  _closeItem(BuildContext context, Category item, bool isInAsyncCall) {}

  _analysis(BuildContext context, Category item) {}
}

goBack(BuildContext context) {
  Navigator.pop(context);
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this.closeItem, this.analysis,
      {Key key})
      : super(key: key);

  final Category model;
  final Function onItemTap;
  final Function closeItem;
  final Function analysis;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox.expand(
                            child: FittedBox(
                              child: Image.asset(
                                model.category == "Ball Work"
                                    ? "assets/ball_work.png"
                                    : model.category == "Juggling"
                                        ? "assets/juggling.png"
                                        : "assets/wall_work.png",
                                height: 100,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 0.0, right: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                  model.category != null
                                      ? model.category
                                      : 'No title',
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            /*Text('Some more information about the mission',
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: 'HelveticaNeue',
                                  fontWeight: FontWeight.w400,
                                )),
                                */
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
