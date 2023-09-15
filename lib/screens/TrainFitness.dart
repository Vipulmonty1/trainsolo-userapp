import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:scroll_indicator/scroll_indicator.dart';
import 'package:trainsolo/model/college_list.dart';

import 'package:trainsolo/model/fitness_response.dart';
import 'package:trainsolo/model/search_college_response.dart';
import 'package:trainsolo/screens/FitnessTestRecordProgrss.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/utils/RevenueCatUtilities.dart';
import '../api/api_service.dart';
import 'college_fitness_info.dart';
import 'package:toast/toast.dart';

import 'SubscriptionBlocker.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class TrainFitness extends StatefulWidget {
  TrainFitnessPage createState() => TrainFitnessPage();
}

class TrainFitnessPage extends State<TrainFitness> {
  ScrollController scrollController2 = ScrollController();
  final searchController = TextEditingController();
  final TextEditingController _textController = new TextEditingController();
  bool _isInAsyncCall = false;
  GlobalKey<PageContainerState> key = GlobalKey();
  String userPosition = "";
  int id = 0;
  bool navigateToPage = false;
  String level;
  String role;
  String gender;
  String resonforjoin;
  List<FitnessData> fitnessList = [];
  String searchText = "";
  static List<College> mainDataList = [];

/*  static List<String> mainDataList = [
    "Alabama State University (Women)",
    "American University (Women)",
    "Austin Peavy University (Women)",
    "Boston College (Women)",
    "Boston University (Women)",
  ];*/

