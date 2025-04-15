import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:GYMBUDDY/firebase_options.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'auth_service.dart';
import 'register_screen.dart';
import 'theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'workout_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase Initialized Successfully');
  } catch (e) {
    print('Firebase Initialization Error: $e');
    print('Error details: ${e.toString()}');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'GymBuddy',
      theme: themeProvider.getThemeData(),
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
          gradient: Provider.of<ThemeProvider>(context).getGradientForTheme(),
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
                      backgroundImage: AssetImage('assets/PFP1.png'),
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
                  child:
                      Text('Browse Workouts', style: TextStyle(fontSize: 32)),
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

  // Save the workout data
  Future<void> _saveWorkout(BuildContext context) async {
    try {
      // Get the current workouts
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = prefs.getStringList('workouts') ?? [];

      // Create new workout
      final workout = Workout(
        name: nameController.text,
        muscleGroup: muscleGroupController.text,
        reps: int.parse(repsController.text),
        sets: int.parse(setsController.text),
        date: dateController.text,
      );

      // Convert workout to properly formatted JSON string
      final workoutJson = jsonEncode({
        'name': workout.name,
        'muscleGroup': workout.muscleGroup,
        'reps': workout.reps,
        'sets': workout.sets,
        'date': workout.date,
      });

      // Add new workout to the list
      workoutsJson.add(workoutJson);

      // Save the updated list
      await prefs.setStringList('workouts', workoutsJson);

      // Show success dialog
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
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pop(context); // Go back to the previous screen
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
    } catch (e) {
      print('Error saving workout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving workout: $e')),
      );
    }
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
          gradient: Provider.of<ThemeProvider>(context).getGradientForTheme(),
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
    {
      'name': 'Bicep Curls',
      'muscle_group': 'Arms',
      'sets': '4',
      'reps': '10-12'
    },
    {
      'name': 'Deadlifts',
      'muscle_group': 'Full Body',
      'sets': '3',
      'reps': '8-10'
    },
    {
      'name': 'Bench Press',
      'muscle_group': 'Chest',
      'sets': '4',
      'reps': '8-12'
    },
    {
      'name': 'Lunges',
      'muscle_group': 'Legs',
      'sets': '3',
      'reps': '10-12 (each leg)'
    },
    {
      'name': 'Overhead Press',
      'muscle_group': 'Shoulders',
      'sets': '4',
      'reps': '8-10'
    },
    {
      'name': 'Tricep Dips',
      'muscle_group': 'Arms',
      'sets': '3',
      'reps': '10-15'
    },
    {'name': 'Leg Press', 'muscle_group': 'Legs', 'sets': '4', 'reps': '12-15'},
    {
      'name': 'Lat Pulldown',
      'muscle_group': 'Back',
      'sets': '3',
      'reps': '8-12'
    },
    {
      'name': 'Chest Fly',
      'muscle_group': 'Chest',
      'sets': '3',
      'reps': '12-15'
    },
    {
      'name': 'Romanian Deadlifts',
      'muscle_group': 'Hamstrings',
      'sets': '4',
      'reps': '8-12'
    },
    {
      'name': 'Plank',
      'muscle_group': 'Core',
      'sets': '3',
      'reps': 'Hold for 30-60 seconds'
    },
    {
      'name': 'Russian Twists',
      'muscle_group': 'Core',
      'sets': '3',
      'reps': '20-30 twists'
    },
    {
      'name': 'Barbell Rows',
      'muscle_group': 'Back',
      'sets': '4',
      'reps': '8-10'
    },
    {'name': 'Leg Curls', 'muscle_group': 'Legs', 'sets': '3', 'reps': '12-15'},
    {
      'name': 'Shoulder Lateral Raise',
      'muscle_group': 'Shoulders',
      'sets': '3',
      'reps': '10-15'
    },
    {
      'name': 'Hammer Curls',
      'muscle_group': 'Arms',
      'sets': '3',
      'reps': '10-12'
    },
    {
      'name': 'Goblet Squats',
      'muscle_group': 'Legs',
      'sets': '4',
      'reps': '12-15'
    },
    {
      'name': 'Mountain Climbers',
      'muscle_group': 'Core',
      'sets': '3',
      'reps': '30-40 per side'
    },
    {
      'name': 'Kettlebell Swings',
      'muscle_group': 'Full Body',
      'sets': '4',
      'reps': '12-20'
    },
    {
      'name': 'Burpees',
      'muscle_group': 'Full Body',
      'sets': '3',
      'reps': '10-15'
    },
    {
      'name': 'Chest Press Machine',
      'muscle_group': 'Chest',
      'sets': '4',
      'reps': '8-12'
    },
    {'name': 'Seated Row', 'muscle_group': 'Back', 'sets': '4', 'reps': '8-12'},
    {
      'name': 'Hip Thrusts',
      'muscle_group': 'Glutes',
      'sets': '4',
      'reps': '10-12'
    },
    {
      'name': 'Face Pulls',
      'muscle_group': 'Shoulders',
      'sets': '3',
      'reps': '12-15'
    }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).getGradientForTheme(),
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
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18),
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
  List<Workout> workoutHistory = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = prefs.getStringList('workouts') ?? [];
      final List<Workout> loadedWorkouts = [];

      for (var json in workoutsJson) {
        try {
          // Clean up the JSON string if it's not properly formatted
          if (!json.startsWith('{') || !json.endsWith('}')) {
            json = json.trim();
            if (!json.startsWith('{')) json = '{' + json;
            if (!json.endsWith('}')) json = json + '}';
          }

          final Map<String, dynamic> workoutMap = jsonDecode(json);
          loadedWorkouts.add(Workout(
            name: workoutMap['name'] as String,
            muscleGroup: workoutMap['muscleGroup'] as String,
            reps: workoutMap['reps'] as int,
            sets: workoutMap['sets'] as int,
            date: workoutMap['date'] as String,
          ));
        } catch (e) {
          print('Error parsing workout: $e\nJSON: $json');
          // Skip invalid entries
          continue;
        }
      }

      setState(() {
        workoutHistory = loadedWorkouts;
      });
    } catch (e) {
      print('Error loading workouts: $e');
    }
  }

  // Delete a workout
  Future<void> _deleteWorkout(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = prefs.getStringList('workouts') ?? [];

      if (index >= 0 && index < workoutsJson.length) {
        workoutsJson.removeAt(index);
        await prefs.setStringList('workouts', workoutsJson);
        await _loadWorkouts(); // Reload the workouts

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workout deleted successfully')),
        );
      }
    } catch (e) {
      print('Error deleting workout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting workout: $e')),
      );
    }
  }

  // Add this new method to clear workout history
  Future<void> _clearWorkoutHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('workouts');
      setState(() {
        workoutHistory = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout history cleared successfully')),
      );
    } catch (e) {
      print('Error clearing workout history: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing workout history: $e')),
      );
    }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear History'),
                  content: Text(
                      'Are you sure you want to clear all workout history?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearWorkoutHistory();
                      },
                      child: Text('Clear', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).getGradientForTheme(),
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
                        workout.name,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Muscle Group: ${workout.muscleGroup}',
                        style: TextStyle(color: Colors.blue),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sets: ${workout.sets} Reps: ${workout.reps}',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteWorkout(index);
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).getGradientForTheme(),
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
                              backgroundImage: AssetImage('assets/PFP1.png'),
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
                                    final newUsername =
                                        editController.text.trim();

                                    // Check if username is not empty
                                    if (newUsername.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Username cannot be empty')));
                                      return;
                                    }

                                    // Check if username is the same
                                    if (newUsername == _username) {
                                      Navigator.pop(context);
                                      return;
                                    }

                                    // Save the new username
                                    await _authService
                                        .updateUsername(newUsername);

                                    // Update the state with new username
                                    setState(() {
                                      _username = newUsername;
                                    });

                                    // Close dialog
                                    Navigator.pop(context);

                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Username updated successfully!')));
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
                          // Show theme selection dialog
                          _showThemeSelector(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Reset Password'),
                        trailing: Icon(Icons.lock_reset, size: 16),
                        onTap: () {
                          // Show password reset dialog
                          _showResetPasswordDialog(context);
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
                                      (route) =>
                                          false, // This removes all previous routes
                                    );
                                  },
                                  child: Text('Logout',
                                      style: TextStyle(color: Colors.red)),
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

  void _showThemeSelector(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final currentTheme = themeProvider.currentTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Theme'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(context, 'Default', 'default', currentTheme),
              _buildThemeOption(context, 'Purple', 'purple', currentTheme),
              _buildThemeOption(context, 'Green', 'green', currentTheme),
              _buildThemeOption(context, 'Blue', 'blue', currentTheme),
              _buildThemeOption(context, 'Red', 'red', currentTheme),
              _buildThemeOption(context, 'Yellow', 'yellow', currentTheme),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String themeName,
      String themeKey, String currentTheme) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return ListTile(
      title: Text(themeName),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: _getPreviewGradient(themeKey),
          border: Border.all(
            color: themeKey == currentTheme ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      trailing: themeKey == currentTheme
          ? Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () async {
        await themeProvider.setTheme(themeKey);
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Theme updated successfully!')));
      },
    );
  }

  LinearGradient _getPreviewGradient(String themeKey) {
    switch (themeKey) {
      case 'purple':
        return LinearGradient(
          colors: [Colors.purple.shade300, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'green':
        return LinearGradient(
          colors: [Colors.green.shade300, Colors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'blue':
        return LinearGradient(
          colors: [Colors.blue.shade300, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'red':
        return LinearGradient(
          colors: [Colors.red.shade300, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'yellow':
        return LinearGradient(
          colors: [Colors.amber.shade300, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'default':
      default:
        return LinearGradient(
          colors: [Colors.blue.shade300, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  void _showResetPasswordDialog(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool isLoading = false;
    String errorMessage = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Reset Password'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Current Password
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),

                  // New Password
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Confirm New Password
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // Error message
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              if (isLoading)
                CircularProgressIndicator()
              else
                TextButton(
                  onPressed: () async {
                    // Validate passwords
                    if (currentPasswordController.text.isEmpty ||
                        newPasswordController.text.isEmpty ||
                        confirmPasswordController.text.isEmpty) {
                      setState(() {
                        errorMessage = 'All fields are required';
                      });
                      return;
                    }

                    if (newPasswordController.text !=
                        confirmPasswordController.text) {
                      setState(() {
                        errorMessage = 'New passwords do not match';
                      });
                      return;
                    }

                    // Show loading indicator
                    setState(() {
                      isLoading = true;
                      errorMessage = '';
                    });

                    // Update password
                    final success = await _authService.updatePassword(
                      currentPasswordController.text,
                      newPasswordController.text,
                    );

                    if (success) {
                      // Close dialog and show success message
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password updated successfully')));
                    } else {
                      // Show error
                      setState(() {
                        isLoading = false;
                        errorMessage = 'Current password is incorrect';
                      });
                    }
                  },
                  child: Text('Update'),
                ),
            ],
          );
        });
      },
    );
  }
}
