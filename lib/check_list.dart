import 'package:check_up/person.dart';
import 'package:flutter/material.dart';

class CheckList extends StatelessWidget {
  const CheckList({super.key});

  // Example people
  static List<Person> people = [
    Person(name: 'Mads', lastCheckIn: DateTime.now().add(Duration(days: -1))),
    Person(name: 'Jens', lastCheckIn: DateTime.now().add(Duration(hours: -3))),
    Person(
        name: 'Jeppe', lastCheckIn: DateTime.now().add(Duration(days: -500))),
    Person(
        name: 'Bastian', lastCheckIn: DateTime.now().add(Duration(days: -10)))
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: people.length,
      itemBuilder: (context, index) {
        Person person = people[index];
        Duration difference = DateTime.now().difference(person.lastCheckIn);

        return ListTile(
          title: Text(people[index].name),
          subtitle: Text(formatDuration(difference)),
          trailing: IconButton(
            onPressed: () {
              //TODO
            },
            icon: Icon(Icons.access_time),
          ),
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    int years = duration.inDays ~/ 365;
    int weeks = (duration.inDays - years * 365) ~/ 7;
    int days = duration.inDays - weeks * 7;
    int hours = duration.inHours - (weeks * 7 + days) * 24;

    String result = "";

    if (years > 0) {
      result += "$years ${years == 1 ? "year" : "years"}, ";
    }
    if (weeks > 0) {
      result += "$weeks ${weeks == 1 ? "week" : "weeks"}, ";
    }
    if (days > 0) {
      result += "$days ${days == 1 ? "day" : "days"}, ";
    }
    result += "$hours ${hours == 1 ? "hour" : "hours"} ";

    return result;
  }
}
