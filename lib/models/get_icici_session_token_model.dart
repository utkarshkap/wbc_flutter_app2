// To parse this JSON data, do
//
//     final getIciciSessionTokenModel = getIciciSessionTokenModelFromJson(jsonString);

import 'dart:convert';

GetIciciSessionTokenModel getIciciSessionTokenModelFromJson(String str) =>
    GetIciciSessionTokenModel.fromJson(json.decode(str));

String getIciciSessionTokenModelToJson(GetIciciSessionTokenModel data) =>
    json.encode(data.toJson());

class GetIciciSessionTokenModel {
  Success? success;
  int? status;
  dynamic error;

  GetIciciSessionTokenModel({
    this.success,
    this.status,
    this.error,
  });

  factory GetIciciSessionTokenModel.fromJson(Map<String, dynamic> json) =>
      GetIciciSessionTokenModel(
        success: Success.fromJson(json["Success"]),
        status: json["Status"],
        error: json["Error"],
      );

  Map<String, dynamic> toJson() => {
        "Success": success?.toJson(),
        "Status": status,
        "Error": error,
      };
}

class Success {
  Exg? exgTradeDate;
  Exg? exgStatus;
  SegmentsAllowed? segmentsAllowed;
  String? idirectUserid;
  String? sessionToken;
  String? idirectUserName;
  String? idirectOrdTyp;
  String? idirectLastloginTime;
  String? mfHoldingModePopupFlg;
  String? commodityExchangeStatus;
  String? commodityTradeDate;
  String? commodityAllowed;

  Success({
    this.exgTradeDate,
    this.exgStatus,
    this.segmentsAllowed,
    this.idirectUserid,
    this.sessionToken,
    this.idirectUserName,
    this.idirectOrdTyp,
    this.idirectLastloginTime,
    this.mfHoldingModePopupFlg,
    this.commodityExchangeStatus,
    this.commodityTradeDate,
    this.commodityAllowed,
  });

  factory Success.fromJson(Map<String, dynamic> json) => Success(
        exgTradeDate: Exg.fromJson(json["exg_trade_date"]),
        exgStatus: Exg.fromJson(json["exg_status"]),
        segmentsAllowed: SegmentsAllowed.fromJson(json["segments_allowed"]),
        idirectUserid: json["idirect_userid"],
        sessionToken: json["session_token"],
        idirectUserName: json["idirect_user_name"],
        idirectOrdTyp: json["idirect_ORD_TYP"],
        idirectLastloginTime: json["idirect_lastlogin_time"],
        mfHoldingModePopupFlg: json["mf_holding_mode_popup_flg"],
        commodityExchangeStatus: json["commodity_exchange_status"],
        commodityTradeDate: json["commodity_trade_date"],
        commodityAllowed: json["commodity_allowed"],
      );

  Map<String, dynamic> toJson() => {
        "exg_trade_date": exgTradeDate?.toJson(),
        "exg_status": exgStatus?.toJson(),
        "segments_allowed": segmentsAllowed?.toJson(),
        "idirect_userid": idirectUserid,
        "session_token": sessionToken,
        "idirect_user_name": idirectUserName,
        "idirect_ORD_TYP": idirectOrdTyp,
        "idirect_lastlogin_time": idirectLastloginTime,
        "mf_holding_mode_popup_flg": mfHoldingModePopupFlg,
        "commodity_exchange_status": commodityExchangeStatus,
        "commodity_trade_date": commodityTradeDate,
        "commodity_allowed": commodityAllowed,
      };
}

class Exg {
  String? nse;
  String? bse;
  String? fno;
  String? ndx;

  Exg({
    this.nse,
    this.bse,
    this.fno,
    this.ndx,
  });

  factory Exg.fromJson(Map<String, dynamic> json) => Exg(
        nse: json["NSE"],
        bse: json["BSE"],
        fno: json["FNO"],
        ndx: json["NDX"],
      );

  Map<String, dynamic> toJson() => {
        "NSE": nse,
        "BSE": bse,
        "FNO": fno,
        "NDX": ndx,
      };
}

class SegmentsAllowed {
  String? trading;
  String? equity;
  String? derivatives;
  String? currency;

  SegmentsAllowed({
    this.trading,
    this.equity,
    this.derivatives,
    this.currency,
  });

  factory SegmentsAllowed.fromJson(Map<String, dynamic> json) =>
      SegmentsAllowed(
        trading: json["Trading"],
        equity: json["Equity"],
        derivatives: json["Derivatives"],
        currency: json["Currency"],
      );

  Map<String, dynamic> toJson() => {
        "Trading": trading,
        "Equity": equity,
        "Derivatives": derivatives,
        "Currency": currency,
      };
}
