import 'dart:convert';

Get5PaisaAccessTokenModel get5PaisaAccessTokenFromJson(String str) => Get5PaisaAccessTokenModel.fromJson(json.decode(str));

String get5PaisaAccessTokenToJson(Get5PaisaAccessTokenModel data) => json.encode(data.toJson());

class Get5PaisaAccessTokenModel {
  Body? body;
  Head? head;

  Get5PaisaAccessTokenModel({this.body, this.head});

  Get5PaisaAccessTokenModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    return data;
  }
}

class Body {
  String? accessToken;
  String? allowBseCash;
  String? allowBseDeriv;
  String? allowBseMF;
  String? allowMCXComm;
  String? allowMcxSx;
  String? allowNSECurrency;
  String? allowNSEL;
  String? allowNseCash;
  String? allowNseComm;
  String? allowNseDeriv;
  String? allowNseMF;
  int? bulkOrderAllowed;
  String? cleareDt;
  String? clientCode;
  String? clientName;
  String? clientType;
  String? commodityEnabled;
  String? customerType;
  String? dPInfoAvailable;
  String? demoTrial;
  int? directMFCharges;
  int? isIDBound;
  int? isIDBound2;
  String? isOnlyMF;
  int? isPLM;
  int? isPLMDefined;
  String? message;
  String? oTPCredentialID;
  int? pGCharges;
  int? pLMsAllowed;
  String? pOAStatus;
  int? passwordChangeFlag;
  String? passwordChangeMessage;
  int? referralBenefits;
  String? refreshToken;
  int? runningAuthorization;
  int? status;
  int? versionChanged;

  Body(
      {this.accessToken,
        this.allowBseCash,
        this.allowBseDeriv,
        this.allowBseMF,
        this.allowMCXComm,
        this.allowMcxSx,
        this.allowNSECurrency,
        this.allowNSEL,
        this.allowNseCash,
        this.allowNseComm,
        this.allowNseDeriv,
        this.allowNseMF,
        this.bulkOrderAllowed,
        this.cleareDt,
        this.clientCode,
        this.clientName,
        this.clientType,
        this.commodityEnabled,
        this.customerType,
        this.dPInfoAvailable,
        this.demoTrial,
        this.directMFCharges,
        this.isIDBound,
        this.isIDBound2,
        this.isOnlyMF,
        this.isPLM,
        this.isPLMDefined,
        this.message,
        this.oTPCredentialID,
        this.pGCharges,
        this.pLMsAllowed,
        this.pOAStatus,
        this.passwordChangeFlag,
        this.passwordChangeMessage,
        this.referralBenefits,
        this.refreshToken,
        this.runningAuthorization,
        this.status,
        this.versionChanged});

  Body.fromJson(Map<String, dynamic> json) {
    accessToken = json['AccessToken'];
    allowBseCash = json['AllowBseCash'];
    allowBseDeriv = json['AllowBseDeriv'];
    allowBseMF = json['AllowBseMF'];
    allowMCXComm = json['AllowMCXComm'];
    allowMcxSx = json['AllowMcxSx'];
    allowNSECurrency = json['AllowNSECurrency'];
    allowNSEL = json['AllowNSEL'];
    allowNseCash = json['AllowNseCash'];
    allowNseComm = json['AllowNseComm'];
    allowNseDeriv = json['AllowNseDeriv'];
    allowNseMF = json['AllowNseMF'];
    bulkOrderAllowed = json['BulkOrderAllowed'];
    cleareDt = json['CleareDt'];
    clientCode = json['ClientCode'];
    clientName = json['ClientName'];
    clientType = json['ClientType'];
    commodityEnabled = json['CommodityEnabled'];
    customerType = json['CustomerType'];
    dPInfoAvailable = json['DPInfoAvailable'];
    demoTrial = json['DemoTrial'];
    directMFCharges = json['DirectMFCharges'];
    isIDBound = json['IsIDBound'];
    isIDBound2 = json['IsIDBound2'];
    isOnlyMF = json['IsOnlyMF'];
    isPLM = json['IsPLM'];
    isPLMDefined = json['IsPLMDefined'];
    message = json['Message'];
    oTPCredentialID = json['OTPCredentialID'];
    pGCharges = json['PGCharges'];
    pLMsAllowed = json['PLMsAllowed'];
    pOAStatus = json['POAStatus'];
    passwordChangeFlag = json['PasswordChangeFlag'];
    passwordChangeMessage = json['PasswordChangeMessage'];
    referralBenefits = json['ReferralBenefits'];
    refreshToken = json['RefreshToken'];
    runningAuthorization = json['RunningAuthorization'];
    status = json['Status'];
    versionChanged = json['VersionChanged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AccessToken'] = this.accessToken;
    data['AllowBseCash'] = this.allowBseCash;
    data['AllowBseDeriv'] = this.allowBseDeriv;
    data['AllowBseMF'] = this.allowBseMF;
    data['AllowMCXComm'] = this.allowMCXComm;
    data['AllowMcxSx'] = this.allowMcxSx;
    data['AllowNSECurrency'] = this.allowNSECurrency;
    data['AllowNSEL'] = this.allowNSEL;
    data['AllowNseCash'] = this.allowNseCash;
    data['AllowNseComm'] = this.allowNseComm;
    data['AllowNseDeriv'] = this.allowNseDeriv;
    data['AllowNseMF'] = this.allowNseMF;
    data['BulkOrderAllowed'] = this.bulkOrderAllowed;
    data['CleareDt'] = this.cleareDt;
    data['ClientCode'] = this.clientCode;
    data['ClientName'] = this.clientName;
    data['ClientType'] = this.clientType;
    data['CommodityEnabled'] = this.commodityEnabled;
    data['CustomerType'] = this.customerType;
    data['DPInfoAvailable'] = this.dPInfoAvailable;
    data['DemoTrial'] = this.demoTrial;
    data['DirectMFCharges'] = this.directMFCharges;
    data['IsIDBound'] = this.isIDBound;
    data['IsIDBound2'] = this.isIDBound2;
    data['IsOnlyMF'] = this.isOnlyMF;
    data['IsPLM'] = this.isPLM;
    data['IsPLMDefined'] = this.isPLMDefined;
    data['Message'] = this.message;
    data['OTPCredentialID'] = this.oTPCredentialID;
    data['PGCharges'] = this.pGCharges;
    data['PLMsAllowed'] = this.pLMsAllowed;
    data['POAStatus'] = this.pOAStatus;
    data['PasswordChangeFlag'] = this.passwordChangeFlag;
    data['PasswordChangeMessage'] = this.passwordChangeMessage;
    data['ReferralBenefits'] = this.referralBenefits;
    data['RefreshToken'] = this.refreshToken;
    data['RunningAuthorization'] = this.runningAuthorization;
    data['Status'] = this.status;
    data['VersionChanged'] = this.versionChanged;
    return data;
  }
}

class Head {
  int? status;
  String? statusDescription;

  Head({this.status, this.statusDescription});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusDescription = json['StatusDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusDescription'] = this.statusDescription;
    return data;
  }
}
