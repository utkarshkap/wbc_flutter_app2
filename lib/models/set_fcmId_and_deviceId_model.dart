import 'dart:convert';

SetFcmIdAndDeviceIdModel setFcmIdAndDeviceIdModelFromJson(String str) =>
    SetFcmIdAndDeviceIdModel.fromJson(json.decode(str));

String setFcmIdAndDeviceIdModelToJson(SetFcmIdAndDeviceIdModel data) =>
    json.encode(data.toJson());

class SetFcmIdAndDeviceIdModel {
  final String userId;
  final String deviceid;
  final String fcmId;

  SetFcmIdAndDeviceIdModel({
    required this.userId,
    required this.deviceid,
    required this.fcmId,
  });

  factory SetFcmIdAndDeviceIdModel.fromJson(Map<String, dynamic> json) =>
      SetFcmIdAndDeviceIdModel(
        userId: json["userId"],
        deviceid: json["deviceid"],
        fcmId: json["fcmId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "deviceid": deviceid,
        "fcmId": fcmId,
      };
}
