import 'package:check_up/person.dart';
import 'package:flutter/material.dart';

class EditPersonView extends StatefulWidget {
  const EditPersonView({super.key, required this.person});

  final Person person;

  @override
  State<EditPersonView> createState() => _EditPersonViewState();
}

class _EditPersonViewState extends State<EditPersonView> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.person.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit ${widget.person.name}")),
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
                      // TODO Handle duplicate
                      // if (widget.peopleNames.contains(value.trim())) {
                      //   return 'This person already exists!';
                      // }
                      return null;
                    },
                  ),
                  //TODO isFavourite toggle
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      widget.person.name = nameController.text;
                      Navigator.pop(context);
                    },
                    label: const Text('Save'),
                    icon: const Icon(Icons.save),
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
