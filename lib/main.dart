import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trainsolo/bloc/singuponly_bloc.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/screens/SharePlan.dart';

import 'package:trainsolo/screens/TempTest.dart';
import 'package:trainsolo/screens/CreateGroup.dart';
import 'package:trainsolo/screens/EditProfile.dart';
import 'package:trainsolo/screens/Library.dart';
import 'package:trainsolo/screens/Mission.dart';
import 'package:trainsolo/screens/MyPlans.dart';
import 'package:trainsolo/screens/Profile.dart';
import 'package:trainsolo/screens/Train.dart';
import 'package:trainsolo/screens/TrainingOnGoingComplete.dart';
import 'package:trainsolo/screens/TrainingVideo.dart';
import 'package:trainsolo/screens/forgot_password.dart';
import 'package:trainsolo/screens/home_page.dart';
import 'package:trainsolo/screens/login_view.dart';
import 'package:trainsolo/screens/Authentication.dart';
import 'package:trainsolo/screens/SignupAll.dart';
import 'package:trainsolo/bloc/login_bloc.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'api/api_service.dart';
import 'bloc/signup_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'model/common_success.dart';
import 'screens/Dashboard.dart';
import 'screens/signup.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:amplitude_flutter/amplitude.dart';

void main() async {
  // TODO: Decide if we want to migrate this to FutureBulider if load time is bad
  print("Main method running");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();
  final Amplitude analytics =
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME);
  // Initialize SDK
  analytics.init(Constants.AMPLITUDE_API_KEY);
  analytics.enableCoppaControl();
  // print("About to create a Firebase analytics ...");
  // // FirebaseAnalytics analytics = FirebaseAnalytics();
  // print("Finished creating Firebase analytics ...");
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(Constants.SDK_KEY);
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    print("List of entitlements: ${purchaserInfo.entitlements}");
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
    );

    return MultiProvider(
      providers: [
        Provider<LoginBloc>(create: (context) => LoginBloc()),
        Provider<SignupBloc>(create: (context) => SignupBloc()),
        Provider<SignupOnlyBloc>(create: (context) => SignupOnlyBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splash',
        routes: {
          'splash': (BuildContext context) => Splash(),
          'authentication': (BuildContext context) => Authentication(),
          'login': (BuildContext context) => LoginScreen(),
          'home': (BuildContext context) => HomePage(),
          'askQuestion': (BuildContext context) => SignupAll(),
          'signup': (BuildContext context) => SignupScreen(),
          'trainingOngoing': (BuildContext context) => TrainingVideo(
                drillItem: null,
              ),
          'forgotPassword': (BuildContext context) => ForgotPasswordScreen(),
          'dashboard': (BuildContext context) => Dashboard(),
          'train': (BuildContext context) => Train(
                onCreatplanPress: () {},
              ),
          'mission': (BuildContext context) => Mission(),
          'library': (BuildContext context) => Library(),
          'myplans': (BuildContext context) => MyPlans(),
          'profile': (BuildContext context) => Profile(),
          'createGroup': (BuildContext context) => CreateGroup(),
          'editProfile': (BuildContext context) => EditProfile(
                userpersonaldata: null,
              ),
          'trainingOngoinComplete': (BuildContext context) =>
              TrainingOnGoingComplete(null),
          'tempTest': (BuildContext context) => TempTest(),
          // ignore: missing_required_param
          'sharePlan': (BuildContext context) => SharePlan(),
          //'subscription': (BuildContext context) => Subscription()
        },
      ),
    );
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}

class Splash extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<Splash> {
  @override
  void initState() {
    // print("Initializing splash screen state ...");
    super.initState();
    Timer(Duration(seconds: 5), () async {
      initDynamicLinks();
    });
  }

