import 'package:rxdart/rxdart.dart';

import 'validator.dart';

class SignupOnlyBloc with Validator {
  final _emailSignupController = BehaviorSubject<String>();
  final _passwordSignupController = BehaviorSubject<String>();

  //Setter...........................on change

  Function(String) get changeEmail => _emailSignupController.sink.add;

  Function(String) get changePassword => _passwordSignupController.sink.add;

  submit() {
    return true;
  }

  Stream<bool> get validarSignupFormStream => Rx.combineLatest2(
      emailSignupStream, passwordSignupStream, (a, b) => true);

/*Stream<bool>get isPasswordMatch => Rx.combineLatest2(passwordSignupStream, confirmPasswordStream, (a, b){
  if (a !=b){
    return false;
  }else{
    return true;
  }
});*/

  Stream<String> get emailSignupStream =>
      _emailSignupController.stream.transform(emailSignupValidar);

  Stream<String> get passwordSignupStream =>
      _passwordSignupController.stream.transform(passwordSignupValidar);

  String get emailSignup => _emailSignupController.value;

  String get passwordSignup => _passwordSignupController.value;

  dispose() {
    _emailSignupController?.close();
    _passwordSignupController?.close();
  }
}
