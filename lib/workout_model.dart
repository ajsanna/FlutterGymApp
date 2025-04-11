class Workout {
  final String name;
  final String muscleGroup;
  final int reps;
  final int sets;
  final String date;

  Workout({
    required this.name,
    required this.muscleGroup,
    required this.reps,
    required this.sets,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'muscleGroup': muscleGroup,
      'reps': reps,
      'sets': sets,
      'date': date,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'],
      muscleGroup: json['muscleGroup'],
      reps: json['reps'],
      sets: json['sets'],
      date: json['date'],
    );
  }
}
