import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/library_response.dart';
import 'package:trainsolo/screens/PlayersDetails.dart';

import 'package:toast/toast.dart';

class LibraryTemp extends StatefulWidget {
  LibraryTempPage createState() => LibraryTempPage();
}

class LibraryTempPage extends State<LibraryTemp> {
  bool _isInAsyncCall = false;
  List<MainLibrary> LibraryPositionList = [];
  @override
  void initState() {
    super.initState();
    getLibrary();
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
          itemBuilder: (context, itemIndex) =>
              ItemWidget(LibraryPositionList[itemIndex]),
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
        LibraryPositionList.forEach((element) {
          print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>TITLE>>>>>>>>>>>>>>>>>>>>' +
              element.title);
        });
      });
    } else {
      _isInAsyncCall = false;
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>STATUS FALSE>>>>>>>>>>>>>>>>>>>>' +
          libraryListData.message);
      Toast.show("${libraryListData.message}", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}

_onItemTap(BuildContext context, SubLibrary item, List<SubLibrary> model) {
  print("this is on tap item and index is " + item.grpby);
  Navigator.push(
      context,
      MaterialPageRoute(
          //builder: (context) => TrainingOnGoing(itemname: item.title)
          builder: (context) => PlayersDetails(
                libraryItem: null,
              )));
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, {Key key}) : super(key: key);
  final MainLibrary model;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: () {
        print("this is on tap");
      },
      child: followAlong(model),
    );
  }
}

Widget followAlong(MainLibrary model) {
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
                fontSize: 32,
                fontFamily: 'BebasNeue',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              model.tagline,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'BebasNeue',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: followAlongList(model.data),
        ),
      ],
    ),
  );
}

Widget followAlongList(List<SubLibrary> model) {
  return Container(
    height: 155.0,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: model.length,
        itemBuilder: (context, itemIndex) => followAlongItemWidget(
              model[itemIndex],
              () {
                _onItemTap(context, model[itemIndex], model);
              },
            )),
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
              height: 112.0,
              width: 145.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox.expand(
                  child: FittedBox(
                    child: CachedNetworkImage(
                      imageUrl: model.thumbnail != null
                          ? model.thumbnail
                          : "https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",
                      placeholder: (context, url) => Transform.scale(
                        scale: 0.2,
                        child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 237, 28, 36)),
                      ),
                      errorWidget: (context, url, error) => Transform.scale(
                        scale: 0.7,
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              /* new BoxDecoration(
                image: DecorationImage(
                  image: new NetworkImage(model.thumbnail!= null? model.thumbnail:"https://static.wixstatic.com/media/30d704_86712894e6964d56a397977a37080252~mv2.jpg/v1/fill/w_640,h_430,al_c,q_80,usm_0.66_1.00_0.01/30d704_86712894e6964d56a397977a37080252~mv2.webp",),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),*/
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                model.grpby != null ? model.grpby : "Train Solo",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
