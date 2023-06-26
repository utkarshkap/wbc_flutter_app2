import 'dart:convert';

TermsConditions termsConditionsFromJson(String str) => TermsConditions.fromJson(json.decode(str));

String termsConditionsToJson(TermsConditions data) => json.encode(data.toJson());

class TermsConditions {
  TermsConditions({
    required this.code,
    required this.message,
    required this.terms,
  });

  int code;
  String message;
  List<Term> terms;

  factory TermsConditions.fromJson(Map<String, dynamic> json) => TermsConditions(
    code: json["code"],
    message: json["message"],
    terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'TermsConditions{code: $code, message: $message, terms: $terms}';
  }
}

class Term {
  Term({
    required this.id,
    required this.title,
    required this.description,
    required this.isactive,
    required this.entryDate,
  });

  int id;
  String title;
  String description;
  bool isactive;
  DateTime entryDate;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    isactive: json["isactive"],
    entryDate: DateTime.parse(json["entryDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "isactive": isactive,
    "entryDate": entryDate.toIso8601String(),
  };

  @override
  String toString() {
    return 'Term{id: $id, title: $title, description: $description, isactive: $isactive, entryDate: $entryDate}';
  }
}
