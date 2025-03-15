import 'package:intl/intl.dart';

class TFormatter {

  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MM-yyyy').format(date);
  }
  static String formatStringDate(String dateString) {
    try {
      // Try parsing the input string as a DateTime object
      DateTime parsedDate = DateTime.parse(dateString);

      // Format the date using the desired pattern
      final DateFormat formatter = DateFormat('yyyy-MM-dd'); // Customize the format as needed
      return formatter.format(parsedDate);
    } catch (e) {
      // If parsing fails, return the original string
      return dateString;
    }
  }

  static String maskEmail(String email) {
    // Split email into username and domain
    List<String> parts = email.split('@');
    if (parts.length != 2) {
      // Invalid email format
      return email;
    }

    String username = parts[0];
    String domain = parts[1];

    // Extract first two characters
    String firstTwo = username.substring(0, 2);

    // Extract last two characters
    String lastTwo = username.substring(username.length - 2);

    return '$firstTwo***$lastTwo@$domain';
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    //Assuming a 10-digit US phone number format: (123) 456-7895
    if(phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6) }';
    }else if(phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7) }';
    }
    return phoneNumber;
  }
}