import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:wbc_connect_app/models/getuser_model.dart';

class ContactsData {
  final Contact contact;
  bool isAdd;
  final Color color;

  ContactsData(
      {required this.contact, required this.isAdd, required this.color});
}

class MyContactData {
  final GoldReferral contact;
  bool isAdd;
  final Color color;

  MyContactData(
      {required this.contact, required this.isAdd, required this.color});


}
