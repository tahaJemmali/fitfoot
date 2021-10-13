import 'package:flutter/material.dart';
import '../../services/contactservice.dart';
import '../../Models/contact.dart';

class NewContactForm extends StatefulWidget {
  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _number;
  ContactService cs = new ContactService();

  void addContact(Contact contact) {
    print('Hello, World!');
    print(contact.name);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (value) => _name = value,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => _number = value,
                ),
              ),
            ],
          ),
          ElevatedButton(
            child: Text('Add New Contact'),
            onPressed: () {
              _formKey.currentState.save();
              final newContact =
                  Contact(_name, _number, "friend", "1"); //change me
              cs.addNewContact(newContact);
            },
          ),
        ],
      ),
    );
  }
}
