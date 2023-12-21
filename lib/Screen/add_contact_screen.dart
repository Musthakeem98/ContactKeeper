// lib/screens/add_contact_screen.dart

import 'package:flutter/material.dart';
import '../Models/contact.dart';
import '../utils/contact_database.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _saveContact();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveContact() async {
    final name = _nameController.text;
    final phoneNumber = _phoneNumberController.text;

    if (name.isNotEmpty && phoneNumber.isNotEmpty) {
      final newContact = Contact(name: name, phoneNumber: phoneNumber);
      await ContactDatabase.instance.insert(newContact);
      Navigator.pop(context, true); // Return true to indicate a successful addition
    } else {
      // Show an error message or handle validation
      // You can also use a Form widget for more structured validation
    }
  }
}
