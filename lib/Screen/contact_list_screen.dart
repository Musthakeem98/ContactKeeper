// lib/screens/contact_list_screen.dart

import 'package:flutter/material.dart';
import '../Models/contact.dart';
import '../utils/contact_database.dart';
import 'add_contact_screen.dart';
import 'update_contact_screen.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    contacts = await ContactDatabase.instance.getAllContacts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: contacts.isEmpty
          ? Center(
        child: Text(
          'No contacts available',
          style: TextStyle(fontSize: 18.0),
        ),
      )
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                contacts[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  decoration: contacts[index].isFavorite ? TextDecoration.underline : null,
                ),
              ),
              subtitle: Text(contacts[index].phoneNumber),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.star),
                    color: contacts[index].isFavorite ? Colors.yellow : Colors.grey,
                    onPressed: () {
                      setState(() {
                        contacts[index].isFavorite = !contacts[index].isFavorite;
                      });
                      _updateContact(contacts[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteContactDialog(context, contacts[index]);
                    },
                  ),
                ],
              ),
              onTap: () {
                _navigateToUpdateScreen(context, contacts[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _updateContact(Contact contact) async {
    await ContactDatabase.instance.update(contact);
    _loadContacts();
  }

  Future<void> _deleteContactDialog(BuildContext context, Contact contact) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete ${contact.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ContactDatabase.instance.delete(contact.id);
                Navigator.of(context).pop();
                _loadContacts();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContactScreen()),
    ).then((value) {
      if (value == true) {
        _loadContacts();
      }
    });
  }

  void _navigateToUpdateScreen(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateContactScreen(contact: contact)),
    ).then((value) {
      if (value == true) {
        _loadContacts();
      }
    });
  }
}
