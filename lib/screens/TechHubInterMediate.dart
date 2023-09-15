import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:trainsolo/model/ItemModel.dart';
import 'package:trainsolo/screens/TechHubDrillRecord.dart';

class TechHubInterMediate extends StatefulWidget {
  TechHubInterMediatePage createState() => TechHubInterMediatePage();
}

class TechHubInterMediatePage extends State<TechHubInterMediate> {
  bool _isInAsyncCall = false;
  GlobalKey<PageContainerState> key = GlobalKey();

  final List<ItemModel> drillList = [
    ItemModel(
        1,
        'https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp',
        'Beep test',
        '',
        true),
    ItemModel(
        2,
        'https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp',
        'Nike spark Yo-Yo test',
        '',
        true),
    ItemModel(
        1,
        'https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp',
        'Beep test',
        '',
        true),
    ItemModel(
        2,
        'https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp',
        'Nike spark Yo-Yo test',
        '',
        true),
    ItemModel(
        1,
        'https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp',
        'Beep test',
        '',
        true),
    ItemModel(
        2,
        'https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp',
        'Nike spark Yo-Yo test',
        '',
        true),
    ItemModel(
        1,
        'https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp',
        'Beep test',
        '',
        true),
    ItemModel(
        2,
        'https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp',
        'Nike spark Yo-Yo test',
        '',
        true),
  ];

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
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      minWidth: 150.0,
                      height: 50.0,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        textColor: Colors.black,
                        color: Color.fromARGB(255, 237, 28, 36),
                        child: new Column(
                          children: [
                            Text(
                              "DRILL RECORDS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'HelveticaNeue',
                              ),
                            ),
                          ],
                        ),
                        /*  onPressed: widget.onButtonPressed,*/
                        onPressed: () => {
                          /* Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => TrainingOnGoing(drillItem: drillListFromPlan[0],drillList:drillListFromPlan)
                                          // builder: (context) => TrainingOnGoing()
                                        )),*/
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: Color.fromARGB(255, 237, 28, 36))),
                      ),
                    ),
                  ),
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
}

_onItemTap(BuildContext context, ItemModel item, List<ItemModel> drillList) {
  print(
      "this is on tap item and :::::::::::::::::intermediate::::::::::::::::::::::::index is " +
          item.title);

  Navigator.push(
      context, MaterialPageRoute(builder: (context) => TechHubDrillRecord()));
}

_closeItem(BuildContext context, ItemModel item, bool isInAsyncCall) {
  print("this is on tap _closeItem and index is " + item.title);
  //deleteDrill(item,context,isInAsyncCall);
}

_analysis(BuildContext context, ItemModel item) {
  print("this is on tap _analysis and index is " + item.title);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this.closeItem, this.analysis,
      {Key key})
      : super(key: key);

  final ItemModel model;
  final Function onItemTap;
  final Function closeItem;
  final Function analysis;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: Container(
        height: 170,
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox.expand(
                            child: FittedBox(
                              child: CachedNetworkImage(
                                imageUrl: model.image != null
                                    ? model.image
                                    : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                                placeholder: (context, url) => Transform.scale(
                                  scale: 0.2,
                                  child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 237, 28, 36)),
                                ),
                                errorWidget: (context, url, error) =>
                                    Transform.scale(
                                  scale: 0.7,
                                  child: Icon(Icons.image, color: Colors.grey),
                                ),
                              ),
                              fit: BoxFit.cover,
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
                            ),
                            Text('Some more information about the mission',
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
