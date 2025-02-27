import 'package:bcrypt/bcrypt.dart';

class EncryptionHelper {
  // Function to hash the password using bcrypt
  static String hashPassword({required String password}) {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  // Function to compare a plaintext password with a hashed password
  static bool comparePasswords({required String plainPassword, required String hashedPassword}) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }
}
