import 'dart:convert';

import 'package:check_up/create_new_person.dart';
import 'package:check_up/person.dart';
import 'package:check_up/util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckList extends StatefulWidget {
  const CheckList({super.key});

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  //TODO Sorting mode
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
              setState(() {
                people[0].lastCheckIn =
                    DateTime.now().add(const Duration(days: -10));
                people[1].lastCheckIn =
                    DateTime.now().add(const Duration(days: -365 - 7 - 2));
                people[2].lastCheckIn =
                    DateTime.now().add(const Duration(days: -2, hours: -5));
                sortPeople();
              });
            },
            icon: const Icon(Icons.manage_accounts_outlined),
            splashRadius: 20,
          ),
          IconButton(
            //TODO Extract method
            onPressed: () async {
              var newPerson = await Navigator.push(
                context,
                MaterialPageRoute<Person>(
                  builder: (context) => CreateNewPerson(
                      peopleNames: people.map((e) => e.name).toList()),
                ),
              );

              if (!mounted) return;
              if (newPerson == null) return;

              //TODO Maybe show SnackBar to show the person has been added
              setState(() {
                people.add(newPerson);
                sortPeople();
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
              //TODO Maybe extract this into StatelessWidget, passing in the person and a callback
              return GestureDetector(
                onLongPress: () {
                  //TODO Maybe create context menu, with options to delete the person and manually set lastCheckIn
                  //TODO Create "Are you sure?"-menu
                  setState(() {
                    people.removeAt(index);
                    sortPeople();
                  });
                  savePeople();
                },
                child: ListTile(
                  title: Text(people[index].name),
                  subtitle: Text(Util.formatDuration(dif)),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        people[index].lastCheckIn = DateTime.now();
                        sortPeople();
                      });
                      savePeople();
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  sortPeople() {
    people.sort((a, b) => a.lastCheckIn.compareTo(b.lastCheckIn));
  }

  //TODO Maybe move these methods to data.dart/localData.dart for clearer separation
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
}
