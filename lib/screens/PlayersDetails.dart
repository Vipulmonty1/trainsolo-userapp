import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/ItemModel.dart';
import 'package:trainsolo/model/get_videos_by_category_response.dart';
import 'package:trainsolo/model/library_response.dart';

import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/videoplayer/vimeoplayer.dart';
import 'library/libraryTrainingOnGoing.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class PlayersDetails extends StatefulWidget {
  final SubLibrary libraryItem;

  PlayersDetails({@required this.libraryItem});

  @override
  PlayersDetailsState createState() => PlayersDetailsState();
}

class PlayersDetailsState extends State<PlayersDetails> {
  bool _isInAsyncCall = false;
  bool _playerReady = false;
  // ignore: unused_field
  String _videoTitle;
  String _videoId = "";
  // ignore: unused_field
  int _itemCount = 10;
  // ignore: unused_field
  int _textvalueduration;

  // ignore: unused_field
  final List<ItemModel> _items = [];

  List<VideoData> videoDataListList = [];

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    setdata();
  }

  void listener() async {
    if (_playerReady) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                Stack(
                  children: [
                    Container(
                      height: 380,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: SizedBox.expand(
                          child: FittedBox(
                            child: CachedNetworkImage(
                              imageUrl: widget.libraryItem.thumbnail ??
                                  "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
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
                    Container(
                      height: 380,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.85),
                              Colors.black.withOpacity(0.0)
                            ],
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter),
                      ),
                    ),
                    Container(
                      height: 380,
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /* Image.asset("assets/images/titulo_1.webp", width: 300,),*/ // this is for any text or image show on profile pic for that use
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 10, // 60%
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.libraryItem.grpby ??
                                              "default value",
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3, // 20%
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 75.0,
                                            height: 72.0,
                                            child: FloatingActionButton(
                                              onPressed: () {
                                                Amplitude.getInstance(
                                                        instanceName: Constants
                                                            .AMPLITUDE_INSTANCE_NAME)
                                                    .logEvent(
                                                        "Library Start Training Clicked",
                                                        eventProperties: {
                                                      "library_session_name":
                                                          widget
                                                              .libraryItem.grpby
                                                    });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LibraryTrainingOnGoing(
                                                                videoData:
                                                                    videoDataListList[
                                                                        0],
                                                                videoDataList:
                                                                    videoDataListList)));
                                              },
                                              child: Icon(
                                                /* controller.value.isPlaying ? Icons.pause : Icons.play_arrow,*/
                                                Icons.play_arrow,
                                                color: Color.fromARGB(
                                                    255, 255, 0, 0),
                                                size: 50,
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                              'Start Training',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10, right: 8),
                              child: Container(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    widget.libraryItem.exaplanation ?? "",
                                    textAlign: TextAlign.left,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Divider(
                          height: 10,
                          thickness: 0.2,
                          indent: 20,
                          endIndent: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                _videoId != null
                    ? Padding(
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
                        ))
                    : SizedBox(height: 1),
                Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        _videoId != null
                            ? VimeoPlayer(
                                id: _videoId,
                                autoPlay: false,
                                looping: true,
                                key: Key(_videoId),
                              )
                            : SizedBox(height: 1)
                      ],
                    )),
                // Padding(
                //     padding: EdgeInsets.only(left: 20, right: 8, top: 10.0),
                //     child: Container(
                //       child: Align(
                //         alignment: Alignment.topLeft,
                //         child: Text(
                //           "Drag to reorder drills",
                //           textAlign: TextAlign.left,
                //           maxLines: 3,
                //           style: TextStyle(
                //             color: Color.fromARGB(255, 237, 28, 36),
                //             fontSize: 20,
                //             fontFamily: 'BebasNeue',
                //             fontWeight: FontWeight.w400,
                //           ),
                //         ),
                //       ),
                //     )),
                Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // Widget which creates [ItemWidget] in scrollable list.
                      itemCount: videoDataListList
                          .length, // Number of widget to be created.
                      itemBuilder: (context, itemIndex) =>
                          ItemWidget(videoDataListList[itemIndex], () {
                        _onItemTap(context, videoDataListList[itemIndex],
                            videoDataListList);
                      }, () {
                        _closeItem(context, videoDataListList[itemIndex]);
                      }, () {
                        _analysis(context, videoDataListList[itemIndex]);
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> fetchAlbum(String grpById) async {
    await Future<String>.delayed(const Duration(seconds: 1));
    print(widget.libraryItem.grpby);
    GetVideosByCategoryResponse videoDataresponse =
        await getVideoByCategory(widget.libraryItem.grpby);
    if (videoDataresponse.status == "true") {
      if (mounted) {
        setState(() {
          this._isInAsyncCall = false;
        });
      }
      if (mounted) {
        setState(() {
          if (videoDataresponse.data.toString() == "[]") {
          } else {
            videoDataListList = videoDataresponse.data;
            _videoId = videoDataListList[0].vimeourl != null
                ? videoDataListList[0].vimeourl.toString()
                : " ";
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          this._isInAsyncCall = false;
        });
      }
    }
    return _videoId;
  }

  // ignore: missing_return
  Future<String> setdata() async {
    if (mounted) {
      setState(() {
        this._isInAsyncCall = true;
      });
      // ignore: unused_local_variable
      var id = await fetchAlbum(widget.libraryItem.grpby);
      setVideo(widget.libraryItem.matchanalysisid);
    }
  }

  _onItemTap(BuildContext context, VideoData item, List<VideoData> drillList) {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Library Drill Clicked", eventProperties: {
      "drill_title": item.videotitle,
      "library_drill_id": item.libid
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LibraryTrainingOnGoing(
                videoData: item, videoDataList: drillList)));
  }

  void setVideo(String id) {
    _videoTitle = 'Loading...';
    _videoId = id;
    _textvalueduration = 00;
    // controller =
    //     VimeoPlayerController(initialVideoId: id, flags: VimeoPlayerFlags())
    //       ..addListener(listener);
  }
}

_closeItem(BuildContext context, VideoData item) {}

_analysis(BuildContext context, VideoData item) {}

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
                                                  : '',
                                              maxLines: 4,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'HelveticaNeue',
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ],
                                      )),
                                  /*Expanded(
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
                                          */
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
