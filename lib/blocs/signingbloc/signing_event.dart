part of 'signing_bloc.dart';

@immutable
abstract class SigningEvent {}

class CreateUser extends SigningEvent {
  final String name;
  final String mobileNo;
  final String email;
  final String? address;
  final String? area;
  final String? city;
  final String? country;
  final int? pincode;
  final String deviceId;
  final DateTime? dob;
  final bool tnc;

  CreateUser(
      {required this.name,
      required this.mobileNo,
      required this.email,
      this.address,
      this.area,
      this.city,
      this.country,
      this.pincode,
      required this.deviceId,
      this.dob,
      required this.tnc});
}

class AddContactList extends SigningEvent {
  final String mobileNo;
  final String date;
  final List<ContactData> contacts;

  AddContactList(
      {required this.mobileNo, required this.date, required this.contacts});
}

class GetUserData extends SigningEvent {
  final String mobileNo;

  GetUserData({required this.mobileNo});
}

class UserIdData extends SigningEvent {
  final String mobileNo;

  UserIdData({required this.mobileNo});
}
