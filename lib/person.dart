class Person {
  String name;
  DateTime lastCheckIn;
  bool isFavorite;

  Person({
    required this.name,
    required this.lastCheckIn,
    this.isFavorite = false,
  });

  factory Person.fromMap(Map<String, dynamic> json) {
    return Person(
        name: json['name'],
        lastCheckIn: DateTime.parse(json['lastCheckIn']),
        isFavorite: json['isFavorite']);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "lastCheckIn": lastCheckIn.toIso8601String(),
      "isFavorite": isFavorite
    };
  }
}
