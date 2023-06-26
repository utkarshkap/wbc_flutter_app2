// To parse this JSON data, do
//
//     final addContactResponse = addContactResponseFromJson(jsonString);

import 'dart:convert';

AddContactResponse addContactResponseFromJson(String str) =>
    AddContactResponse.fromJson(json.decode(str));

String addContactResponseToJson(AddContactResponse data) =>
    json.encode(data.toJson());

class AddContactResponse {
  AddContactResponse({
    required this.code,
    required this.message,
    required this.contacts,
  });

  final int code;
  final dynamic message;
  final List<Contact> contacts;

  factory AddContactResponse.fromJson(Map<String, dynamic> json) =>
      AddContactResponse(
        code: json["code"],
        message: json["message"],
        contacts: List<Contact>.from(
            json["contacts"].map((x) => Contact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
      };
}

class Contact {
  Contact({
    required this.mobileNo,
    required this.status,
  });

  final String mobileNo;
  final String status;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        mobileNo: json["mobileNo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "mobileNo": mobileNo,
        "status": status,
      };
}
