import 'dart:convert';

MGainInvestment mGainInvestmentFromJson(String str) =>
    MGainInvestment.fromJson(json.decode(str));

String mGainInvestmentToJson(MGainInvestment data) =>
    json.encode(data.toJson());

class MGainInvestment {
  MGainInvestment({
    required this.code,
    required this.message,
    required this.mGainTotalInvestment,
    required this.totalIntrestReceived,
    required this.mGains,
  });

  int code;
  String message;
  num mGainTotalInvestment;
  num totalIntrestReceived;
  List<MGain> mGains;

  factory MGainInvestment.fromJson(Map<String, dynamic> json) =>
      MGainInvestment(
        code: json["code"],
        message: json["message"],
        mGainTotalInvestment: json["mGain_total_Investment"],
        totalIntrestReceived: json["total_Intrest_received"],
        mGains: List<MGain>.from(json["mGains"].map((x) => MGain.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "mGain_total_Investment": mGainTotalInvestment,
        "total_Intrest_received": totalIntrestReceived,
        "mGains": List<dynamic>.from(mGains.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'MGainInvestment{code: $code, message: $message, mGainTotalInvestment: $mGainTotalInvestment, totalIntrestReceived: $totalIntrestReceived, mGains: $mGains}';
  }
}

class MGain {
  MGain(
      {required this.mGainId,
      required this.userId,
      required this.accountid,
      required this.type,
      required this.amount,
      required this.rate,
      required this.investmentDate,
      required this.maturityDate,
      required this.isActive,
      required this.plots});

  int mGainId;
  int userId;
  int accountid;
  String type;
  double amount;
  double rate;
  DateTime investmentDate;
  DateTime maturityDate;
  bool isActive;
  List<Plots> plots;

  factory MGain.fromJson(Map<String, dynamic> json) => MGain(
        mGainId: json["mGainId"],
        userId: json["userId"],
        accountid: json["accountid"],
        type: json["type"],
        amount: json["amount"],
        rate: json["rate"].toDouble(),
        investmentDate: DateTime.parse(json["investmentDate"]),
        maturityDate: DateTime.parse(json["maturityDate"]),
        isActive: json["isActive"],
        plots: json["plots"] == null
            ? []
            : List<Plots>.from(json["plots"].map((x) => Plots.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mGainId": mGainId,
        "userId": userId,
        "accountid": accountid,
        "type": type,
        "amount": amount.toDouble(),
        "rate": rate.toDouble(),
        "investmentDate": investmentDate.toIso8601String(),
        "maturityDate": maturityDate.toIso8601String(),
        "isActive": isActive,
        "plots": List<dynamic>.from(plots.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'MGain{mGainId: $mGainId, userId: $userId, accountid: $accountid, type: $type, amount: $amount, rate: $rate, investmentDate: $investmentDate, maturityDate: $maturityDate, isActive: $isActive, plots: $plots}';
  }
}

class Plots {
  String projectName;
  String plotNo;
  double allocatedSqFt;
  double allocatedAmt;

  Plots(
      {required this.projectName,
      required this.plotNo,
      required this.allocatedSqFt,
      required this.allocatedAmt});

  factory Plots.fromJson(Map<String, dynamic> json) => Plots(
      projectName: json['projectName'],
      plotNo: json['plotNo'],
      allocatedSqFt: json['allocatedSqFt'],
      allocatedAmt: json['allocatedAmt']);

  Map<String, dynamic> toJson() => {
        "projectName": projectName,
        "plotNo": plotNo,
        "allocatedSqFt": allocatedSqFt.toDouble(),
        "allocatedAmt": allocatedAmt.toDouble(),
      };

  @override
  String toString() {
    return 'Plots{projectName: $projectName, plotNo: $plotNo, allocatedSqFt: $allocatedSqFt, allocatedAmt: $allocatedAmt}';
  }
}
