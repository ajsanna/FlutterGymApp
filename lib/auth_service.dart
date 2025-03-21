import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _userCredentialsKey = 'user_credentials';

  // Mock validation - in a real app, you would connect to a backend
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get saved credentials
    final userCredentials = prefs.getStringList(_userCredentialsKey) ?? [];
    
    // Check if the credentials match
    bool validCredentials = false;
    
    // Check hardcoded credentials for Alex first
    if (username == 'Alex' && password == 'password') {
      validCredentials = true;
    } else {
      // Check registered user credentials
      for (String credential in userCredentials) {
        final parts = credential.split(':');
        if (parts.length == 2 && parts[0] == username && parts[1] == password) {
          validCredentials = true;
          break;
        }
      }
    }
    
    if (validCredentials) {
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_usernameKey, username);
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing credentials
    final userCredentials = prefs.getStringList(_userCredentialsKey) ?? [];
    
    // Check if username already exists
    for (String credential in userCredentials) {
      final parts = credential.split(':');
      if (parts.length == 2 && parts[0] == username) {
        return false; // Username already exists
      }
    }
    
    // Add new credentials
    userCredentials.add('$username:$password');
    
    // Save updated credentials
    await prefs.setStringList(_userCredentialsKey, userCredentials);
    
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }
  
  Future<void> updateUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }
} 