  Future<void> initDynamicLinks() async {
    print("Init dynamic links running ...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Retrieved shared preferences ...");
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      print("On success method running ...");
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        final queryParams = deepLink.queryParameters;
        if (queryParams.length > 0) {
          String planId = queryParams["planId"];
          print("Plan id from dynamic link:$planId");
          String sharedUserID = queryParams["userId"];
          print("User id from dynamic link:$sharedUserID");
          //Toast.show('+id+$planId+name+$planName+viewplan+$viewPlan+saveplan+$isSavePlan+genrateplan+$isGenaratPlan', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          setState(() {
            prefs.setString(Constants.VIEW_PLAN, "true");
            prefs.setString(Constants.PLAN_ID, planId);
            prefs.setString(Constants.SHARED_USER_ID, sharedUserID);
            prefs.setBool(Constants.IS_SAVED_PLAN, true);
            prefs.setBool(Constants.IS_GENARATE_PLAN, false);
            prefs.setString(Constants.IS_DEEP_LINK, "Yes");
            getNavigation();
          });
        }
      } else {
        prefs.setString(Constants.VIEW_PLAN, "false");
        prefs.setString(Constants.PLAN_ID, "0");
        prefs.setString(Constants.SHARED_USER_ID, "");
        prefs.setBool(Constants.IS_SAVED_PLAN, false);
        prefs.setBool(Constants.IS_GENARATE_PLAN, true);
        prefs.setString(Constants.IS_DEEP_LINK, "No");

        getNavigation();
      }
    }, onError: (OnLinkErrorException e) async {
      print("On error method running ...");
      Toast.show('ERRROR AVI', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    });
    print("About to get pending dynamic link data ...");
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    print("About to get deeplink data ...");
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print(deepLink);
      print("Deeplink is not null ...");
      final queryParams = deepLink.queryParameters;
      print("Length of query params:${queryParams.length}");
      if (queryParams.length > 0) {
        print("Query params > 0 ...");
        String planId = queryParams["planId"];
        print("Plan id from dynamic link:$planId");
        String sharedUserID = queryParams["userId"];
        print("User id from dynamic link:$sharedUserID");
        String planName = queryParams["planName"];
        print("Plan Name:$planName");
        // Toast.show('+id+$planId+name+$planName+viewplan+$viewPlan+saveplan+$isSavePlan+genrateplan+$isGenaratPlan', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        setState(() {
          prefs.setString(Constants.VIEW_PLAN, "true");
          prefs.setString(Constants.PLAN_ID, planId);
          prefs.setString(Constants.SHARED_USER_ID, sharedUserID);
          prefs.setBool(Constants.IS_SAVED_PLAN, true);
          prefs.setBool(Constants.IS_GENARATE_PLAN, false);
          prefs.setString(Constants.IS_DEEP_LINK, "Yes");
          prefs.setString(Constants.PLAN_NAME, planName);
          print(sharedUserID + " >>>>> " + planId.toString());
          getNavigation();
        });
      }
    } else {
      prefs.setString(Constants.VIEW_PLAN, "false");
      prefs.setString(Constants.PLAN_ID, "0");
      prefs.setString(Constants.SHARED_USER_ID, "");
      prefs.setString(Constants.IS_DEEP_LINK, "No");
      prefs.setBool(Constants.IS_SAVED_PLAN, false);
      prefs.setBool(Constants.IS_GENARATE_PLAN, true);

      getNavigation();
    }
    getNavigation();
    print("Method finished ...");
  }

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
              Container(
                  child: Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('assets/logowhite.png'),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateSharingPlanApiCall(String planid, String players) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdata = prefs.getString(Constants.USER_DATA);
    final jsonResponse = json.decode(userdata);
    LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
    if (loginResponse.data != null) {
      String userId = loginResponse.data.user.userId.toString();
      CommonSuccess response =
          await updateSharingPlan(players, "", planid, userId, "", "USERS");
      if (response.status == "true") {}
    }
  }

  Future<void> getNavigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parsdata = prefs.getString(Constants.USER_DATA);
    var isDeepLink = prefs.getString(Constants.IS_DEEP_LINK);
    var planid = prefs.getString(Constants.PLAN_ID);
    var userid = prefs.getString(Constants.SHARED_USER_ID);
    if (parsdata != null) {
      final jsonResponse = json.decode(parsdata);
      LoginResponse userdata = new LoginResponse.fromJson(jsonResponse);
      // print("User data: ${userdata.data}");
      if (userdata.data == null || userdata.data.token == null) {
        Navigator.of(context).pushReplacementNamed("authentication");
      } else {
        if (isDeepLink == "Yes") {
          updateSharingPlanApiCall(planid, userid);
          // prefs.setString(Constants.PLAN_ID, "0");
          // prefs.setString(Constants.SHARED_USER_ID, "");
          // prefs.setString(Constants.IS_DEEP_LINK, "No");
          Navigator.of(context).pushReplacementNamed("myplans");
        } else
          Navigator.of(context).pushReplacementNamed("dashboard");
      }
    } else {
      Navigator.of(context).pushReplacementNamed("authentication");
    }
  }
}
