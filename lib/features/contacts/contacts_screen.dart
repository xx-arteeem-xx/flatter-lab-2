import 'package:flutter/material.dart';
import '../../models/contact.dart';
import 'widgets/contact_tile.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      itemCount: kContacts.length,
      itemBuilder: (_, index) => ContactTile(contact: kContacts[index]),
    );
  }
}
