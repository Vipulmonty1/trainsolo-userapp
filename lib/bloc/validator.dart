import 'dart:async';

mixin Validator {
  var passwordValidar = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Password length should be greater than 5 characters');
    }
  });

  var usernameValidar =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.length >= 4) {
      sink.add(email);
    } else {
      sink.addError('Email address is not valid');
    }

    /* Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Email address is not a valid');
    }*/
  });

  var forgotpasswordemailValidar =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (emailforgotpassword, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(emailforgotpassword)) {
      sink.add(emailforgotpassword);
    } else {
      sink.addError('Email address is not valid');
    }
  });

  // validation for Signup

  var emailSignupValidar = StreamTransformer<String, String>.fromHandlers(
      handleData: (emailSignup, sink) {
    /* if (email.length >= 4) {
      sink.add(email);
    } else {
      sink.addError('Email signup address is not a valid');
    }*/

    // Pattern pattern =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    //
    // RegExp regExp = new RegExp(pattern);
    //
    // if (regExp.hasMatch(emailSignup)) {
    //   sink.add(emailSignup);
    // } else {
    //   sink.addError('Email address is not valid');
    // }

    sink.add(emailSignup);
  });

  var passwordSignupValidar = StreamTransformer<String, String>.fromHandlers(
      handleData: (passwordSignup, sink) {
    if (passwordSignup.length > 5) {
      sink.add(passwordSignup);
    } else {
      sink.addError('Password length should be greater than 5 characters');
    }
  });
  var firstnameValidar = StreamTransformer<String, String>.fromHandlers(
      handleData: (firstname, sink) {
    if (firstname.length > 0) {
      sink.add(firstname);
    } else {
      sink.addError('firstname must not be empty');
    }
  });
  var lastnameValidar = StreamTransformer<String, String>.fromHandlers(
      handleData: (lastname, sink) {
    if (lastname.length > 0) {
      sink.add(lastname);
    } else {
      sink.addError('lastname must not be empty');
    }
  });
  var usernameSignupValidar = StreamTransformer<String, String>.fromHandlers(
      handleData: (usernameSignupValidar, sink) {
    if (usernameSignupValidar.length > 0) {
      sink.add(usernameSignupValidar);
    } else {
      sink.addError('username must not be empty');
    }
  });
  var yearValidar =
      StreamTransformer<String, String>.fromHandlers(handleData: (year, sink) {
    if (year.length > 0) {
      sink.add(year);
    } else {
      sink.addError('year must not be empty');
    }
  });
  var monthValidar =
      StreamTransformer<String, String>.fromHandlers(handleData: (month, sink) {
    if (month.length > 0) {
      sink.add(month);
    } else {
      sink.addError('month must not be empty');
    }
  });
  var dayValidar =
      StreamTransformer<String, String>.fromHandlers(handleData: (day, sink) {
    if (day.length > 0) {
      sink.add(day);
    } else {
      sink.addError('day must not be empty');
    }
  });
  var confirmPasswordValidar = StreamTransformer<String, String>.fromHandlers(
      handleData: (confirmpassword, sink) {
    if (confirmpassword.length > 0) {
      sink.add(confirmpassword);
    } else {
      sink.addError('conform password must not be empty');
    }
  });
}
