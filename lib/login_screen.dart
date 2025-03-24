import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'register_screen.dart';
import 'theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      // If already logged in, navigate to home
      // Adding a small delay to ensure the widget is mounted
      Future.delayed(Duration.zero, () {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/home', 
          (route) => false, // This removes all previous routes
        );
      });
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Use auth service for login
    final success = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      // Reload theme for the newly logged in user
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      await themeProvider.loadTheme();
      
      // Login successful
      // Use pushNamedAndRemoveUntil to clear the navigation stack
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/home', 
        (route) => false, // This removes all previous routes
      );
    } else {
      // Login failed
      setState(() {
        _errorMessage = 'Invalid username or password';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).getGradientForTheme(),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or App Title
                Text(
                  'GymBuddy',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 50),
                
                // Email Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Error Message
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red.shade100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.deepPurple)
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                // Register Link
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 