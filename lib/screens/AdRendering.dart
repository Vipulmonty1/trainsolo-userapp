import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:trainsolo/ad_videoplayer/vimeoplayer.dart';
// import 'package:trainsolo/videoplayer/vimeoplayer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:trainsolo/utils/Constants.dart';

class AdRendering extends StatefulWidget {
  final String adVimeoId;
  final String adHyperlink;
  final String adButtonText;
  final String adDuration;

  const AdRendering(
      {Key key,
      @required this.adVimeoId,
      @required this.adHyperlink,
      @required this.adButtonText,
      @required this.adDuration})
      : super(key: key);

  @override
  _AdRenderingState createState() => _AdRenderingState();
}

class _AdRenderingState extends State<AdRendering> {
  CountDownController _controller = CountDownController();

  void initState() {
    super.initState();
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Ad Rendered to User", eventProperties: {
      "vimeoID": widget.adVimeoId,
      "hyperlink": widget.adHyperlink,
      "buttonText": widget.adButtonText,
      "duration": widget.adDuration
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      content: Builder(builder: (context) {
        // Get available height and width of the build area of this widget. Make a choice depending on the size.
        return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircularCountDownTimer(
                  duration: int.parse(widget.adDuration),
                  initialDuration: 0,
                  controller: _controller,
                  width: 75,
                  height: 75,
                  ringColor: Colors.white,
                  fillColor: Colors.red,
                  textStyle: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textFormat: CountdownTextFormat.S,
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: true,
                ),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height - 270,
                  child: VimeoPlayer(
                      id: widget.adVimeoId,
                      autoPlay: true,
                      key: Key(widget.adVimeoId)),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        // Respond to button press
                        Amplitude.getInstance(
                                instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                            .logEvent("Ad Link Clicked By User",
                                eventProperties: {
                              "vimeoID": widget.adVimeoId,
                              "hyperlink": widget.adHyperlink,
                              "buttonText": widget.adButtonText,
                              "duration": widget.adDuration
                            });
                        launch(widget.adHyperlink);
                      },
                      child: Text(
                        widget.adButtonText,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black))),
                )
              ],
            ));
      }),
    );
  }
}
