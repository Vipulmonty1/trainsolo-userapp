import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/get_videos_by_category_response.dart';
import 'package:trainsolo/model/library_response.dart';
import 'package:trainsolo/screens/PlayersDetails.dart';
import 'package:trainsolo/utils/RevenueCatUtilities.dart';
import 'package:toast/toast.dart';

import 'library/libraryTrainingOnGoing.dart';
import 'SubscriptionBlocker.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

class Library extends StatefulWidget {
  LibraryPage createState() => LibraryPage();
}

class LibraryPage extends State<Library> {
  bool _isInAsyncCall = false;
  List<MainLibrary> LibraryPositionList = [];
  List<VideoData> folloWmodel;
  List<VideoData> Interviewmodel;
  // ignore: non_constant_identifier_names
  List<VideoData> MatchAnalysismodel;

  @override
  void initState() {
    super.initState();
    getLibrary();
    getfolloWmodel();
    getInterviewmodel();
    getMatchAnalysismodel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ModalProgressHUD(
        child: ListView.builder(
          itemCount: LibraryPositionList != null
              ? LibraryPositionList.length
              : {
                  setState(() {
                    _isInAsyncCall = true;
                  })
                }, // Number of widget to be created.
          itemBuilder: (context, itemIndex) => ItemWidget(
              LibraryPositionList[itemIndex],
              folloWmodel,
              Interviewmodel,
              MatchAnalysismodel),
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

  void pageChanged(int index) {
    setState(() {});
  }

  Future<void> getLibrary() async {
    setState(() {
      _isInAsyncCall = true;
    });

    LibraryResponse libraryListData = await getlibrary();

    if (libraryListData.status == "true") {
      _isInAsyncCall = false;
      Toast.show("${libraryListData.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        LibraryPositionList = libraryListData.data;
      });
    } else {
      _isInAsyncCall = false;

      Toast.show("${libraryListData.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future<void> getMatchAnalysismodel() async {
    await Future<String>.delayed(const Duration(seconds: 1));

    GetVideosByCategoryResponse videoDataresponse =
        await getVideoByCategory("Match Analysis");
    if (videoDataresponse.status == "true") {
      setState(() {
        this._isInAsyncCall = false;
      });
      setState(() {
        if (videoDataresponse.data.toString() == "[]") {
        } else {
          MatchAnalysismodel = videoDataresponse.data;
        }
      });
    } else {
      setState(() {
        this._isInAsyncCall = false;
      });
    }
    return null;
  }

  Future<void> getInterviewmodel() async {
    await Future<String>.delayed(const Duration(seconds: 1));

    GetVideosByCategoryResponse videoDataresponse =
        await getVideoByCategory("Interview");
    if (videoDataresponse.status == "true") {
      setState(() {
        this._isInAsyncCall = false;
      });
      setState(() {
        if (videoDataresponse.data.toString() == "[]") {
        } else {
          Interviewmodel = videoDataresponse.data;
        }
      });
    } else {
      setState(() {
        this._isInAsyncCall = false;
      });
    }
    return null;
  }

  Future<void> getfolloWmodel() async {
    await Future<String>.delayed(const Duration(seconds: 1));

    GetVideosByCategoryResponse videoDataresponse =
        await getVideoByCategory("5 Minutes");
    if (videoDataresponse.status == "true") {
      setState(() {
        this._isInAsyncCall = false;
      });
      setState(() {
        if (videoDataresponse.data.toString() == "[]") {
        } else {
          folloWmodel = videoDataresponse.data;
        }
      });
    } else {
      setState(() {
        this._isInAsyncCall = false;
      });
    }
    return null;
  }
}

_onItemTap(
    BuildContext context, SubLibrary libraryItem, List<SubLibrary> model) {
  WidgetsBinding.instance.addPostFrameCallback(
      (_) => _blockWithSubscriptionPlayerDetails(context, libraryItem));
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.folloWmodel, this.interviewmodel,
      this.MatchAnalysismodel,
      {Key key})
      : super(key: key);
  final MainLibrary model;
  final List<VideoData> folloWmodel;
  final List<VideoData> interviewmodel;
  // ignore: non_constant_identifier_names
  final List<VideoData> MatchAnalysismodel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: () {},

      child:
          followAlong(model, folloWmodel, interviewmodel, MatchAnalysismodel),
    );
  }
}

Widget followAlong(MainLibrary model, List<VideoData> folloWmodel,
    List<VideoData> interviewmodel, List<VideoData> matchAnalysismodel) {
  return Material(
    color: Colors.black,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 0.0),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              model.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontFamily: 'BebasNeue',
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              model.tagline ?? "",
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'BebasNeue',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: followAlongList(
              model.data, folloWmodel, interviewmodel, matchAnalysismodel),
        ),
      ],
    ),
  );
}

Widget followAlongList(List<SubLibrary> model, List<VideoData> folloWmodel,
    List<VideoData> interviewmodel, List<VideoData> matchAnalysismodel) {
  return Container(
    height: 175,
    constraints: BoxConstraints(maxHeight: double.infinity),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      //physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: model != null ? model.length : 0,
      itemBuilder: (context, itemIndex) => model[itemIndex].category == "1"
          ? followAlongItemWidget(
              model[itemIndex],
              () {
                _onItemTap(context, model[itemIndex], model);
              },
            )
          : videoItemWidget(model[itemIndex].grpby, folloWmodel, interviewmodel,
              matchAnalysismodel),
    ),
  );
}

