
import 'dart:math';

class TValidator {

  static bool isEmail(String value) {
    // Regular expression for validating an email address
    final RegExp regex = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        caseSensitive: false,
        multiLine: false
    );
    return regex.hasMatch(value);
  }

  static String? getFormattedTenDigitNumber(String phone) {
    // Remove spaces, '+', '(', ')', and black spaces
    String cleanedPhone = phone.replaceAll(RegExp(r'[\s+\(\)]'), '');

    // Extract last 10 digits
    String tenDigitNumber = cleanedPhone.substring(max(0, cleanedPhone.length - 10));

    return tenDigitNumber.length == 10 ? tenDigitNumber : null;
  }

  static String? validateEmail(String? value) {
    if(value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");

    if(!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if(value == null || value.isEmpty) {
      return 'Password is required.';
    }

    //Check for minimum password lenth
    if(value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // //Check for uppercase letters
    // if(!value.contains(RegExp(r'[0-9]'))) {
    //   return 'Password must contain at least one number.';
    // }
    //
    // //Check for special characters
    // if(!value.contains(RegExp(r'[!@#%^&*()_+-=[]{}|;:",./<>?~`]'))){
    //   return 'Password must contain at least one special character.';
    // }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Check if the value is a 10-digit number
    if (value.length != 10 || int.tryParse(value) == null) {
      return 'Invalid: 10 Digit number required';
    }
    // Return null if validation succeeds
    return null;
  }

  static String? validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }

    // Regular expression to match exactly six digits
    RegExp pinCodeRegex = RegExp(r'^\d{6}$');

    if (!pinCodeRegex.hasMatch(value)) {
      return 'Pincode must be a 6-digit number';
    }

    return null;
  }

  static String? validateEmptyText(String? fieldName, String? value) {
    if(value == null || value.isEmpty){
      return '$fieldName is required';
    }
    return null;
  }

}





