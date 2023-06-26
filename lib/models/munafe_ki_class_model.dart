import 'package:meta/meta.dart';
import 'dart:convert';

MunafeKiClass munafeKiClassFromJson(String str) => MunafeKiClass.fromJson(json.decode(str));

String munafeKiClassToJson(MunafeKiClass data) => json.encode(data.toJson());

class MunafeKiClass {
  MunafeKiClass({
    required this.code,
    required this.message,
    required this.list,
  });

  int code;
  String message;
  List<ListElement> list;

  factory MunafeKiClass.fromJson(Map<String, dynamic> json) => MunafeKiClass(
    code: json["code"],
    message: json["message"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'MunafeKiClass{code: $code, message: $message, list: $list}';
  }
}

class ListElement {
  ListElement({
    required this.id,
    required this.title,
    required this.description,
    required this.video,
    required this.isactive,
    required this.entryDate,
  });

  int id;
  String title;
  String description;
  String video;
  bool isactive;
  DateTime entryDate;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    video: json["video"],
    isactive: json["isactive"],
    entryDate: DateTime.parse(json["entryDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "video": video,
    "isactive": isactive,
    "entryDate": entryDate.toIso8601String(),
  };

  @override
  String toString() {
    return 'ListElement{id: $id, title: $title, description: $description, video: $video, isactive: $isactive, entryDate: $entryDate}';
  }
}
