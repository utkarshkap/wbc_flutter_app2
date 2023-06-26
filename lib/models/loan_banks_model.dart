import 'dart:convert';

List<LoanBanks> loanBanksFromJson(String str) => List<LoanBanks>.from(json.decode(str).map((x) => LoanBanks.fromJson(x)));

String loanBanksToJson(List<LoanBanks> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoanBanks {
  LoanBanks({
    required this.bankid,
    required this.bankname,
  });

  int bankid;
  String bankname;

  factory LoanBanks.fromJson(Map<String, dynamic> json) => LoanBanks(
    bankid: json["bankid"],
    bankname: json["bankname"],
  );

  Map<String, dynamic> toJson() => {
    "bankid": bankid,
    "bankname": bankname,
  };

  @override
  String toString() {
    return 'LoanBanks{bankid: $bankid, bankname: $bankname}';
  }
}
