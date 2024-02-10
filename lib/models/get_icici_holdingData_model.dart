// To parse this JSON data, do
//
//     final getIciciHoldingDataModel = getIciciHoldingDataModelFromJson(jsonString);

import 'dart:convert';

GetIciciHoldingDataModel getIciciHoldingDataModelFromJson(String str) =>
    GetIciciHoldingDataModel.fromJson(json.decode(str));

String getIciciHoldingDataModelToJson(GetIciciHoldingDataModel data) =>
    json.encode(data.toJson());

class GetIciciHoldingDataModel {
  List<Success>? success;
  int? status;
  dynamic error;

  GetIciciHoldingDataModel({
    this.success,
    this.status,
    this.error,
  });

  factory GetIciciHoldingDataModel.fromJson(Map<String, dynamic> json) =>
      GetIciciHoldingDataModel(
        success:
            List<Success>.from(json["Success"].map((x) => Success.fromJson(x))),
        status: json["Status"],
        error: json["Error"],
      );

  Map<String, dynamic> toJson() => {
        "Success": List<dynamic>.from(success!.map((x) => x.toJson())),
        "Status": status,
        "Error": error,
      };
}

class Success {
  String? stockCode;
  String? stockIsin;
  String? quantity;
  String? dematTotalBulkQuantity;
  String? dematAvailQuantity;
  String? blockedQuantity;
  String? dematAllocatedQuantity;

  Success({
    this.stockCode,
    this.stockIsin,
    this.quantity,
    this.dematTotalBulkQuantity,
    this.dematAvailQuantity,
    this.blockedQuantity,
    this.dematAllocatedQuantity,
  });

  factory Success.fromJson(Map<String, dynamic> json) => Success(
        stockCode: json["stock_code"],
        stockIsin: json["stock_ISIN"],
        quantity: json["quantity"],
        dematTotalBulkQuantity: json["demat_total_bulk_quantity"],
        dematAvailQuantity: json["demat_avail_quantity"],
        blockedQuantity: json["blocked_quantity"],
        dematAllocatedQuantity: json["demat_allocated_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "stock_code": stockCode,
        "stock_ISIN": stockIsin,
        "quantity": quantity,
        "demat_total_bulk_quantity": dematTotalBulkQuantity,
        "demat_avail_quantity": dematAvailQuantity,
        "blocked_quantity": blockedQuantity,
        "demat_allocated_quantity": dematAllocatedQuantity,
      };
}
