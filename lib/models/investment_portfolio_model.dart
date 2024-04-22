import 'dart:convert';

InvestmentPortfolio investmentPortfolioFromJson(String str) =>
    InvestmentPortfolio.fromJson(json.decode(str));

String investmentPortfolioToJson(InvestmentPortfolio data) =>
    json.encode(data.toJson());

class InvestmentPortfolio {
  int code;
  dynamic message;
  List<Response> response;
  double totalBalanceUnit;
  dynamic totalPurchaseAmount;
  dynamic totalRedeemAmount;
  double totalAmount;
  int totalScheme;

  InvestmentPortfolio({
    required this.code,
    required this.message,
    required this.response,
    required this.totalBalanceUnit,
    required this.totalPurchaseAmount,
    required this.totalRedeemAmount,
    required this.totalAmount,
    required this.totalScheme,
  });

  factory InvestmentPortfolio.fromJson(Map<String, dynamic> json) =>
      InvestmentPortfolio(
        code: json["code"],
        message: json["message"],
        response: List<Response>.from(
            json["response"].map((x) => Response.fromJson(x))),
        totalBalanceUnit: json["totalBalanceUnit"]?.toDouble(),
        totalPurchaseAmount: json["totalPurchaseAmount"],
        totalRedeemAmount: json["totalRedeemAmount"],
        totalAmount: json["totalAmount"]?.toDouble(),
        totalScheme: json["totalScheme"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "totalBalanceUnit": totalBalanceUnit,
        "totalPurchaseAmount": totalPurchaseAmount,
        "totalRedeemAmount": totalRedeemAmount,
        "totalAmount": totalAmount,
        "totalScheme": totalScheme,
      };
}

class Response {
  dynamic schemeId;
  String schemename;
  String foliono;
  double totalPurchaseUnit;
  double totalRedemptionUnit;
  double balanceUnit;
  double nav;
  double currentValue;

  Response({
    required this.schemeId,
    required this.schemename,
    required this.foliono,
    required this.totalPurchaseUnit,
    required this.totalRedemptionUnit,
    required this.balanceUnit,
    required this.nav,
    required this.currentValue,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        schemeId: json["schemeId"],
        schemename: json["schemename"],
        foliono: json["foliono"],
        totalPurchaseUnit: json["totalPurchaseUnit"]?.toDouble(),
        totalRedemptionUnit: json["totalRedemptionUnit"]?.toDouble(),
        balanceUnit: json["balanceUnit"]?.toDouble(),
        nav: json["nav"]?.toDouble(),
        currentValue: json["currentValue"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "schemeId": schemeId,
        "schemename": schemename,
        "foliono": foliono,
        "totalPurchaseUnit": totalPurchaseUnit,
        "totalRedemptionUnit": totalRedemptionUnit,
        "balanceUnit": balanceUnit,
        "nav": nav,
        "currentValue": currentValue,
      };
}
