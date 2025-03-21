import 'package:flutter/material.dart';
import 'auth_service.dart';

class ThemeProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String _currentTheme = 'default';
  
  ThemeProvider() {
    loadTheme();
  }
  
  String get currentTheme => _currentTheme;
  
  Future<void> loadTheme() async {
    _currentTheme = await _authService.getTheme();
    notifyListeners();
  }
  
  Future<void> setTheme(String theme) async {
    if (_currentTheme == theme) return;
    
    _currentTheme = theme;
    await _authService.saveTheme(theme);
    notifyListeners();
  }
  
  ThemeData getThemeData() {
    switch (_currentTheme) {
      case 'purple':
        return ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          scaffoldBackgroundColor: Colors.purple[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        );
      case 'green':
        return ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          scaffoldBackgroundColor: Colors.green[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        );
      case 'blue':
        return ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          scaffoldBackgroundColor: Colors.blue[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        );
      case 'red':
        return ThemeData(
          primarySwatch: Colors.red,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          scaffoldBackgroundColor: Colors.red[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        );
      case 'yellow':
        return ThemeData(
          primarySwatch: Colors.amber,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          scaffoldBackgroundColor: Colors.amber[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
        );
      case 'default':
      default:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        );
    }
  }
  
  LinearGradient getGradientForTheme() {
    switch (_currentTheme) {
      case 'purple':
        return LinearGradient(
          colors: [Colors.purple.shade300, Colors.deepPurple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'green':
        return LinearGradient(
          colors: [Colors.green.shade300, Colors.teal],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'blue':
        return LinearGradient(
          colors: [Colors.blue.shade300, Colors.indigo],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'red':
        return LinearGradient(
          colors: [Colors.red.shade300, Colors.deepOrange],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'yellow':
        return LinearGradient(
          colors: [Colors.amber.shade300, Colors.orange],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'default':
      default:
        return LinearGradient(
          colors: [Colors.blue.shade300, Colors.deepPurple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
} 