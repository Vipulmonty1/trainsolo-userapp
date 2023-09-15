import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trainsolo/controllers/vimeo_player_controller.dart';
import 'package:trainsolo/model/get_videos_by_category_response.dart';
import 'package:trainsolo/model/vimeo_player_flags.dart';

import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/videoplayer/vimeoplayer.dart';

class TestPayList extends StatefulWidget {
  final List<VideoData> drillList;
  TestPayList({Key key, @required this.drillList}) : super(key: key);

  @override
  TestPayListState createState() => TestPayListState();
}

class TestPayListState extends State<TestPayList> {
  VimeoPlayerController controller;
  bool _playerReady = false;
  // ignore: unused_field
  String _videoTitle;
  // ignore: unused_field
  String _videoId = "567780291";
  // ignore: unused_field
  var _playingIndex = -1;
  // ignore: unused_field
  var _disposed = false;
  bool _isInAsyncCall = false;
  List<VideoData> videoDataListList = [];
  int videoindex = 0;
  // ignore: unused_field
  int _textvalueduration;
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    print("updateValue of vimeo id:::::::::::::inside initial:::::::::::::::" +
        videoindex.toString());
    _initializeAndPlay(videoindex);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    this.controller.removeListener(listener);
    this.controller.dispose();
    super.dispose();
  }

  void _initializeAndPlay(int index) async {
    print("updateValue of vimeo id::::::::::::::::::::::::::::" +
        index.toString());
    this._videoTitle = 'Loading...';
    this._textvalueduration = 00;
    this.controller = VimeoPlayerController(
        initialVideoId: '${widget.drillList[index].vimeourl}',
        flags: VimeoPlayerFlags())
      ..addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        child: getBody(),
        inAsyncCall: _isInAsyncCall,
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromARGB(255, 237, 28, 36),
        ),
      ),
    );
  }

  void listener() async {
    if (_playerReady) {
      setState(() {
        this._videoTitle = controller.value.videoTitle;
        this._textvalueduration = controller.value.videoPosition.round();
      });
    }
  }

  _onItemTap(BuildContext context, int index) {
    print("this is on tap item and index is " + index.toString());
    setState(() {
      videoindex = index;
      refresh();
    });
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: size.height - 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 8, top: 10.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Training video',
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontSize: 20,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: VimeoPlayer(
                    id: _videoId,
                    autoPlay: false,
                    looping: true,
                    key: Key(_videoId),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 8, top: 10.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Drag to reorder drills",
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontSize: 20,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // Widget which creates [ItemWidget] in scrollable list.
                      itemCount: widget
                          .drillList.length, // Number of widget to be created.
                      itemBuilder: (context, itemIndex) =>
                          ItemWidget(widget.drillList[itemIndex], () {
                        _onItemTap(context, itemIndex);
                      }, () {
                        _closeItem(context, widget.drillList[itemIndex]);
                      }, () {
                        _analysis(context, widget.drillList[itemIndex]);
                      }, itemIndex),
                    ))
              ],
            ),
          ),
          Container(
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back,
                                  size: 28, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            /*IconButton(
                              icon: Container(
                                margin: EdgeInsets.only(right: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                    image: AssetImage("assets/playerpic.jpg"),
                                    fit: BoxFit.cover
                                  )
                                ),
                              ),
                              onPressed: () {},
                            ), */
                            // profile image on top if we want to show on top profile image
                          ],
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/logo.ico",
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),*/
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Séries",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Filmes",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Minha lista",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_closeItem(BuildContext context, VideoData item) {
  print("this is on tap _closeItem and index is " + item.videotitle);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

_analysis(BuildContext context, VideoData item) {
  print("this is on tap _analysis and index is " + item.videotitle);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      this.model, this.onItemTap, this.closeItem, this.analysis, this.itemIndex,
      {Key key})
      : super(key: key);

  final VideoData model;
  final Function onItemTap;
  final Function closeItem;
  final Function analysis;
  final int itemIndex;

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
                flex: 0,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Column(
                        children: [
                          Text("Drill",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              )),
                          Text(
                              '${model.libid != null ? (itemIndex + 1).toString() : '-'}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      )),
                    ),
                    Dash(
                        direction: Axis.vertical,
                        length: 83,
                        dashLength: 3,
                        dashColor: Colors.white),
                  ],
                ),
              ),
/* Material( // pause button (round)
                                borderRadius: BorderRadius.circular(50), // change radius size
                                color: Colors.blue, //button colour
                                child: InkWell(
                                  splashColor: Colors.blue[900], // inkwell onPress colour
                                  child: SizedBox(
                                    width: 35,height: 35, //customisable size of 'button'
                                    child: Icon(Icons.pause,color: Colors.white,size: 16,),
                                  ),
                                  onTap: () {}, // or use onPressed: () {}
                                ),
                              ),*/
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
                                              model.videotitle != null
                                                  ? model.videotitle
                                                  : 'No title',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                          Text(
                                              model.explanation != null
                                                  ? model.explanation
                                                  : 'No Explanation',
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
                                          : Constants.DEFULT_IMAGE_URL,
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
