import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/search_drills_response.dart';
import 'package:trainsolo/screens/TrainingOnGoing.dart';

// ignore: must_be_immutable
class SearchListList extends StatefulWidget {
  String searchText;

  SearchListList({@required this.searchText});

  SearchListListPage createState() => SearchListListPage();
}

class SearchListListPage extends State<SearchListList> {
  final searchController = TextEditingController();
  bool _isInAsyncCall = false;
  List<Drills> drillList = [];

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    searchController.text = widget.searchText;
    fetchAlbum(widget.searchText);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildPageView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back,
                                    size: 28, color: Colors.white),
                                onPressed: () {
                                  //widget.onBackCallback();
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                "back",
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
                      ),
                      Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                            child: _GooglePlayAppBar(),
                          )),
                      Expanded(
                          flex: 1,
                          child: ListView.builder(
                            // Widget which creates [ItemWidget] in scrollable list.
                            itemCount: drillList.length,
                            // Number of widget to be created.
                            itemBuilder: (context, itemIndex) =>
                                ItemWidget(drillList[itemIndex], () {
                              _onItemTap(
                                  context, drillList[itemIndex], drillList);
                            }, () {
                              _closeItem(context, drillList[itemIndex]);
                            }, () {
                              _analysis(context, drillList[itemIndex]);
                            }),
                          )),
                    ],
                  )))
        ],
      ),
    );
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

  fetchAlbum(String searchvalue) async {
    setState(() {
      _isInAsyncCall = true;
    });

    SearchDrillsResponse getDrills = await searchDrill(searchvalue);

    if (getDrills.status == "true") {
      _isInAsyncCall = false;
      Toast.show("${getDrills.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        drillList = getDrills.data.drills;
      });
    } else {
      _isInAsyncCall = false;
      Toast.show("${getDrills.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Widget _GooglePlayAppBar() {
    return Container(
        height: 40.0,
        child: TextField(
          controller: searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15.0),
            border: OutlineInputBorder(),
            hintText: 'Search Drills or Colleges',
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.white, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        fetchAlbum(searchController.text);

                        /* search= searchController.text;*/
                        /* Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SearchListList(searchText:'$search')));*/
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.cancel_rounded, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        searchController.text = "";
                        widget.searchText = "";
                        Navigator.pop(context);
                      });
                    })
              ],
            ),
          ),
        ));
  }
}

_onItemTap(BuildContext context, Drills item, List<Drills> drillList) {
  print("this is on tap item and index is::::::::::::: " + item.title);

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              TrainingOnGoing(drillItem: item, drillList: drillList)
          // builder: (context) => TrainingOnGoing()
          ));
}

_closeItem(BuildContext context, Drills item) {
  print("this is on tap _closeItem and index is " + item.title);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

_analysis(BuildContext context, Drills item) {
  print("this is on tap _analysis and index is " + item.title);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this.closeItem, this.analysis,
      {Key key})
      : super(key: key);

  final Drills model;
  final Function onItemTap;
  final Function closeItem;
  final Function analysis;

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
                              child:
                                  /*ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    child: Image.asset("assets/listimage.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),*/

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
                        child: GestureDetector(
                          onTap: closeItem,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.topRight,
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
