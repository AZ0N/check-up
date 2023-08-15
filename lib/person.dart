class Person {
  String name;
  DateTime lastCheckIn;

  Person({required this.name, required this.lastCheckIn});

  factory Person.fromMap(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      lastCheckIn: DateTime.parse(json['lastCheckIn']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "lastCheckIn": lastCheckIn.toIso8601String(),
    };
  }
}
