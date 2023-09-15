import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainsolo/model/forgot_password_response.dart';
import 'package:trainsolo/model/signup_response.dart';
import '../api/api_service.dart';
import '../bloc/login_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'ResetPassword.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:trainsolo/utils/Constants.dart';

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatelessWidget {
  ProgressDialog pr;
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
                _emailField(bloc),
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
          'FORGOT PASSWORD',
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

  Widget _emailField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.forgottenPasswordEmailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: bloc.changeforgottenEmailPassword,
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
                labelText: 'Email',
                hintText: 'Enter Your Email Address',
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
                stream: bloc.validarFormStreamforgotpassword,
                builder: (context, snapshot) {
                  return MaterialButton(
                    onPressed: snapshot.hasData
                        ? () => _forgotPassowrd(context, bloc)
                        : null,
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

  Widget _gobackField(LoginBloc bloc) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: new TextSpan(
                  text: 'GO BACK TO LOGIN? ',
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

  _forgotPassowrd(BuildContext context, LoginBloc bloc) async {
    print('Email: ${bloc.emailforgotpassword}');

    ForgotPasswordResponse forgotpasswordresponse =
        await forgotPassword(bloc.emailforgotpassword);
    // await pr.show();
    var message = forgotpasswordresponse.message;
    // if (!forgotpasswordresponse.status) {
    //   await pr.hide();
    //   print('$message');
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('$message'),
    //   ));
    // } else {
    //   await pr.hide();
    //   print('$message');
    //   Toast.show('$message', context,
    //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    //   Navigator.pop(context);
    // }
    if (forgotpasswordresponse.status) {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Click To Reset Password Screen");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text(
              'Unable to reset password. Please reach out to trainsolosoccerhelp@gmail.com to resolve your issue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'BebasNeue',
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              /* CupertinoDialogAction(
                  child: Text('Long Text Button'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),*/
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
}
