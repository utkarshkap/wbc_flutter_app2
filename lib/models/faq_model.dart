import 'dart:convert';

Faq faqFromJson(String str) => Faq.fromJson(json.decode(str));

String faqToJson(Faq data) => json.encode(data.toJson());

class Faq {
  Faq({
    required this.code,
    required this.message,
    required this.questions,
  });

  int code;
  String message;
  List<Question> questions;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    code: json["code"],
    message: json["message"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Question {
  Question({
    required this.id,
    required this.question,
    required this.answer,
    required this.isactive,
    required this.createdDate,
  });

  int id;
  String question;
  String answer;
  bool isactive;
  DateTime createdDate;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    isactive: json["isactive"],
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "isactive": isactive,
    "createdDate": createdDate.toIso8601String(),
  };
}
