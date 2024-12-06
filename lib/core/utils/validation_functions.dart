// Checks if string is email.
bool isValidEmail(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
  if (isRequired && (inputString == null || inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern =
        r"(^([0-9a-zA-Z]([-\.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\."
        r"([a-zA-Z]{2,9})$))";
    RegExp regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}

// Password should have:
// At least a upper case letter
// At least a lower case letter
// At least a special character [@#$%^&+=]
// No white space allowed
bool isValidPassword(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
  if (isRequired && (inputString == null || inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern =
        r"(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=])(?!.*\s).{8,}";
    RegExp regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}
