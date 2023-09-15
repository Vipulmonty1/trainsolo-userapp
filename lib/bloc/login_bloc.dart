import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:trainsolo/bloc/validator.dart';


class LoginBloc  with Validator {

  final _usernameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _forgottenPasswordEmailController = BehaviorSubject<String>();


  Function(String) get changeEmail => _usernameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeforgottenEmailPassword => _forgottenPasswordEmailController.sink.add;

  Stream<bool> get validarFormStream => Rx.combineLatest2(usernameStream, passwordStream, (a, b) => true);
  Stream<bool> get validarFormStreamforgotpassword => forgottenPasswordEmailStream.map((forgottenPasswordEmailStream) => true);

  Stream<String> get usernameStream => _usernameController.stream.transform(usernameValidar);
  Stream<String> get passwordStream => _passwordController.stream.transform(passwordValidar);
  Stream<String> get forgottenPasswordEmailStream => _forgottenPasswordEmailController.stream.transform(forgotpasswordemailValidar);


  String get email => _usernameController.value;
  String get password => _passwordController.value;
  String get emailforgotpassword => _forgottenPasswordEmailController.value;


  dispose() {
    _usernameController?.close();
    _passwordController?.close();
    _forgottenPasswordEmailController?.close();
  }



}

/*abstract class BaseBloc{
  void dispose();
}*/