class followAlongItemWidget extends StatelessWidget {
  const followAlongItemWidget(this.model, this.onItemTap, {Key key})
      : super(key: key);

  final SubLibrary model;
  final Function onItemTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        // Enables taps for child and add ripple effect when child widget is long pressed.
        onTap: onItemTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 125.0,
              width: 125.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox.expand(
                  child: FittedBox(
                    child: CachedNetworkImage(
                      filterQuality: FilterQuality.none,
                      colorBlendMode: BlendMode.clear,
                      imageUrl: model.thumbnail != null
                          ? model.thumbnail
                          : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                    ),
                    //fit: BoxFit.fill,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              //padding: const EdgeInsets.only(left: 5.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 120),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  model.grpby != null ? model.grpby : "Train Solo",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  //maxLines: 4,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget videoItemWidget(String grybyCate, List<VideoData> folloWmodel,
    List<VideoData> interviewmodel, List<VideoData> matchAnalysismodel) {
  List<VideoData> model;

  if (grybyCate == "Interview") model = interviewmodel;
  if (grybyCate == "Match Analysis") model = matchAnalysismodel;
  if (grybyCate == "5 Minutes") model = folloWmodel;
  if (grybyCate == "10 Minutes") model = folloWmodel;
  // // model = model1;
  // fetchAlbum(grybyCate).then((value) {

  return Container(
      height: 175.0,
      margin: const EdgeInsets.all(8),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model != null ? model.length : 0,
          itemBuilder: (context, itemIndex) =>
              VideoSingleItemWidget(model[itemIndex], () {
                _onItemTapVideo(context, model[itemIndex], model);
              }, () {
                _closeItemVideo(context, model[itemIndex]);
              }, () {
                _analysisVideo(context, model[itemIndex]);
              }, itemIndex)));

  //});
/*
  if (grybyCate == "Interview") model = LibraryPage().Interviewmodel;
  if (grybyCate == "Match Analysis") model = LibraryPage().MatchAnalysismodel;
  if (grybyCate == "5 Minutes") model = LibraryPage().folloWmodel;
*/
}

Future<void> _blockWithSubscriptionPlayerDetails(
    BuildContext context, SubLibrary libraryItem) async {
  bool shouldRenderSubscription = await checkAPIBlocker();
  bool userEntitled = await checkNonFitnessAccess();
  if (userEntitled || !shouldRenderSubscription) {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Library Multiple Video Sesssion Clicked", eventProperties: {
      "library_category": libraryItem.groupcategory,
      "library_title": libraryItem.grpby,
      "library_id": libraryItem.libcatid
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            //builder: (context) => TrainingOnGoing(itemname: item.title)
            builder: (context) => PlayersDetails(libraryItem: libraryItem)));
  } else {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Subscription Blocker Rendered",
            eventProperties: {"source": "library_multi_video_session"});
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return SubscriptionBlocker(() => Navigator.push(
              context,
              MaterialPageRoute(
                  //builder: (context) => TrainingOnGoing(itemname: item.title)
                  builder: (context) =>
                      PlayersDetails(libraryItem: libraryItem))));
        });
  }
}

Future<void> _blockWithSubscriptionTrainingOngoing(
    BuildContext context, VideoData item, List<VideoData> drillList) async {
  bool shouldRenderSubscription = await checkAPIBlocker();
  bool userEntitled = await checkNonFitnessAccess();
  if (userEntitled || !shouldRenderSubscription) {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Library Single Video Session Clicked", eventProperties: {
      "library_id": item.libid,
      "video_title": item.videotitle
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LibraryTrainingOnGoing(
                videoData: item, videoDataList: drillList)));
  } else {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Subscription Blocker Rendered",
            eventProperties: {"source": "library_single_video_session"});
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return SubscriptionBlocker(() => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LibraryTrainingOnGoing(
                      videoData: item, videoDataList: drillList))));
        });
  }
}

_onItemTapVideo(
    BuildContext context, VideoData item, List<VideoData> drillList) {
  WidgetsBinding.instance.addPostFrameCallback(
      (_) => _blockWithSubscriptionTrainingOngoing(context, item, drillList));
}

_closeItemVideo(BuildContext context, VideoData item) {
  print("this is on tap _closeItem and index is " + item.videotitle);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

_analysisVideo(BuildContext context, VideoData item) {
  print("this is on tap _analysis and index is " + item.videotitle);
  /*Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ItemDetailsPage(_items[itemIndex])));*/
}

class VideoSingleItemWidget extends StatelessWidget {
  const VideoSingleItemWidget(
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
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          // Enables taps for child and add ripple effect when child widget is long pressed.
          onTap: onItemTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100.0,
                width: 125.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox.expand(
                    child: FittedBox(
                      child: CachedNetworkImage(
                        filterQuality: FilterQuality.none,
                        colorBlendMode: BlendMode.clear,
                        imageUrl: model.thumbnail != null
                            ? model.thumbnail
                            : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                      ),
                      //fit: BoxFit.fill,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 1,
                //padding: const EdgeInsets.only(left: 5.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 120),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    model.videotitle != null ? model.videotitle : "Train Solo",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    //maxLines: 4,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
