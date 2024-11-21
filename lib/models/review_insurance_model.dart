import 'dart:convert';

InsuranceReview insuranceReviewFromJson(String str) =>
    InsuranceReview.fromJson(json.decode(str));

String insuranceReviewToJson(InsuranceReview data) =>
    json.encode(data.toJson());

class InsuranceReview {
  InsuranceReview({
    required this.userid,
    required this.mobile,
    required this.company,
    required this.insurancetype,
    required this.insuranceamount,
    required this.premium,
    required this.premiumterm,
    required this.renewaldate,
    required this.premiumPayingDate,
    required this.premiumPayingFrequency,
  });

  int userid;
  String mobile;
  String company;
  int insurancetype;
  int insuranceamount;
  double premium;
  int premiumterm;
  String renewaldate;
  String premiumPayingDate;
  String premiumPayingFrequency;

  factory InsuranceReview.fromJson(Map<String, dynamic> json) =>
      InsuranceReview(
        userid: json["userid"],
        mobile: json["mobile"],
        company: json["company"],
        insurancetype: json["insurancetype"],
        insuranceamount: json["insuranceamount"],
        premium: json["premium"],
        premiumterm: json["premiumterm"],
        renewaldate: json['renewaldate'],
        premiumPayingDate: json['premiumPayingDate'],
        premiumPayingFrequency: json['premiumPayingFrequency'],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "mobile": mobile,
        "company": company,
        "insurancetype": insurancetype,
        "insuranceamount": insuranceamount,
        "premium": premium,
        "premiumterm": premiumterm,
        "renewaldate": renewaldate,
        "premiumPayingDate": premiumPayingDate,
        "premiumPayingFrequency": premiumPayingFrequency,
      };

  @override
  String toString() {
    return 'InsuranceReview{userid: $userid, mobile: $mobile, company: $company, insurancetype: $insurancetype, insuranceamount: $insuranceamount, premium: $premium, premiumterm: $premiumterm, renewaldate: $renewaldate, premiumPayingDate: $premiumPayingDate, premiumPayingFrequency: $premiumPayingFrequency}';
  }
}
