import 'dart:convert';

FamilyMemberModel familyMemberModelFromJson(String str) =>
    FamilyMemberModel.fromJson(json.decode(str));

String familyMemberModelToJson(FamilyMemberModel data) =>
    json.encode(data.toJson());

class FamilyMemberModel {
  FamilyMemberModel({
    required this.userid,
    required this.name,
    required this.mobileNo,
    required this.relation,
  });

  final int userid;
  final String name;
  final String mobileNo;
  final String relation;

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) =>
      FamilyMemberModel(
        userid: json["userid"],
        name: json["name"],
        mobileNo: json["mobileNo"],
        relation: json["relation"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "name": name,
        "mobileNo": mobileNo,
        "relation": relation,
      };

  @override
  String toString() {
    return 'FamilyMemberModel{userid: $userid, name: $name, mobileNo: $mobileNo, relation: $relation}';
  }
}
