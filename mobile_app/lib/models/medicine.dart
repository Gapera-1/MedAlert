class Medicine {
  final int id;
  final String name;
  final List<String> times;
  final String posology;
  final int duration;
  final String startDate;
  final Map<String, bool> takenTimes;
  final Map<String, dynamic> lastNotified;
  final bool completed;

  Medicine({
    required this.id,
    required this.name,
    required this.times,
    required this.posology,
    required this.duration,
    required this.startDate,
    required this.takenTimes,
    required this.lastNotified,
    required this.completed,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      times: List<String>.from(json['times']),
      posology: json['posology'],
      duration: json['duration'],
      startDate: json['start_date'] ?? DateTime.now().toIso8601String().split('T')[0],
      takenTimes: json['taken_times'] != null
          ? Map<String, bool>.from(
              (json['taken_times'] as Map).map(
                (key, value) => MapEntry(key.toString(), value as bool),
              ),
            )
          : {},
      lastNotified: json['last_notified'] ?? {},
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'times': times,
      'posology': posology,
      'duration': duration,
      'start_date': startDate,
      'taken_times': takenTimes,
      'last_notified': lastNotified,
      'completed': completed,
    };
  }

  Medicine copyWith({
    int? id,
    String? name,
    List<String>? times,
    String? posology,
    int? duration,
    String? startDate,
    Map<String, bool>? takenTimes,
    Map<String, dynamic>? lastNotified,
    bool? completed,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      times: times ?? this.times,
      posology: posology ?? this.posology,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      takenTimes: takenTimes ?? this.takenTimes,
      lastNotified: lastNotified ?? this.lastNotified,
      completed: completed ?? this.completed,
    );
  }
}

