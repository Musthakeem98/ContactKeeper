// lib/screens/update_contact_screen.dart

import 'package:flutter/material.dart';
import '../Models/contact.dart';
import '../utils/contact_database.dart';

class UpdateContactScreen extends StatefulWidget {
  final Contact contact;

  UpdateContactScreen({required this.contact});

  @override
  _UpdateContactScreenState createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _phoneNumberController = TextEditingController(text: widget.contact.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Contact'),
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
                await _updateContact();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateContact() async {
    widget.contact.name = _nameController.text;
    widget.contact.phoneNumber = _phoneNumberController.text;

    await ContactDatabase.instance.update(widget.contact);
    Navigator.pop(context, true); // Return true to indicate a successful update
  }
}
