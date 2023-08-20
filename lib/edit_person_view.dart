import 'package:check_up/person.dart';
import 'package:flutter/material.dart';

class EditPersonView extends StatefulWidget {
  const EditPersonView({super.key, required this.person, required this.peopleNames});

  final Person person;
  final List<String> peopleNames;

  @override
  State<EditPersonView> createState() => _EditPersonViewState();
}

class _EditPersonViewState extends State<EditPersonView> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  late final String initialName;

  @override
  void initState() {
    initialName = widget.person.name;
    nameController.text = initialName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.person.name}"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.person.toggleFavorite();
              });
            },
            icon: Icon(
              widget.person.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            splashRadius: 20,
          ),
        ],
      ),
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
                      if (value != initialName && widget.peopleNames.contains(value.trim())) {
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
