part of 'review_bloc.dart';

@immutable
abstract class ReviewEvent {}

class CreateInsuranceReview extends ReviewEvent {
  final String userid;
  final String mobile;
  final String company;
  final String insurancetype;
  final String insuranceSubType;
  final String insuranceamount;
  final String premium;
  final String premiumterm;
  final String renewaldate;
  final String premiumPayingDate;
  final String premiumPayingFrequency;
  final String uploadFilePath;
  final String uploadFileName;

  CreateInsuranceReview({
    required this.userid,
    required this.mobile,
    required this.company,
    required this.insurancetype,
    required this.insuranceSubType,
    required this.insuranceamount,
    required this.premium,
    required this.premiumterm,
    required this.renewaldate,
    required this.premiumPayingDate,
    required this.premiumPayingFrequency,
    required this.uploadFilePath,
    required this.uploadFileName,
  });

  @override
  String toString() {
    return 'CreateInsuranceReview{userid: $userid, mobile: $mobile, company: $company, insurancetype: $insurancetype, insuranceSubType: $insuranceSubType, insuranceamount: $insuranceamount, premium: $premium, premiumterm: $premiumterm, renewaldate: $renewaldate, premiumPayingDate: $premiumPayingDate, premiumPayingFrequency: $premiumPayingFrequency, uploadFilePath: $uploadFilePath, uploadFileName: $uploadFileName}';
  }
}

class CreateMFReview extends ReviewEvent {
  final int requestUserid;
  final String requestMobile;
  final String requestDate;
  final int requestType;
  final int requestSubtype;
  final String requestPan;
  final String requestEmail;

  CreateMFReview(
      {required this.requestUserid,
      required this.requestMobile,
      required this.requestDate,
      required this.requestType,
      required this.requestSubtype,
      required this.requestPan,
      required this.requestEmail});

  @override
  String toString() {
    return 'CreateMFReview{requestUserid: $requestUserid, requestMobile: $requestMobile, requestDate: $requestDate, requestType: $requestType, requestSubtype: $requestSubtype, requestPan: $requestPan, requestEmail: $requestEmail}';
  }
}

class UploadMFReview extends ReviewEvent {
  final String userId;
  final String requestType;
  final String requestSubtype;
  final String panNumber;
  final String requestId;
  final String uploadFilePath;

  @override
  String toString() {
    return 'UploadMFReview{userId: $userId, requestType: $requestType, requestSubtype: $requestSubtype, panNumber: $panNumber, requestId: $requestId, uploadFilePath: $uploadFilePath}';
  }

  UploadMFReview({
    required this.userId,
    required this.requestType,
    required this.requestSubtype,
    required this.panNumber,
    required this.requestId,
    required this.uploadFilePath,
  });
}

class UploadStockReview extends ReviewEvent {
  final String userId;
  final String requestType;
  final String panNumber;
  final String selectStockType;
  final String uploadFilePath;
  final String uploadFileName;

  @override
  String toString() {
    return 'UploadStockReview{userId: $userId, requestType: $requestType, panNumber: $panNumber, selectStockType: $selectStockType, uploadFilePath: $uploadFilePath, uploadFileName: $uploadFileName}';
  }

  UploadStockReview(
      {required this.userId,
      required this.requestType,
      required this.panNumber,
      required this.selectStockType,
      required this.uploadFilePath,
      required this.uploadFileName});
}

class CreateLoanReview extends ReviewEvent {
  final String userid;
  final String mobile;
  final String bankname;
  final String loantype;
  final String loanamount;
  final String emi;
  final String rateofinterest;
  final String tenure;
  final String note;
  final String uploadFilePath;

  CreateLoanReview(
      {required this.userid,
      required this.mobile,
      required this.bankname,
      required this.loantype,
      required this.loanamount,
      required this.emi,
      required this.rateofinterest,
      required this.tenure,
      required this.note,
      required this.uploadFilePath});

  @override
  String toString() {
    return 'CreateLoanReview{userid: $userid, mobile: $mobile, bankname: $bankname, loantype: $loantype, loanamount: $loanamount, emi: $emi, rateofinterest: $rateofinterest, tenure: $tenure, note: $note, uploadFilePath: $uploadFilePath}';
  }
}

class UploadRealEstateData extends ReviewEvent {
  final String propertyType;
  final String carpetArea;
  final String BuiltUpArea;
  final String Location;
  final String ProjectName;
  final String carParking;
  final String enterFacing;
  final String Year;
  final String Price;
  final String userId;
  final List<String> imgPath;

  UploadRealEstateData(
      {required this.propertyType,
      required this.carpetArea,
      required this.BuiltUpArea,
      required this.Location,
      required this.ProjectName,
      required this.carParking,
      required this.enterFacing,
      required this.Price,
      required this.userId,
      required this.imgPath,
      required this.Year});

  @override
  String toString() {
    return 'UploadRealEstateData{propertyType: $propertyType, carpetArea: $carpetArea, BuiltUpArea: $BuiltUpArea, Location: $Location, ProjectName: $ProjectName, carParking: $carParking, enterFacing: $enterFacing, Year: $Year, Price: $Price, userId: $userId, imgPath: $imgPath}';
  }
}

class LoadReviewHistoryEvent extends ReviewEvent {
  final String mobNo;

  LoadReviewHistoryEvent({required this.mobNo});
}
