import 'dart:convert';

UpdateFastTrackModel updateFastTrackModelFromJson(String str) =>
    UpdateFastTrackModel.fromJson(json.decode(str));

String updateFastTrackModelToJson(UpdateFastTrackModel data) =>
    json.encode(data.toJson());

class UpdateFastTrackModel {
  UpdateFastTrackModel({
    required this.userid,
    required this.mobile,
    required this.date,
    required this.amount,
  });

  final int userid;
  final String mobile;
  final String date;
  final String amount;

  factory UpdateFastTrackModel.fromJson(Map<String, dynamic> json) =>
      UpdateFastTrackModel(
        userid: json["userId"],
        mobile: json["mobile"],
        date: json["date"],
        amount: json["paymentAmount"],
      );

  Map<String, dynamic> toJson() => {
    "userId": userid,
    "mobile": mobile,
    "date": date,
    "paymentAmount": amount,
  };
}
