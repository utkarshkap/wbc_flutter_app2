import 'dart:convert';

MGainLedger mGainLedgerFromJson(String str) => MGainLedger.fromJson(json.decode(str));

String mGainLedgerToJson(MGainLedger data) => json.encode(data.toJson());

class MGainLedger {
  MGainLedger({
    required this.code,
    required this.message,
    required this.ledgerEntries,
  });

  int code;
  String message;
  List<LedgerEntry> ledgerEntries;

  factory MGainLedger.fromJson(Map<String, dynamic> json) => MGainLedger(
    code: json["code"],
    message: json["message"],
    ledgerEntries: List<LedgerEntry>.from(json["ledgerEntries"].map((x) => LedgerEntry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "ledgerEntries": List<dynamic>.from(ledgerEntries.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'MGainLedger{code: $code, message: $message, ledgerEntries: $ledgerEntries}';
  }
}

class LedgerEntry {
  LedgerEntry({
    required this.ledgerId,
    required this.mgainId,
    required this.name,
    required this.investmentDate,
    required this.debit,
    required this.credit,
    required this.isdeleted,
  });

  int ledgerId;
  int mgainId;
  String name;
  DateTime investmentDate;
  num debit;
  num credit;
  bool isdeleted;

  factory LedgerEntry.fromJson(Map<String, dynamic> json) => LedgerEntry(
    ledgerId: json["ledgerId"],
    mgainId: json["mgainId"],
    name: json["name"],
    investmentDate: DateTime.parse(json["investmentDate"]),
    debit: json["debit"],
    credit: json["credit"],
    isdeleted: json["isdeleted"],
  );

  Map<String, dynamic> toJson() => {
    "ledgerId": ledgerId,
    "mgainId": mgainId,
    "name": name,
    "investmentDate": investmentDate.toIso8601String(),
    "debit": debit,
    "credit": credit,
    "isdeleted": isdeleted,
  };

  @override
  String toString() {
    return 'LedgerEntry{ledgerId: $ledgerId, mgainId: $mgainId, name: $name, investmentDate: $investmentDate, debit: $debit, credit: $credit, isdeleted: $isdeleted}';
  }
}
