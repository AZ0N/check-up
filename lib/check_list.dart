import 'dart:convert';

import 'package:check_up/person.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckList extends StatefulWidget {
  const CheckList({super.key});

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  List<Person> people = [];
  late Future peopleFuture = loadPeople();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Up'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //TODO Add new person
            },
            icon: const Icon(Icons.add),
            splashRadius: 20,
          ),
        ],
      ),
      body: FutureBuilder(
        future: peopleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              Person person = people[index];
              Duration dif = DateTime.now().difference(person.lastCheckIn);
              return ListTile(
                title: Text(people[index].name),
                subtitle: Text(formatDuration(dif)),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      people[index].lastCheckIn = DateTime.now();
                    });
                    savePeople();
                  },
                  icon: const Icon(Icons.access_time),
                ),
              );
            },
          );
        },
      ),
    );
  }

  savePeople() async {
    var prefs = await SharedPreferences.getInstance();
    // Map each person to a JSON encoded map
    List<String> jsonList = people.map((e) => jsonEncode(e.toMap())).toList();
    prefs.setStringList('data', jsonList);
  }

  loadPeople() async {
    var prefs = await SharedPreferences.getInstance();
    var jsonData = prefs.getStringList('data');
    // If the data is null, it means we haven't saved any data yet,
    // and therefore doesn't have any people saved
    if (jsonData == null) {
      people = [];
      return;
    }
    //TODO Maybe wrap this in try/catch and display error message if there were errors in decoding the saved data
    people = jsonData.map((e) => Person.fromMap(jsonDecode(e))).toList();
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