  // Copy Main List into New List.
  List<College> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
    setState(() {
      newDataList = mainDataList
          .where((string) =>
              string.name.toLowerCase().contains(value.toLowerCase()))
          .toList();

      /*mainDataList.forEach((element) {
        if(element.name.toLowerCase().contains(value.toLowerCase())){
          newDataList.add(element);
        }

      });*/
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Train Page Fitness Tab Loaded");
    scrollController2 = ScrollController();
    fetchAlbum();
    Collegelist();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController2.dispose();
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      height: 290,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: scrollController2,
                        itemCount: fitnessList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            childAspectRatio: 3 / 9,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10),
                        itemBuilder: (context, index) =>
                            ItemWidget(fitnessList[index], () {
                          _onItemTap(context, fitnessList[index], fitnessList);
                        }, () {
                          _closeItem(
                              context, fitnessList[index], _isInAsyncCall);
                        }, () {
                          _analysis(context, fitnessList[index]);
                        }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ScrollIndicator(
                    scrollController: scrollController2,
                    width: 50,
                    height: 5,
                    indicatorWidth: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300]),
                    indicatorDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 237, 28, 36),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: Container(
                      height: 300,
                      child: Stack(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: SizedBox.expand(
                                child: FittedBox(
                                  // child: CachedNetworkImage(
                                  //   imageUrl:
                                  //       "https://peru21.pe/resizer/hPGkIG3OclZomu1TjpXMO4wMqSo=/980x0/smart/filters:format(jpeg):quality(75)/arc-anglerfish-arc2-prod-elcomercio.s3.amazonaws.com/public/BI54IUTBQ5BWPBHXXMFCRQXRVU.jpg",
                                  //   placeholder: (context, url) =>
                                  //       Transform.scale(
                                  //     scale: 0.2,
                                  //     child: CircularProgressIndicator(
                                  //         color:
                                  //             Color.fromARGB(255, 237, 28, 36)),
                                  //   ),
                                  //   errorWidget: (context, url, error) =>
                                  //       Transform.scale(
                                  //     scale: 0.7,
                                  //     child:
                                  //         Icon(Icons.image, color: Colors.grey),
                                  //   ),
                                  // ),
                                  child:
                                      Image.asset('assets/college_campus.jpeg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            /*decoration: BoxDecoration(
                        image: DecorationImage(
                          image:  ExactAssetImage('assets/playerpic.jpg'),
                          fit: BoxFit.cover
                        )
                      ),*/
                          ),
                          Container(
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
                            //width: size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                                "College Standards",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                  fontFamily: 'BebasNeue',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, right: 8),
                                                  child: Container(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        "SELECT COLLEGE",
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 255, 0, 0),
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'BebasNeue',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                      child: Container(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                      child: _GooglePlayAppBar(),
                    ),
                  )),
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
        ),
      ),
    );
  }

  Widget _GooglePlayAppBar() {
    return Container(
      height: 40.0,
      child: Column(children: <Widget>[
        TextField(
          controller: _textController,
          style: TextStyle(color: Colors.white),
          onChanged: onItemChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15.0),
            border: OutlineInputBorder(),
            hintText: 'Search Colleges',
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
                      Amplitude.getInstance(
                              instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                          .logEvent("College Search Query", eventProperties: {
                        "search_query": _textController.text
                      });
                      setState(() {
                        fetchCollageList(_textController.text);
                      });
                    }),
                /* IconButton(
                    icon: Icon(Icons.cancel_rounded, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _textController.text = "";
                        onItemChanged("");
                      });
                    })*/
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.all(12.0),
            children: newDataList.map((data) {
              return ListTile(
                leading: Image.network(
                  data.logoname,
                  height: 40,
                  width: 40,
                ),
                title: Text(
                  data.name,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _blockWithSubscriptionCollege(context, data));
                },
              );
            }).toList(),
          ),
        )
      ]),
    );
  }

  fetchAlbum() async {
    setState(() {
      _isInAsyncCall = true;
    });

    FitnessResponse fitnessData = await getFitnessList();

    if (fitnessData.status == "true") {
      _isInAsyncCall = false;
      Toast.show("${fitnessData.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        fitnessList = fitnessData.data;
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          fitnessData.message);
      Toast.show("${fitnessData.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  fetchCollageList(String searchvalue) async {
    setState(() {
      _isInAsyncCall = true;
    });

    SearchCollegeResponse getCollege = await searchCollage(searchvalue);

    if (getCollege.status == "true") {
      print('>>>>>>>>>>>>>>>>INSIDE COLLAGE API>>>>>>>>>TRUE>>>>>>>>>>>');
      _isInAsyncCall = false;
      Toast.show("${getCollege.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        mainDataList = List.from(getCollege.data.college);
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>INSIDE COLLAGE API>>>>>>>>>FALSE>>>>>>>>>>>');
      Toast.show("${getCollege.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Collegelist() async {
    print('>>>>>>>>>>>>>>>>INSIDE COLLAGE API>>>>>>>>>>>>>>>>>>>>');
    CollegeList getCollege = await collegeList();
    if (getCollege.status == "true") {
      print('>>>>>>>>>>>>>>>>INSIDE COLLAGE API>>>>>>>>>TRUE>>>>>>>>>>>');
      _isInAsyncCall = false;
      Toast.show("${getCollege.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      mainDataList = getCollege.data;
      setState(() {
        newDataList = mainDataList;
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>INSIDE COLLAGE API>>>>>>>>>FALSE>>>>>>>>>>>');
      Toast.show("${getCollege.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}

Future<void> _blockWithSubscriptionCollege(
    BuildContext context, College data) async {
  bool shouldRenderSubscription = await checkAPIBlocker();
  bool userEntitled = await checkFitnessAccess();
  if (userEntitled || !shouldRenderSubscription) {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("College Clicked", eventProperties: {
      "college_name": data.name,
      "college_id": data.id
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CollegeFitnessInfo(college: data)));
  } else {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Subscription Blocker Rendered",
            eventProperties: {"source": "fitness_college"});
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return SubscriptionBlocker(
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CollegeFitnessInfo(college: data))),
              true);
        });
  }
}

Future<void> _blockWithSubscriptionFitnessTest(
    BuildContext context, FitnessData item) async {
  bool shouldRenderSubscription = await checkAPIBlocker();
  bool userEntitled = await checkFitnessAccess();
  if (userEntitled || !shouldRenderSubscription) {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Fitness Test Clicked",
            eventProperties: {"test_name": item.name, "test_id": item.id});
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FitnessTestRecordProgrss(fitnessItems: item)));
  } else {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Subscription Blocker Rendered",
            eventProperties: {"source": "fitness_test"});
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return SubscriptionBlocker(
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FitnessTestRecordProgrss(fitnessItems: item))),
              true);
        });
  }
}

_onItemTap(
    BuildContext context, FitnessData item, List<FitnessData> fitnesslist) {
  WidgetsBinding.instance.addPostFrameCallback(
      (_) => _blockWithSubscriptionFitnessTest(context, item));
}

_closeItem(BuildContext context, FitnessData item, bool isInAsyncCall) {
  print("this is on tap _closeItem and index is " + item.name);
  //deleteDrill(item,context,isInAsyncCall);
}

_analysis(BuildContext context, FitnessData item) {
  print("this is on tap _analysis and index is " + item.name);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FitnessTestRecordProgrss(fitnessItems: item)));
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this.closeItem, this.analysis,
      {Key key})
      : super(key: key);

  final FitnessData model;
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
                                  top: 5.0, bottom: 5.0, right: 0.0, left: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox.expand(
                                  child: FittedBox(
                                    child: CachedNetworkImage(
                                      imageUrl: model.setupimagename != null
                                          ? Constants.IMAGE_BASE_URL +
                                              "/images/" +
                                              model.setupimagename
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
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 8.0, bottom: 8.0, right: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                                model.name != null
                                                    ? model.name
                                                    : 'No title',
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
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
