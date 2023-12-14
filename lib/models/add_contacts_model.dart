import 'dart:convert';

AddContact addContactFromJson(String str) =>
    AddContact.fromJson(json.decode(str));

String addContactToJson(AddContact data) => json.encode(data.toJson());

class AddContact {
  AddContact({
    required this.mobileNo,
    required this.date,
    required this.contacts,
  });

  final String mobileNo;
  final String date;
  final List<ContactData> contacts;

  factory AddContact.fromJson(Map<String, dynamic> json) => AddContact(
        mobileNo: json["mobileNo"],
        date: json["date"],
        contacts: List<ContactData>.from(
            json["contacts"].map((x) => ContactData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mobileNo": mobileNo,
        "date": date,
        "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
      };
}

class ContactData {
  ContactData({
    required this.name,
    required this.mobileNo,
    this.nriRefferal,
    this.country,
  });

  @override
  String toString() {
    return 'ContactData{name: $name, mobileNo: $mobileNo, nrI_refferal: $nriRefferal, country: $country }';
  }

  final String name;
  final String mobileNo;
  final bool? nriRefferal;
  final String? country;

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
        name: json["name"],
        mobileNo: json["mobileNo"],
        nriRefferal: json["nrI_refferal"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobileNo": mobileNo,
        "nrI_refferal": nriRefferal,
        "country": country,
      };
}
