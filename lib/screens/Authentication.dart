import 'package:flutter/material.dart';
import 'package:trainsolo/screens/login_view.dart';
import 'signup.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: ExactAssetImage('assets/splash.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('assets/logowhite.png'),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonTheme(
                            minWidth: 120.0,
                            height: 50.0,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Color.fromARGB(255, 237, 28, 36),
                              child: Text("Sign Up"),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()));
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      color: Color.fromARGB(255, 237, 28, 36))),
                            ),
                          ),
                          SizedBox(width: 20),
                          ButtonTheme(
                            minWidth: 120.0,
                            height: 50.0,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.transparent,
                              child: Text("Login"),
                              onPressed: () {
                                Amplitude.getInstance(
                                        instanceName:
                                            Constants.AMPLITUDE_INSTANCE_NAME)
                                    .logEvent('Login Flow Initiated');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  side: BorderSide(color: Colors.white)),
                            ),
                          ),
                        ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
