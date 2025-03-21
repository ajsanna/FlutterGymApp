import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'auth_service.dart';
import 'register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymBuddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      initialRoute: '/', // Start with the login screen
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const MyHomePage(title: 'Gym Buddy 1.0'),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String _username = 'User';
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUsername();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadUsername();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await _authService.getUsername();
    if (username != null && mounted) {
      setState(() {
        _username = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.deepPurple,
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Welcome, $_username',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.deepPurple,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/IMG_6510.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Button 1 - Input Data
              SizedBox(
                width: 320,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScreenOne()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Input Data', style: TextStyle(fontSize: 32)),
                ),
              ),

              SizedBox(height: 20),

              // Button 2 - View Workouts
              SizedBox(
                width: 320,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScreenTwo()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Browse Workouts', style: TextStyle(fontSize: 32)),
                ),
              ),

              SizedBox(height: 20),
              SizedBox(
                width: 320,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScreenThree()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('View History', style: TextStyle(fontSize: 32)),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 320,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to profile screen and refresh username when returning
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScreenFour()),
                    );
                    // Reload username when returning from profile
                    _loadUsername();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Edit Profile', style: TextStyle(fontSize: 32)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {


  final TextEditingController nameController = TextEditingController();
  final TextEditingController muscleGroupController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Save the workout data (mock implementation)
  Future<void> _saveWorkout(BuildContext context) async {
    // Show the success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade200,
          title: Text(
            'Entry Added',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Your workout entry has been saved!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
                Navigator.pop(context);       // Go back to the previous screen
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Open the date picker to select the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Data')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: muscleGroupController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Muscle Group',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: repsController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Reps',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: setsController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Sets',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: dateController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () => _selectDate(context),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                readOnly: true, // Make the date field read-only
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveWorkout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Save Workout',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ScreenTwo extends StatelessWidget {
  // Sample data for exercises
  final List<Map<String, String>> exercises = [
    {'name': 'Push Ups', 'muscle_group': 'Chest', 'sets': '3', 'reps': '12-15'},
    {'name': 'Squats', 'muscle_group': 'Legs', 'sets': '4', 'reps': '15-20'},
    {'name': 'Pull Ups', 'muscle_group': 'Back', 'sets': '3', 'reps': '8-12'},
    {'name': 'Bicep Curls', 'muscle_group': 'Arms', 'sets': '4', 'reps': '10-12'},
    {'name': 'Deadlifts', 'muscle_group': 'Full Body', 'sets': '3', 'reps': '8-10'},
    {'name': 'Bench Press', 'muscle_group': 'Chest', 'sets': '4', 'reps': '8-12'},
    {'name': 'Lunges', 'muscle_group': 'Legs', 'sets': '3', 'reps': '10-12 (each leg)'},
    {'name': 'Overhead Press', 'muscle_group': 'Shoulders', 'sets': '4', 'reps': '8-10'},
    {'name': 'Tricep Dips', 'muscle_group': 'Arms', 'sets': '3', 'reps': '10-15'},
    {'name': 'Leg Press', 'muscle_group': 'Legs', 'sets': '4', 'reps': '12-15'},
    {'name': 'Lat Pulldown', 'muscle_group': 'Back', 'sets': '3', 'reps': '8-12'},
    {'name': 'Chest Fly', 'muscle_group': 'Chest', 'sets': '3', 'reps': '12-15'},
    {'name': 'Romanian Deadlifts', 'muscle_group': 'Hamstrings', 'sets': '4', 'reps': '8-12'},
    {'name': 'Plank', 'muscle_group': 'Core', 'sets': '3', 'reps': 'Hold for 30-60 seconds'},
    {'name': 'Russian Twists', 'muscle_group': 'Core', 'sets': '3', 'reps': '20-30 twists'},
    {'name': 'Barbell Rows', 'muscle_group': 'Back', 'sets': '4', 'reps': '8-10'},
    {'name': 'Leg Curls', 'muscle_group': 'Legs', 'sets': '3', 'reps': '12-15'},
    {'name': 'Shoulder Lateral Raise', 'muscle_group': 'Shoulders', 'sets': '3', 'reps': '10-15'},
    {'name': 'Hammer Curls', 'muscle_group': 'Arms', 'sets': '3', 'reps': '10-12'},
    {'name': 'Goblet Squats', 'muscle_group': 'Legs', 'sets': '4', 'reps': '12-15'},
    {'name': 'Mountain Climbers', 'muscle_group': 'Core', 'sets': '3', 'reps': '30-40 per side'},
    {'name': 'Kettlebell Swings', 'muscle_group': 'Full Body', 'sets': '4', 'reps': '12-20'},
    {'name': 'Burpees', 'muscle_group': 'Full Body', 'sets': '3', 'reps': '10-15'},
    {'name': 'Chest Press Machine', 'muscle_group': 'Chest', 'sets': '4', 'reps': '8-12'},
    {'name': 'Seated Row', 'muscle_group': 'Back', 'sets': '4', 'reps': '8-12'},
    {'name': 'Hip Thrusts', 'muscle_group': 'Glutes', 'sets': '4', 'reps': '10-12'},
    {'name': 'Face Pulls', 'muscle_group': 'Shoulders', 'sets': '3', 'reps': '12-15'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Browse Workouts',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: exercises.isEmpty
            ? Center(
                child: Text(
                  'No exercises available.',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        exercise['name']!,
                        style: TextStyle(color: Colors.deepPurple, fontSize: 18),
                      ),
                      subtitle: Text(
                        'Muscle Group: ${exercise['muscle_group']}',
                        style: TextStyle(color: Colors.blue),
                      ),
                      trailing: Text(
                        'Sets: ${exercise['sets']} Reps: ${exercise['reps']}',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        // Optionally, add more functionality here to show more details if needed
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ScreenThree extends StatefulWidget {
  @override
  _ScreenThreeState createState() => _ScreenThreeState();
}
class _ScreenThreeState extends State<ScreenThree> {
  // Mock workout history data
  final List<Map<String, dynamic>> workoutHistory = [
    {
      'id': '1',
      'name': 'Morning Chest Workout',
      'muscle_group': 'Chest',
      'sets': 4,
      'reps': 12,
      'date': '2024-03-15'
    },
    {
      'id': '2',
      'name': 'Leg Day',
      'muscle_group': 'Legs',
      'sets': 5,
      'reps': 15,
      'date': '2024-03-17'
    },
    {
      'id': '3',
      'name': 'Back & Biceps',
      'muscle_group': 'Back',
      'sets': 4,
      'reps': 10,
      'date': '2024-03-18'
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  // Delete a workout (mock implementation)
  void _deleteWorkout(String id) {
    setState(() {
      workoutHistory.removeWhere((workout) => workout['id'] == id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Workout deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Workout History',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: workoutHistory.isEmpty
            ? Center(
                child: Text(
                  'No workout history available.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: workoutHistory.length,
                itemBuilder: (context, index) {
                  final workout = workoutHistory[index];
                  
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        workout['name'] ?? 'No Name',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Muscle Group: ${workout['muscle_group'] ?? 'Not specified'}',
                        style: TextStyle(color: Colors.blue),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sets: ${workout['sets'] ?? 0} Reps: ${workout['reps'] ?? 0}',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteWorkout(workout['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ScreenFour extends StatefulWidget {
  @override
  _ScreenFourState createState() => _ScreenFourState();
}

class _ScreenFourState extends State<ScreenFour> {
  String _username = 'User';
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await _authService.getUsername();
    if (username != null && mounted) {
      setState(() {
        _username = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile & Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.deepPurple,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage('assets/IMG_6510.png'),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _username,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Gym Member since 2024',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              Card(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 15),
                      ListTile(
                        title: Text('Edit Username'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Create a text controller with current username
                          final TextEditingController editController = 
                              TextEditingController(text: _username);
                          
                          // Show dialog to edit username
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Edit Username'),
                              content: TextField(
                                controller: editController,
                                decoration: InputDecoration(
                                  hintText: 'Enter new username',
                                ),
                                autofocus: true,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final newUsername = editController.text.trim();
                                    
                                    // Check if username is not empty
                                    if (newUsername.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Username cannot be empty'))
                                      );
                                      return;
                                    }
                                    
                                    // Check if username is the same
                                    if (newUsername == _username) {
                                      Navigator.pop(context);
                                      return;
                                    }
                                    
                                    // Check if username already exists (for new registrations)
                                    if (newUsername != 'Alex' && await _authService.usernameExists(newUsername)) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Username already exists'))
                                      );
                                      return;
                                    }
                                    
                                    // Save the new username
                                    await _authService.updateUsername(newUsername);
                                    
                                    // For debugging, print all credentials
                                    final credentials = await _authService.getAllCredentials();
                                    print('Current credentials: $credentials');
                                    
                                    // Update the state with new username
                                    setState(() {
                                      _username = newUsername;
                                    });
                                    
                                    // Close dialog
                                    Navigator.pop(context);
                                    
                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Username updated successfully! You will need to login with this new username next time.'))
                                    );
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('App Theme'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Theme settings
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Notifications'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Notification settings
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Logout'),
                        trailing: Icon(Icons.logout, color: Colors.red),
                        onTap: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _authService.logout();
                                    Navigator.pop(context); // Close dialog
                                    // Use pushNamedAndRemoveUntil to clear the navigation stack
                                    Navigator.pushNamedAndRemoveUntil(
                                      context, 
                                      '/', 
                                      (route) => false, // This removes all previous routes
                                    );
                                  },
                                  child: Text('Logout', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
