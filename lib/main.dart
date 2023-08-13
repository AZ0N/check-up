// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check Up',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Check Up'),
          actions: [
            IconButton(
              onPressed: () {
                //TODO Add new person
              },
              icon: Icon(Icons.add),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
