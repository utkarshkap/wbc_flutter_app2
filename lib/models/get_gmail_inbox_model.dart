import 'dart:convert';

GetGmailInboxModel getGmailInboxFromJson(String str) => GetGmailInboxModel.fromJson(json.decode(str));

String getGmailInboxToJson(GetGmailInboxModel data) => json.encode(data.toJson());

class GetGmailInboxModel {
  List<Messages>? messages;
  String? nextPageToken;
  int? resultSizeEstimate;

  GetGmailInboxModel({this.messages, this.nextPageToken, this.resultSizeEstimate});

  GetGmailInboxModel.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    nextPageToken = json['nextPageToken'];
    resultSizeEstimate = json['resultSizeEstimate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['nextPageToken'] = this.nextPageToken;
    data['resultSizeEstimate'] = this.resultSizeEstimate;
    return data;
  }
}

class Messages {
  String? id;
  String? threadId;

  Messages({this.id, this.threadId});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    threadId = json['threadId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['threadId'] = this.threadId;
    return data;
  }
}
