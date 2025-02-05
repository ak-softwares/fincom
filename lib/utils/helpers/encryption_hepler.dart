import 'package:bcrypt/bcrypt.dart';

class EncryptionHelper {
  // Function to hash the password using bcrypt
  Future<String> hashPassword(String password) async {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  // Function to compare a plaintext password with a hashed password
  Future<bool> comparePasswords(String plainPassword, String hashedPassword) async {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }
}
