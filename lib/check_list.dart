import 'dart:async';
import 'dart:convert';

import 'package:check_up/create_new_person_view.dart';
import 'package:check_up/edit_person_view.dart';
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

  late DateTime now = DateTime.now();
  late Timer everySecond;

  @override
  void initState() {
    everySecond = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Up'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: createNewPerson,
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
              Duration dif = now.difference(person.lastCheckIn);
              //TODO Maybe extract this into StatelessWidget, passing in the person and a callback
              return Dismissible(
                key: Key(people[index].name),
                onDismissed: (direction) {
                  setState(() {
                    removePersonAt(index);
                  });
                },
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                child: InkWell(
                  onTap: () => editPerson(person),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(people[index].name),
                        const SizedBox(width: 10),
                        if (people[index].isFavorite) const Icon(Icons.favorite, size: 20),
                      ],
                    ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }

  createNewPerson() async {
    Person? newPerson = await Navigator.push(
      context,
      MaterialPageRoute<Person>(
        builder: (context) => CreateNewPersonView(peopleNames: peopleNames()),
      ),
    );

    if (!mounted) return;
    if (newPerson == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${newPerson.name} added!')),
    );
    setState(() {
      addPerson(newPerson);
    });
  }

  editPerson(Person person) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPersonView(person: person, peopleNames: peopleNames())),
    );
    setState(() {
      sortPeople();
    });
    savePeople();
  }

  removePersonAt(int index) {
    people.removeAt(index);
    savePeople();
  }

  addPerson(Person newPerson) {
    people.add(newPerson);
    savePeople();
  }

  sortPeople() {
    people.sort((a, b) {
      if (a.isFavorite == b.isFavorite) {
        return a.lastCheckIn.compareTo(b.lastCheckIn);
      }
      if (b.isFavorite) {
        return 1;
      }
      return -1;
    });
  }

  List<String> peopleNames() {
    return people.map((e) => e.name).toList();
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
    try {
      people = jsonData.map((e) => Person.fromMap(jsonDecode(e))).toList();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error loading people!")));
    }
  }
}
