// lib/screens/contact_list_screen.dart

import 'package:flutter/material.dart';
import '../Models/contact.dart';
import '../utils/contact_database.dart';
import 'add_contact_screen.dart';
import 'update_contact_screen.dart';
import 'search_screen.dart';

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

  void _filterContacts(String query) {
    List<Contact> filteredResults = contacts
        .where((contact) =>
    contact.name.toLowerCase().contains(query.toLowerCase()) ||
        contact.phoneNumber.contains(query))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(originalContacts: contacts, searchResults: filteredResults),
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
      }
    });
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
              showSearch(
                context: context,
                delegate: ContactSearchDelegate(contacts),
              );
            },
          ),
        ],
      ),
      body: Container(
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
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3.0,
                      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        leading: Icon(Icons.person),
                        title: Text(
                          contacts[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            decoration: contacts[index].isFavorite
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                        subtitle: Text(contacts[index].phoneNumber),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _navigateToUpdateScreen(context, contacts[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.star),
                              color: contacts[index].isFavorite
                                  ? Colors.yellow
                                  : Colors.grey,
                              onPressed: () {
                                setState(() {
                                  contacts[index].isFavorite =
                                  !contacts[index].isFavorite;
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
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
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

class ContactSearchDelegate extends SearchDelegate {
  final List<Contact> contacts;

  ContactSearchDelegate(this.contacts);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    List<Contact> filteredResults = contacts
        .where((contact) =>
    contact.name.toLowerCase().contains(query.toLowerCase()) ||
        contact.phoneNumber.contains(query))
        .toList();

    return ListView.builder(
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final contact = filteredResults[index];
        return ListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phoneNumber),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateContactScreen(contact: contact),
              ),
            );
          },
        );
      },
    );
  }
}
