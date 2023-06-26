import 'dart:convert';

CustomPayumoneyHashkeyModel customPayumoneyHashKeyFromJson(String str) => CustomPayumoneyHashkeyModel.fromJson(json.decode(str));

String customPayumoneyHashKeyToJson(CustomPayumoneyHashkeyModel data) => json.encode(data.toJson());

class CustomPayumoneyHashkeyModel {

  String paymentHash;
  String paymentRelatedDetailsForMobileSdkHash;
  String vasForMobileSdkHash;
  String deleteUserCardHash;
  String getUserCardsHash;
  String editUserCardHash;
  String saveUserCardHash;
  int status;
  String message;

  CustomPayumoneyHashkeyModel({
    required this.paymentHash,
    required this.paymentRelatedDetailsForMobileSdkHash,
    required this.vasForMobileSdkHash,
    required this.deleteUserCardHash,
    required this.getUserCardsHash,
    required this.editUserCardHash,
    required this.saveUserCardHash,
    required this.status,
    required this.message,
  });

  factory CustomPayumoneyHashkeyModel.fromJson(Map<String, dynamic> json) => CustomPayumoneyHashkeyModel(
    paymentHash: json["payment_hash"],
    paymentRelatedDetailsForMobileSdkHash: json["payment_related_details_for_mobile_sdk_hash"],
    vasForMobileSdkHash: json["vas_for_mobile_sdk_hash"],
    deleteUserCardHash: json["delete_user_card_hash"],
    getUserCardsHash: json["get_user_cards_hash"],
    editUserCardHash: json["edit_user_card_hash"],
    saveUserCardHash: json["save_user_card_hash"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "payment_hash": paymentHash,
    "payment_related_details_for_mobile_sdk_hash": paymentRelatedDetailsForMobileSdkHash,
    "vas_for_mobile_sdk_hash": vasForMobileSdkHash,
    "delete_user_card_hash": deleteUserCardHash,
    "get_user_cards_hash": getUserCardsHash,
    "edit_user_card_hash": editUserCardHash,
    "save_user_card_hash": saveUserCardHash,
    "status": status,
    "message": message,
  };

  @override
  String toString() {
    return 'CustomPayumoneyHashkeyModel{payment_hash: $paymentHash,status: $status,message: $message}';
  }
}