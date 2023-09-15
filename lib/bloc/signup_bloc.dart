import 'package:rxdart/rxdart.dart';

import 'validator.dart';

class SignupBloc with Validator {
  final _firstnameController = BehaviorSubject<String>();
  final _lastnameController = BehaviorSubject<String>();
  final _yearController = BehaviorSubject<String>();
  final _monthController = BehaviorSubject<String>();
  final _dayController = BehaviorSubject<String>();
  final _emailSignupController = BehaviorSubject<String>();
  final _usernameSignupController = BehaviorSubject<String>();
  final _passwordSignupController = BehaviorSubject<String>();
  final _confirmPasswordField = BehaviorSubject<String>();

  //Setter...........................on change

  Function(String) get changeuserName => _usernameSignupController.sink.add;

  Function(String) get changeEmail => _emailSignupController.sink.add;

  Function(String) get changePassword => _passwordSignupController.sink.add;

  Function(String) get changeFirstname => _firstnameController.sink.add;

  Function(String) get changeLastname => _lastnameController.sink.add;

  Function(String) get changeYear => _yearController.sink.add;

  Function(String) get changeMonth => _monthController.sink.add;

  Function(String) get changeDay => _dayController.sink.add;

  Function(String) get changeConfirmPassword => _confirmPasswordField.sink.add;

  submit() {
    if (passwordSignup != confirmPasswordSignup) {
      _confirmPasswordField.sink.addError("Password Not Match");
      return false;
    } else {
      return true;
    }
  }

  Stream<bool> get validarSignupFormStream => Rx.combineLatest6(
      firstnameStream,
      lastnameStream,
      userNameStream,
      emailSignupStream,
      passwordSignupStream,
      confirmPasswordStream,
      (a, b, f, g, h, i) => true);

/*Stream<bool>get isPasswordMatch => Rx.combineLatest2(passwordSignupStream, confirmPasswordStream, (a, b){
  if (a !=b){
    return false;
  }else{
    return true;
  }
});*/
  Stream<String> get firstnameStream =>
      _firstnameController.stream.transform(firstnameValidar);

  Stream<String> get lastnameStream =>
      _lastnameController.stream.transform(lastnameValidar);

  Stream<String> get yearStream =>
      _yearController.stream.transform(yearValidar);

  Stream<String> get monthStream =>
      _monthController.stream.transform(monthValidar);

  Stream<String> get dayStream => _dayController.stream.transform(dayValidar);

  Stream<String> get userNameStream =>
      _usernameSignupController.stream.transform(usernameSignupValidar);

  Stream<String> get emailSignupStream =>
      _emailSignupController.stream.transform(emailSignupValidar);

  Stream<String> get passwordSignupStream =>
      _passwordSignupController.stream.transform(passwordSignupValidar);

  Stream<String> get confirmPasswordStream =>
      _confirmPasswordField.stream.transform(confirmPasswordValidar);

  String get usernameSignup => _usernameSignupController.value;

  String get emailSignup => _emailSignupController.value;

  String get passwordSignup => _passwordSignupController.value;

  String get firstnameSignup => _firstnameController.value;

  String get lastnameSignup => _lastnameController.value;

  String get yearSignup => _yearController.value;

  String get monthSignup => _monthController.value;

  String get daySignup => _dayController.value;

  String get confirmPasswordSignup => _confirmPasswordField.value;

  dispose() {
    _usernameSignupController?.close();
    _emailSignupController?.close();
    _passwordSignupController?.close();
    _firstnameController?.close();
    _lastnameController?.close();
    _yearController?.close();
    _monthController?.close();
    _dayController?.close();
    _confirmPasswordField?.close();
  }
}
