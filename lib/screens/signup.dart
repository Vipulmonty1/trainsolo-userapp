import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:trainsolo/bloc/signup_bloc.dart';
import 'package:trainsolo/bloc/singuponly_bloc.dart';
import 'package:trainsolo/screens/login_view.dart';

class SignupScreen extends StatefulWidget {
  SignupPage createState() => SignupPage();
}

class SignupPage extends State<SignupScreen> {
  ProgressDialog pr;

  TextEditingController dayController = TextEditingController()..text = "DD";
  TextEditingController monthController = TextEditingController()..text = "MM";
  TextEditingController yearController = TextEditingController()..text = "YYYY";

  getCurrentDate() {
    FocusScope.of(context).requestFocus(FocusNode());

    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1940, 1, 1),
        maxTime: DateTime(
          2050,
          12,
        ),
        theme: DatePickerTheme(
            headerColor: Color.fromARGB(255, 237, 28, 36),
            backgroundColor: Colors.black,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      setState(() {
        dayController = TextEditingController()..text = date.day.toString();
        monthController = TextEditingController()..text = date.month.toString();
        yearController = TextEditingController()..text = date.year.toString();
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

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
    final bloc = Provider.of<SignupOnlyBloc>(context, listen: false);
    // ignore: unused_local_variable
    FocusNode myFocusNode = new FocusNode();
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
                Padding(
                  padding: const EdgeInsets.only(top: 55.0, bottom: 15.0),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                    child: Text(
                      'Signup',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontFamily: 'BebasNeue',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 15.0, right: 15.0, top: 10, bottom: 10),
                //   //padding: EdgeInsets.symmetric(horizontal: 15),
                //   child: new Row(
                //     children: <Widget>[
                //       new Flexible(
                //         child: _firstnameField(bloc),
                //       ),
                //       SizedBox(width: 20),
                //       new Flexible(
                //         child: _lastnameField(bloc),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 15.0, right: 15.0, top: 10, bottom: 10),
                //   //padding: EdgeInsets.symmetric(horizontal: 15),
                //   child: new Row(
                //     children: <Widget>[
                //       new Flexible(child: _yearField(bloc)),
                //       SizedBox(width: 20),
                //       new Flexible(
                //         child: _monthField(bloc),
                //       ),
                //       SizedBox(width: 20),
                //       new Flexible(
                //         child: _dayField(bloc),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 15.0, right: 15.0, top: 10, bottom: 10),
                //   //padding: EdgeInsets.symmetric(horizontal: 15),
                //   child: _usrnameField(bloc),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10, bottom: 10),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: _emailField(bloc),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10, bottom: 10),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: _passwordField(bloc),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 15.0, right: 15.0, top: 10, bottom: 10),
                //   //padding: EdgeInsets.symmetric(horizontal: 15),
                //   child: _confirmPasswordField(bloc),
                // ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10, bottom: 10),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    _bottomButtonField(bloc),
                    _gotosiginField(bloc),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _firstnameField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.firstnameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            onChanged: bloc.changeFirstname,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              labelText: "First Name",
              hintText: 'Enter Your First name',
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _lastnameField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.lastnameStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeLastname,
            style: TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              labelText: "Last Name",
              hintText: 'Enter Your First name',
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
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _yearField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.yearStream,
        builder: (context, snapshot) {
          return TextField(
            focusNode: FocusNode(),
            onTap: getCurrentDate,
            controller: yearController,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _monthField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.monthStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeMonth,
            focusNode: FocusNode(),
            style: TextStyle(color: Colors.white),
            onTap: getCurrentDate,
            controller: monthController,
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _dayField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.dayStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeDay,
            focusNode: FocusNode(),
            style: TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
            onTap: getCurrentDate,
            controller: dayController,
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _usrnameField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.userNameStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeuserName,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              labelText: "Username",
              hintText: 'Enter Your Username',
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _emailField(SignupOnlyBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailSignupStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeEmail,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              labelText: "E-mail",
              hintText: 'Enter Your Email',
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _passwordField(SignupOnlyBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordSignupStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changePassword,
            style: TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
            obscureText: true,
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              labelText: 'Password',
              hintText: 'Enter Your Password',
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _confirmPasswordField(SignupBloc bloc) {
    return StreamBuilder(
        stream: bloc.confirmPasswordStream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeConfirmPassword,
            style: TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
            obscureText: true,
            decoration: new InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.white, fontFamily: 'HelveticaNeue'),
              border: new OutlineInputBorder(),
              fillColor: Colors.transparent,
              filled: true,
              labelText: 'Confirm Password',
              hintText: 'Re Enter Password',
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'HelveticaNeue'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _bottomButtonField(SignupOnlyBloc bloc) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10, bottom: 10),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: StreamBuilder<bool>(
                stream: bloc.validarSignupFormStream,
                builder: (context, snapshot) {
                  return MaterialButton(
                    // onPressed: () => print(
                    //     "Button was clicked, snapshot has data?: ${snapshot.hasData}"),
                    onPressed: snapshot.hasData ? () => _signup(bloc) : null,
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

  Widget _gotosiginField(SignupOnlyBloc bloc) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: new TextSpan(
                  text: "I'M ALREADY A USER, ",
                  style: TextStyle(color: Colors.white),
                  children: [
                    new TextSpan(
                        text: "SIGN IN",
                        style: TextStyle(
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontWeight: FontWeight.bold),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            print('Tap Here onTap');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          })
                  ]),
            ),
          );
        });
  }

  _signup(SignupOnlyBloc bloc) {
    if (bloc.submit()) {
      // print('username in signup: ${bloc.usernameSignup}');
      print('Email in signup: ${bloc.emailSignup}');
      print('Password: signup ${bloc.passwordSignup} ');
      // print('name: signup ${bloc.firstnameSignup} ');
      // print('last: signup ${bloc.lastnameSignup} ');
      print('year: signup ${yearController.text} ');
      print('month: signup ${monthController.text} ');
      print('day: signup ${dayController.text} ');
      // print('conformpassword: signup ${bloc.confirmPasswordSignup} ');
      Navigator.pushReplacementNamed(context, "askQuestion", arguments: {
        "year": yearController.text,
        "month": monthController.text,
        "day": dayController.text
      });
    } else {
      print('day: signup ${dayController.text} ');
    }

    //

    /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Temp(value: yearController.text)));*/
  }
}

reen() {}
