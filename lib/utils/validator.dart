class Validator {
  bool validEmail(String email) {
    final _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
        r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
    return RegExp(_emailRegExpString, caseSensitive: false).hasMatch(email);
  }

  bool validPassword(String password) {
    return password.length >= 6;
  }

  bool validPhoneNumber(String phoneNumber) {
    return phoneNumber.length == 10;
  }
}
