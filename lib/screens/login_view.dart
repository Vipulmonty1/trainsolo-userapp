import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:trainsolo/model/ItemModel.dart';
import 'package:trainsolo/model/common_success.dart';
import 'package:trainsolo/screens/Dashboard.dart';
import 'package:trainsolo/screens/forgot_password.dart';
import 'package:trainsolo/screens/signup.dart';
import 'package:trainsolo/utils/Constants.dart';
import '../api/api_service.dart';
import '../bloc/login_bloc.dart';
import 'package:toast/toast.dart';
import '../model/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class LoginScreen extends StatefulWidget {
  LoginScreenPage createState() => LoginScreenPage();
}

class LoginScreenPage extends State<LoginScreen> {
  bool _isInAsyncCall = false;
  final List<ItemModel> _items = [
    ItemModel(1, 'assets/listimage.png', "\$ 79.99/ Year",
        '\$ 6.65/month billed annually', true),
    ItemModel(
        2, 'assets/listimage.png', '\$ 9.99 / Month', 'Billed Monthly', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        child: Stack(
          children: [
            _createForm(context),
          ],
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

  Widget _createForm(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context, listen: false);

    return SingleChildScrollView(
      child: new Container(
        height: MediaQuery.of(context).size.height *
            1, // MediaQuery.of(context).devicePixelRatio,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: ExactAssetImage('assets/splash.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _pagetitleField(),
                _usernameField(bloc),
                _passwordField(bloc),
                const SizedBox(
                  height: 100.0,
                ),
              ],
            ),
            _bottomButtonField(bloc),
            _forgotPasswordField(bloc),
            _backToSignUpField(bloc),
            Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: RichText(
                text: new TextSpan(
                  text: 'trainsolosoccerhelp@gmail.com',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _pagetitleField() {
    return Padding(
      padding: const EdgeInsets.only(top: 90.0, bottom: 10.0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 0, 20),
        child: Text(
          'LOGIN TO YOUR ACCOUNT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontFamily: 'BebasNeue',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _usernameField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.usernameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: bloc.changeEmail,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                labelStyle:
                    TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
                border: new OutlineInputBorder(),
                hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontFamily: 'HelveticaNeue'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                labelText: 'E-mail or Username',
                hintText: 'Enter Your E-mail or Username',
                errorText: snapshot.error,
              ),
            ),
          );
        });
  }

  Widget _passwordField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              keyboardType: TextInputType.text,
              onChanged: bloc.changePassword,
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: new InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                labelStyle:
                    TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
                border: new OutlineInputBorder(),
                hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontFamily: 'HelveticaNeue'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                labelText: 'Password',
                hintText: 'Enter Your Password',
                errorText: snapshot.error,
              ),
            ),
          );
        });
  }

  Widget _bottomButtonField(LoginBloc bloc) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10, bottom: 10),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: StreamBuilder<bool>(
                stream: bloc.validarFormStream,
                builder: (context, snapshot) {
                  return MaterialButton(
                    onPressed:
                        snapshot.hasData ? () => _login(context, bloc) : null,
                    color: Color.fromARGB(255, 237, 28, 36),
                    textColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 237, 28, 36))),
                  );
                })),
      ],
    );
  }

  Widget _forgotPasswordField(LoginBloc bloc) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: new TextSpan(
                  text: 'FORGOT PASSWORD? ',
                  style: TextStyle(color: Colors.white),
                  children: [
                    new TextSpan(
                        text: 'CLICK HERE',
                        style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontWeight: FontWeight.bold),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            Amplitude.getInstance(
                                    instanceName:
                                        Constants.AMPLITUDE_INSTANCE_NAME)
                                .logEvent("Forgot Password Clicked");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()));
                          })
                  ]),
            ),
          );
        });
  }

  Widget _backToSignUpField(LoginBloc bloc) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: RichText(
              text: new TextSpan(
                  text: 'DONT HAVE AN ACCOUNT? ',
                  style: TextStyle(color: Colors.white),
                  children: [
                    new TextSpan(
                        text: 'CLICK HERE',
                        style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontWeight: FontWeight.bold),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            Amplitude.getInstance(
                                    instanceName:
                                        Constants.AMPLITUDE_INSTANCE_NAME)
                                .logEvent("Don't Have An Account Clicked");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          })
                  ]),
            ),
          );
        });
  }

  Future<void> updateSharingPlanApiCall(String planid, String players) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    print("Login response ...");
    print(loginResponse);
    if (loginResponse.data != null) {
      String userId = loginResponse.data.user.userId.toString();
      CommonSuccess response =
          await updateSharingPlan(players, "", planid, userId, "", "USER");
      if (response.status == "true") {}
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 0,
                    child: Positioned(
                        child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Center(
                              child: Icon(Icons.close,
                                  color: Colors.black, size: 10),
                            ),
                          )),
                    )),
                  ),
                ],
              ),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text(
                          "Unlock",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BebasNeue',
                            fontSize: 35,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "trainsolo Elite",
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'BebasNeue',
                            fontSize: 35,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                            "Keep working optimally towards fulfilling your potential and dreams!",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'HelveticaNeue',
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: SizedBox.expand(
                                        child: FittedBox(
                                          child:
                                              Image.asset('assets/subs1.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 150.0,
                                    width: 150.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: SizedBox.expand(
                                        child: FittedBox(
                                          child:
                                              Image.asset("assets/subs2.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "CHOOSE YOUR PLAN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'HelveticaNeue',
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 160,
                          child: ListView.builder(
                              // Widget which creates [ItemWidget] in scrollable list.
                              itemCount: _items
                                  .length, // Number of widget to be created.
                              itemBuilder: (context, itemIndex) => InkWell(
                                    // Enables taps for child and add ripple effect when child widget is long pressed.
                                    //onTap: () {},
                                    onTap:
                                        onItemTap(context, _items[itemIndex]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 70,
                                        child: Container(
                                          margin: const EdgeInsets.all(0.0),
                                          padding: const EdgeInsets.all(1.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius:
                                                new BorderRadius.circular(8.0),
                                          ),
                                          child: Container(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                flex: 0,
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.radio_button_off,
                                                      color: Colors.red),
                                                  tooltip:
                                                      'Increase volume by 10',
                                                  onPressed: () {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          _items[itemIndex]
                                                              .title,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'HelveticaNeue',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          )),
                                                      SizedBox(
                                                        //Use of SizedBox
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          _items[itemIndex]
                                                              .description,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'HelveticaNeue',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          )),
                                                    ],
                                                  )),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                        SizedBox(height: 20),
                        // button For CLOSE
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: FloatingActionButton.extended(
                              backgroundColor: Color.fromARGB(255, 237, 28, 36),
                              label: Text("Continue"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                              "TERMS OF AGREEMENTS. PAYMENT CAN ONLY BE STOPPED THROUGH A CANCELLATION 24 HOURS BEFORE THE BILLING DATE",
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'HelveticaNeue',
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ));
  }

  _login(BuildContext context, LoginBloc bloc) async {
    print("Login method ...");
    LoginResponse logindatd = await login(bloc.email, bloc.password);
    print("login data ...");
    print(logindatd);
    setState(() {
      _isInAsyncCall = true;
    });

    var message = logindatd.message;
    print("message: $message");
    // print("User subscription id: ${logindatd.data.user.subscriptionid}");
    //print(logindatd.toJson());
    if (logindatd.status == "false") {
      _isInAsyncCall = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Constants.USER_DATA, jsonEncode(logindatd));
      // if (logindatd.message.toUpperCase() == "SUBSCRIPTION EXPIRED") {
      //   print("Opening Alert Box this" + logindatd.message);
      //
      //   _displayTextInputDialog(context);
      // }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$message'),
      ));
      // }
    } else {
      // if (logindatd.message.toUpperCase() == "SUBSCRIPTION EXPIRED") {
      // } else {
      print("About to call purchases.login ...");
      LogInResult _ = await Purchases.logIn(logindatd.data.user.subscriptionid);
      _isInAsyncCall = false;

      if (message == 'Subscription Expired') {
        message = "Sucessful Login!";
      }
      Toast.show('$message', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Constants.USER_DATA, jsonEncode(logindatd));
      print("Constants User Data: ${logindatd.data.user.toJson()}");
      if (logindatd != null &&
          logindatd.data != null &&
          logindatd.data.user != null &&
          logindatd.data.user.userId != null) {
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .setUserProperties(logindatd.data.user.toJson());
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .setUserId(logindatd.data.user.userId.toString());
      }
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("User Logged In");
      var isDeepLink = prefs.getString(Constants.IS_DEEP_LINK);
      var planid = prefs.getString(Constants.PLAN_ID);
      var userid = prefs.getString(Constants.SHARED_USER_ID);

      if (isDeepLink == "Yes") {
        updateSharingPlanApiCall(planid, userid);

        // prefs.setString(Constants.PLAN_ID, "0");
        // prefs.setString(Constants.SHARED_USER_ID, "");
        // prefs.setString(Constants.IS_DEEP_LINK, "No");
        // Navigator.of(context).pushReplacementNamed("myplans");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
      // }
    }
  }
}

onItemTap(BuildContext context, ItemModel item) {
  String strMessage = "You had choosen " + item.description.toString();
  print(strMessage);
  Toast.show('$strMessage', context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}
