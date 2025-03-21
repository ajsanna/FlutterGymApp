import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _userCredentialsKey = 'user_credentials';
  static const String _themeKey = 'user_theme';

  // Mock validation - in a real app, you would connect to a backend
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get saved credentials
    final userCredentials = prefs.getStringList(_userCredentialsKey) ?? [];
    print('Login attempt - Username: $username, Password: $password');
    print('Current credentials in storage: $userCredentials');
    
    // Check if the credentials match
    bool validCredentials = false;
    
    // Check hardcoded credentials for Alex first
    if (username == 'Alex' && password == 'password') {
      print('Login success: matched hardcoded credentials for Alex');
      validCredentials = true;
    } else {
      // Check registered user credentials
      for (String credential in userCredentials) {
        final parts = credential.split(':');
        print('Checking credential: ${parts.join(':')}');
        if (parts.length == 2 && parts[0] == username && parts[1] == password) {
          print('Login success: matched stored credentials');
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
    print('Login failed: no matching credentials found');
    return false;
  }

  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    print('Register attempt - Username: $username');
    
    // Get existing credentials
    final userCredentials = prefs.getStringList(_userCredentialsKey) ?? [];
    print('Current credentials before registration: $userCredentials');
    
    // Check if username already exists
    for (String credential in userCredentials) {
      final parts = credential.split(':');
      if (parts.length == 2 && parts[0] == username) {
        print('Registration failed: username already exists');
        return false; // Username already exists
      }
    }
    
    // Add new credentials
    userCredentials.add('$username:$password');
    
    // Save updated credentials
    await prefs.setStringList(_userCredentialsKey, userCredentials);
    print('Registration successful. Updated credentials: $userCredentials');
    
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
  
  Future<void> updateUsername(String newUsername) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get the current username
    String? oldUsername = await getUsername();
    if (oldUsername == null) return;
    
    print('Updating username from "$oldUsername" to "$newUsername"');
    
    // Update the username in SharedPreferences
    await prefs.setString(_usernameKey, newUsername);
    
    // Also update the username in the credentials list
    final userCredentials = prefs.getStringList(_userCredentialsKey) ?? [];
    print('Current credentials before update: $userCredentials');
    
    List<String> updatedCredentials = [];
    bool updated = false;
    
    // For the special case of "Alex", add a new credential rather than updating
    if (oldUsername == "Alex") {
      // Add a new credential for the new username, with the same password as Alex
      updatedCredentials.addAll(userCredentials);
      updatedCredentials.add('$newUsername:password');
      await prefs.setStringList(_userCredentialsKey, updatedCredentials);
      print('Updated credentials after Alex change: $updatedCredentials');
      return;
    }
    
    // Update the username in credentials while keeping the same password
    for (String credential in userCredentials) {
      final parts = credential.split(':');
      if (parts.length == 2) {
        if (parts[0] == oldUsername) {
          // Found the old username, update it while keeping the password
          updatedCredentials.add('$newUsername:${parts[1]}');
          updated = true;
        } else {
          // Keep other credentials unchanged
          updatedCredentials.add(credential);
        }
      }
    }
    
    // Save the updated credentials list
    if (updatedCredentials.isNotEmpty) {
      await prefs.setStringList(_userCredentialsKey, updatedCredentials);
      print('Updated credentials after normal change: $updatedCredentials');
    } else if (!updated) {
      // If we didn't find and update the old username in the credentials list,
      // this might be because of login with hardcoded credentials or an inconsistent state.
      // In this case, add a new credential for the new username (using a default password)
      userCredentials.add('$newUsername:password');
      await prefs.setStringList(_userCredentialsKey, userCredentials);
      print('Added new credential because old was not found: $userCredentials');
    }
  }

  // Debug method to print all credentials
  Future<List<String>> getAllCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_userCredentialsKey) ?? [];
  }

  // Check if a username exists
  Future<bool> usernameExists(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final userCredentials = prefs.getStringList(_userCredentialsKey) ?? [];
    
    // Check special case for Alex
    if (username == 'Alex') return true;
    
    // Check in stored credentials
    for (String credential in userCredentials) {
      final parts = credential.split(':');
      if (parts.length == 2 && parts[0] == username) {
        return true;
      }
    }
    
    return false;
  }

  // Clear all stored credentials (for testing purposes)
  Future<void> clearAllCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCredentialsKey);
    print('All credentials cleared');
  }

  // Theme methods
  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    final username = await getUsername();
    if (username == null) return;
    
    await prefs.setString('${_themeKey}_$username', theme);
    print('Saved theme "$theme" for user $username');
  }

  Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final username = await getUsername();
    if (username == null) return 'default';
    
    final theme = prefs.getString('${_themeKey}_$username');
    print('Retrieved theme "$theme" for user $username');
    return theme ?? 'default';
  }
  
  // Update password for the current user
  Future<bool> updatePassword(String currentPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final username = await getUsername();
    if (username == null) return false;
    
    print('Updating password for user: $username');
    
    // Verify current password first
    bool passwordVerified = false;
    
    // Special case for Alex
    if (username == 'Alex' && currentPassword == 'password') {
      passwordVerified = true;
    } else {
      // Get credentials list
      final userCredentials = prefs.getStringList(_userCredentialsKey) ?? [];
      
      // Find and verify current password
      for (String credential in userCredentials) {
        final parts = credential.split(':');
        if (parts.length == 2 && parts[0] == username && parts[1] == currentPassword) {
          passwordVerified = true;
          break;
        }
      }
    }
    
    if (!passwordVerified) {
      print('Password update failed: Current password is incorrect');
      return false;
    }
    
    // Update password in credentials list
    final userCredentials = prefs.getStringList(_userCredentialsKey) ?? [];
    List<String> updatedCredentials = [];
    bool updated = false;
    
    // Special case for Alex
    if (username == 'Alex') {
      // Add a new credential with the new password
      updatedCredentials.addAll(userCredentials);
      updatedCredentials.add('$username:$newPassword');
      await prefs.setStringList(_userCredentialsKey, updatedCredentials);
      print('Updated password for Alex');
      return true;
    }
    
    // Update password for regular users
    for (String credential in userCredentials) {
      final parts = credential.split(':');
      if (parts.length == 2) {
        if (parts[0] == username) {
          // Found the username, update its password
          updatedCredentials.add('$username:$newPassword');
          updated = true;
        } else {
          // Keep other credentials unchanged
          updatedCredentials.add(credential);
        }
      }
    }
    
    // Save the updated credentials list
    if (updated) {
      await prefs.setStringList(_userCredentialsKey, updatedCredentials);
      print('Password updated successfully for user: $username');
      return true;
    } else {
      // This should not happen if passwordVerified is true, but just in case
      print('Password update failed: Username not found in credentials');
      return false;
    }
  }
} 