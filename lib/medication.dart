class Medication {
  final String id;
  final String name;
  final String dosage;
  final DateTime time;
  final String userId;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time.toIso8601String(),
      'userId': userId,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json, [String? docId]) {
    return Medication(
      id: docId ?? json['\$id'] ?? '',
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      time:
          json['time'] != null ? DateTime.parse(json['time']) : DateTime.now(),
      userId: json['userId'] ?? '',
    );
  }
}
