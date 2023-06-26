import 'dart:convert';

List<InsuranceCategory> insuranceCategoryFromJson(String str) => List<InsuranceCategory>.from(json.decode(str).map((x) => InsuranceCategory.fromJson(x)));

String insuranceCategoryToJson(List<InsuranceCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InsuranceCategory {
  InsuranceCategory({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory InsuranceCategory.fromJson(Map<String, dynamic> json) => InsuranceCategory(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  String toString() {
    return 'InsuranceCategory{id: $id, name: $name}';
  }
}