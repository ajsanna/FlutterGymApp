import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _themeKey = 'user_theme';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      // Sign in with Firebase using actual email
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Store login state and username (using email as username)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_usernameKey, email);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Register with email and password
  Future<bool> register(String email, String password) async {
    try {
      // Create user with Firebase using actual email
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Store login state and username (using email as username)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_usernameKey, email);
        return true;
      }
      return false;
    } catch (e) {
      print('Registration error details: $e');
      if (e is FirebaseAuthException) {
        print('Firebase Auth Error Code: ${e.code}');
        print('Firebase Auth Error Message: ${e.message}');
        print('Firebase Auth Stack Trace: ${e.stackTrace}');
      } else {
        print('Non-Firebase Error: ${e.toString()}');
        print('Error Type: ${e.runtimeType}');
      }
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Check login status error: $e');
      return false;
    }
  }

  // Get current username (email)
  Future<String?> getUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_usernameKey);
    } catch (e) {
      print('Get username error: $e');
      return null;
    }
  }

  // Update username (email)
  Future<void> updateUsername(String newEmail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final oldEmail = await getUsername();
      
      if (oldEmail != null) {
        // Update email in Firebase
        final user = _auth.currentUser;
        if (user != null) {
          await user.updateEmail(newEmail);
          
          // Update local storage
          await prefs.setString(_usernameKey, newEmail);
        }
      }
    } catch (e) {
      print('Update username error: $e');
    }
  }

  // Check if email exists
  Future<bool> usernameExists(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      print('Check email exists error: $e');
      return false;
    }
  }

  // Update password
  Future<bool> updatePassword(String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Reauthenticate user before updating password
        final email = await getUsername();
        if (email != null) {
          final credential = EmailAuthProvider.credential(
            email: email,
            password: currentPassword,
          );
          
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(newPassword);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Update password error: $e');
      return false;
    }
  }

  // Theme methods
  Future<void> saveTheme(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = await getUsername();
      if (username != null) {
        await prefs.setString('${_themeKey}_$username', theme);
      }
    } catch (e) {
      print('Save theme error: $e');
    }
  }

  Future<String> getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = await getUsername();
      if (username != null) {
        return prefs.getString('${_themeKey}_$username') ?? 'default';
      }
      return 'default';
    } catch (e) {
      print('Get theme error: $e');
      return 'default';
    }
  }
} 