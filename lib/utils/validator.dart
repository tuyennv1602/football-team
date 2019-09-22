class Validator {
  static String validEmail(String email) {
    if (email.isEmpty) return 'Vui lòng nhập email';
    final _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
        r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
    RegExp regex = RegExp(_emailRegExpString, caseSensitive: false);
    if (!regex.hasMatch(email)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String validPassword(String password) {
    if (password.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (password.length < 7) {
      return 'Mật khẩu không được nhỏ hơn 6 ký tự';
    }
    return null;
  }

  static String validPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return 'Vui lòng nhập số điện thoại';
    final _phoneRegExpString = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regex = RegExp(_phoneRegExpString, caseSensitive: false);
    if (!regex.hasMatch(phoneNumber)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  static String validName(String name) {
    if(name.isEmpty) return 'Vui lòng nhập tên người dùng';
    return null;
  }

  static String validCode(String code) {
    if(code.isEmpty) return 'Vui lòng nhập mã xác nhận';
    return null;
  }
}
