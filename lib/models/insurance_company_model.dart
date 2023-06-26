import 'dart:convert';

List<InsuranceCompany> insuranceCompanyFromJson(String str) => List<InsuranceCompany>.from(json.decode(str).map((x) => InsuranceCompany.fromJson(x)));

String insuranceCompanyToJson(List<InsuranceCompany> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InsuranceCompany {
  InsuranceCompany({
    required this.insuranceCompanyid,
    required this.insuranceCompanytypeid,
    required this.insuranceCompanyname,
  });

  int insuranceCompanyid;
  int insuranceCompanytypeid;
  String insuranceCompanyname;

  factory InsuranceCompany.fromJson(Map<String, dynamic> json) => InsuranceCompany(
    insuranceCompanyid: json["insurance_companyid"],
    insuranceCompanytypeid: json["insurance_companytypeid"],
    insuranceCompanyname: json["insurance_companyname"],
  );

  Map<String, dynamic> toJson() => {
    "insurance_companyid": insuranceCompanyid,
    "insurance_companytypeid": insuranceCompanytypeid,
    "insurance_companyname": insuranceCompanyname,
  };

  @override
  String toString() {
    return 'InsuranceCompany{insuranceCompanyid: $insuranceCompanyid, insuranceCompanytypeid: $insuranceCompanytypeid, insuranceCompanyname: $insuranceCompanyname}';
  }
}
