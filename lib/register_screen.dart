import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'theme_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  final AuthService _authService = AuthService();

  void _register() async {
    // Basic validation
    if (_usernameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Email cannot be empty';
      });
      return;
    }

    // Email format validation
    if (!_usernameController.text.contains('@') || !_usernameController.text.contains('.')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Password cannot be empty';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('Starting registration process...'); // Debug log
      // Register the user with AuthService
      final success = await _authService.register(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        print('Registration successful'); // Debug log
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful! Please log in.')),
        );
        Navigator.pop(context); // Return to login screen
      } else {
        print('Registration failed'); // Debug log
        // Registration failed
        setState(() {
          _errorMessage = 'Registration failed. Please try a different email.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Registration error in screen: $e'); // Debug log
      setState(() {
        _errorMessage = 'Registration failed: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
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
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 30),
                
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
                const SizedBox(height: 16),
                
                // Confirm Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.deepPurple),
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
                
                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
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
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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