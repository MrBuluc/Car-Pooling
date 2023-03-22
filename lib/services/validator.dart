class Validator {
  static String? textControl(String? text, String label) {
    text = text?.trim();
    RegExp regex = RegExp(
        "^[abcçdefgğhıijklmnoöprsştuüvyzqwxABCÇDEFGHIİJKLMNOÖPRSŞTUÜVYZQWX]+\$");
    if (!regex.hasMatch(text!)) {
      return "$label numara veya boşluk içermemeli";
    }
    return null;
  }

  static String? emailControl(String? email, String label) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email!)) {
      return "Invalid email";
    }
    return null;
  }

  static String? emptyControl(String? value, String emptyText) =>
      value!.isEmpty ? emptyText : null;
}
