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

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Up'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                people[0].lastCheckIn =
                    DateTime.now().add(const Duration(days: -10));
                people[1].lastCheckIn =
                    DateTime.now().add(const Duration(days: -365 - 7 - 2));
                people[2].lastCheckIn =
                    DateTime.now().add(const Duration(days: -2, hours: -5));
              });
            },
            icon: const Icon(Icons.manage_accounts_outlined),
            splashRadius: 20,
          ),
          IconButton(
            onPressed: () async {
              var newPerson = await Navigator.push(
                context,
                MaterialPageRoute<Person>(
                  //TODO Move this page into new file
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text('Add New Person')),
                    body: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration:
                                      const InputDecoration(hintText: 'Name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter a name!';
                                    }
                                    if (value.length > 24) {
                                      return 'Name is too long!';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    Person newPerson = Person(
                                      name: nameController.text,
                                      lastCheckIn: DateTime.now(),
                                    );
                                    Navigator.pop(context, newPerson);
                                  },
                                  label: const Text('Add Person'),
                                  icon: const Icon(Icons.add),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );

              if (!mounted) return;
              if (newPerson == null) return;

              setState(() {
                people.add(newPerson);
              });
              savePeople();
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
    int days = duration.inDays - (years * 365 + weeks * 7);
    int hours = duration.inHours - (years * 365 + weeks * 7 + days) * 24;

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
