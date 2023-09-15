import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainsolo/model/check_token_response.dart';
import 'package:trainsolo/model/forgot_password_response.dart';
import 'package:trainsolo/model/reset_password_response.dart';
import 'package:trainsolo/model/signup_response.dart';
import 'package:trainsolo/screens/login_view.dart';
import '../api/api_service.dart';
import '../bloc/login_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

// ignore: must_be_immutable
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ProgressDialog pr;
  final emailController = TextEditingController();
  final tempTokenController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
    );

    return Scaffold(
      body: Stack(
        children: [
          _createForm(context),
        ],
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context, listen: false);

    return SingleChildScrollView(
      child: new Container(
        height: MediaQuery.of(context).copyWith().size.height / 0.75,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: ExactAssetImage('assets/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _pagetitleField(),
                _emailField(),
                _tokenField(),
                _newPasswordField(),
                const SizedBox(
                  height: 100.0,
                ),
              ],
            ),
            _bottomButtonField(bloc),
            _gobackField(bloc),
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
          "RESET PASSWORD.\nIf you don't see an email, please check your spam folder.",
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

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: emailController,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          labelStyle:
              TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
          border: new OutlineInputBorder(),
          hintStyle: TextStyle(
              fontSize: 15.0, color: Colors.white, fontFamily: 'HelveticaNeue'),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          labelText: 'Email',
          hintText: 'Enter Your Email Address',
        ),
      ),
    );
  }

  Widget _tokenField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: tempTokenController,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          labelStyle:
              TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
          border: new OutlineInputBorder(),
          hintStyle: TextStyle(
              fontSize: 15.0, color: Colors.white, fontFamily: 'HelveticaNeue'),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          labelText: 'Temporary Token',
          hintText: 'Enter the token sent to your email address',
        ),
      ),
    );
  }

  Widget _newPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: newPasswordController,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: new InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          labelStyle:
              TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
          border: new OutlineInputBorder(),
          hintStyle: TextStyle(
              fontSize: 15.0, color: Colors.white, fontFamily: 'HelveticaNeue'),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          labelText: 'New Password',
          hintText: 'Enter your new password',
        ),
      ),
    );
  }

  Widget _bottomButtonField(LoginBloc bloc) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10, bottom: 10),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: MaterialButton(
              onPressed: () => {
                print("Controller values ..."),
                print(emailController.text),
                print(tempTokenController.text),
                print(newPasswordController.text),
                checkAndUpdatePassword()
              },
              color: Color.fromARGB(255, 237, 28, 36),
              textColor: Colors.white,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(
                  side: BorderSide(color: Color.fromARGB(255, 237, 28, 36))),
            )),
      ],
    );
  }

  Widget _gobackField(LoginBloc bloc) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: new TextSpan(
                  text: 'GO BACK TO FORGOT PASSWORD? ',
                  style: TextStyle(color: Colors.white),
                  children: [
                    new TextSpan(
                        text: 'CLICK HERE',
                        style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontWeight: FontWeight.bold),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            print('Tap Here onTap go back');
                            Navigator.pop(context);
                          })
                  ]),
            ),
          );
        });
  }

  void checkAndUpdatePassword() async {
    CheckTokenResponse checkTokenResponse =
        await checktoken(emailController.text);
    print("Check Token response: ${checkTokenResponse.status}");
    if (checkTokenResponse.status == "true") {
      ResetPasswordResponse resetPasswordResponse = await resetPassword(
          emailController.text,
          tempTokenController.text,
          newPasswordController.text);
      String cupertinoMessage = "";
      if (resetPasswordResponse.status == "true") {
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .logEvent("Password Successfully Updated");
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              content: Text(
                'Password Sucessfully Updated!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'BebasNeue',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
            .logEvent('Unsuccessful Reset Password Attempt');
        print("Incorrect parameters, password couldn't be updated ...");
        showIncorrectCupertinoResponse();
      }
    } else {
      showIncorrectCupertinoResponse();
    }
  }

  void showIncorrectCupertinoResponse() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            'Incorrect Email/Token',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'BebasNeue',
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
