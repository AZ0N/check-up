import 'package:check_up/person.dart';
import 'package:flutter/material.dart';

class CreateNewPersonView extends StatefulWidget {
  const CreateNewPersonView({super.key, required this.peopleNames});

  final List<String> peopleNames;

  @override
  State<CreateNewPersonView> createState() => _CreateNewPersonViewState();
}

class _CreateNewPersonViewState extends State<CreateNewPersonView> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration: const InputDecoration(hintText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a name!';
                      }
                      if (value.length > 24) {
                        return 'Name is too long!';
                      }
                      if (widget.peopleNames.contains(value.trim())) {
                        return 'This person already exists!';
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
                        name: nameController.text.trim(),
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
    );
  }
}
