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
  final String fcmId;
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
      required this.fcmId,
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

class DeleteUserAccount extends SigningEvent {
  final String mobileNo;

  DeleteUserAccount({required this.mobileNo});
}

class GetPendingDeleteUser extends SigningEvent {
  final String mobileNo;

  GetPendingDeleteUser({required this.mobileNo});
}

class SetFcmIdAndDeviceIdData extends SigningEvent {
  final String userId;
  final String deviceid;
  final String fcmId;

  SetFcmIdAndDeviceIdData(
      {required this.userId, required this.deviceid, required this.fcmId});
}
