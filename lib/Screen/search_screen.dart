// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:to_do_app/Screen/update_contact_screen.dart';
import '../Models/contact.dart';
import 'contact_list_screen.dart';

class SearchScreen extends StatelessWidget {
  final List<Contact> originalContacts;
  final List<Contact> searchResults;

  SearchScreen({required this.originalContacts, required this.searchResults});

  void _onContactSelected(BuildContext context, Contact selectedContact) {
    if (originalContacts.contains(selectedContact)) {
      // The selected contact is in the original contact list, navigate back to the contact list
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ContactListScreen(),
        ),
      );
    } else {
      // The selected contact is in the search results, navigate to the edit screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateContactScreen(contact: selectedContact),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final contact = searchResults[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            onTap: () {
              _onContactSelected(context, contact);
            },
          );
        },
      ),
    );
  }
}
