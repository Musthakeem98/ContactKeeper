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
  List<Contact> filteredContacts = [];

  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    contacts = await ContactDatabase.instance.getAllContacts();
    setState(() {
      filteredContacts = contacts;
    });
  }

  void _updateContact(Contact contact) async {
    await ContactDatabase.instance.update(contact);
    _loadContacts();
    _showSnackBar('Contact updated successfully');
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
                _showSnackBar('Contact deleted successfully');
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
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

  void _navigateToAddScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContactScreen()),
    ).then((value) {
      if (value == true) {
        _loadContacts();
        _showSnackBar('Contact added successfully');
      }
    });
  }

  void _searchContacts(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) =>
      contact.name.toLowerCase().contains(query.toLowerCase()) ||
          contact.phoneNumber.contains(query))
          .toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      isSearching = false;
      _loadContacts();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _loadContacts();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchContacts,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: _clearSearch,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              color: Colors.blueGrey[50],
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: constraints.maxHeight < MediaQuery.of(context).size.height
                        ? AlwaysScrollableScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3.0,
                            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              leading: Icon(Icons.person),
                              title: Text(
                                filteredContacts[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  decoration: filteredContacts[index].isFavorite
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                              subtitle: Text(filteredContacts[index].phoneNumber),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _navigateToUpdateScreen(context, filteredContacts[index]);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.star),
                                    color: filteredContacts[index].isFavorite
                                        ? Colors.yellow
                                        : Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        filteredContacts[index].isFavorite =
                                        !filteredContacts[index].isFavorite;
                                      });
                                      _updateContact(filteredContacts[index]);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteContactDialog(context, filteredContacts[index]);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
