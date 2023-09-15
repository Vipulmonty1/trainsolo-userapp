import 'package:flutter/material.dart';
import 'package:trainsolo/model/get_videos_by_category_response.dart';
import 'package:trainsolo/screens/library/libraryTrainingVideo.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

// ignore: must_be_immutable
class LibraryTrainingOnGoing extends StatefulWidget {
  VideoData videoData;
  List<VideoData> videoDataList;
  LibraryTrainingOnGoing({@required this.videoData, this.videoDataList});
  LibraryTrainingOnGoingPage createState() => LibraryTrainingOnGoingPage();
}

class LibraryTrainingOnGoingPage extends State<LibraryTrainingOnGoing>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("IN THE TRAINING ON GOING PAGE>>>>>>>>>>>>>>" +
        '${widget.videoData.vimeourl}');
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new ListView(
        children: <Widget>[
          Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text("TRAINING ONGOING",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'BebasNeue',
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      InkWell(
                        child: Container(
                          width: 40,
                          padding: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Icon(Icons.close,
                                color: Colors.white, size: 30),
                          ),
                        ),
                        onTap: () {
                          Amplitude.getInstance(
                                  instanceName:
                                      Constants.AMPLITUDE_INSTANCE_NAME)
                              .logEvent("Library Training Ongoing Exited",
                                  eventProperties: {
                                "drill_name": widget.videoData.videotitle,
                                "drill_library_id": widget.videoData.libid,
                                "drill_rounds": widget.videoData.rounds,
                                "drill_reps": widget.videoData.reps
                              });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0, top: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                          "drill ${widget.videoDataList.indexOf(widget.videoData) + 1}/${widget.videoDataList.length}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontSize: 16,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          )),
                      SizedBox(height: 8),
                      Text(widget.videoData.videotitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.w400,
                          )),
                      Text(widget.videoData.explanation ?? "",
                          maxLines: 5000,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'HelveticaNeue',
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
            ],
          ),
          new Container(
            height: 500,
            child: LibraryTrainingVideo(
              videoData: widget.videoData ?? null,
              videoDataList: widget.videoDataList ?? null,
              videoID: widget.videoData.vimeourl ?? null,
              onPressed: (bool next) {
                onPressNextPrevious(next);
              },
            ),
          ),
        ],
      ),
    );
  }

  void onPressNextPrevious(bool next) {
    int i = widget.videoDataList.indexOf(widget.videoData);

    if (next && i <= widget.videoDataList.length) {
      i++;
    } else if (i >= 0) {
      i--;
    }

    setState(() {
      widget.videoData = widget.videoDataList[i];
    });
  }
}
