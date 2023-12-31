part of 'review_bloc.dart';

@immutable
abstract class ReviewEvent {}

class CreateInsuranceReview extends ReviewEvent {
  final int userid;
  final String mobile;
  final String company;
  final int insurancetype;
  final int insuranceamount;
  final double premium;
  final int premiumterm;

  CreateInsuranceReview({
    required this.userid,
    required this.mobile,
    required this.company,
    required this.insurancetype,
    required this.insuranceamount,
    required this.premium,
    required this.premiumterm,
  });

  @override
  String toString() {
    return 'CreateInsuranceReview{userid: $userid, mobile: $mobile, company: $company, insurancetype: $insurancetype, insuranceamount: $insuranceamount, premium: $premium, premiumterm: $premiumterm}';
  }
}

class CreateMFReview extends ReviewEvent {
  final int requestUserid;
  final String requestMobile;
  final String requestDate;
  final int requestType;
  final String requestPan;
  final String requestEmail;

  CreateMFReview(
      {required this.requestUserid,
      required this.requestMobile,
      required this.requestDate,
      required this.requestType,
      required this.requestPan,
      required this.requestEmail});

  @override
  String toString() {
    return 'CreateMFReview{requestUserid: $requestUserid, requestMobile: $requestMobile, requestDate: $requestDate, requestType: $requestType, requestPan: $requestPan, requestEmail: $requestEmail}';
  }
}

class UploadMFReview extends ReviewEvent {
  final String userId;
  final String mono;
  final String requestType;
  final String panNumber;
  final String email;
  final String uploadFilePath;
  final String uploadFileName;

  @override
  String toString() {
    return 'UploadMFReview{userId: $userId, mono: $mono, requestType: $requestType, panNumber: $panNumber, email: $email, uploadFilePath: $uploadFilePath, uploadFileName: $uploadFileName}';
  }

  UploadMFReview(
      {required this.userId,
      required this.mono,
      required this.requestType,
      required this.panNumber,
      required this.email,
      required this.uploadFilePath,
      required this.uploadFileName});
}

class UploadStockReview extends ReviewEvent {
  final String userId;
  final String mono;
  final String requestType;
  final String panNumber;
  final String email;
  final String selectStockType;
  final String uploadFilePath;
  final String uploadFileName;

  @override
  String toString() {
    return 'UploadStockReview{userId: $userId, mono: $mono, requestType: $requestType, panNumber: $panNumber, email: $email, selectStockType: $selectStockType, uploadFilePath: $uploadFilePath, uploadFileName: $uploadFileName}';
  }

  UploadStockReview(
      {required this.userId,
      required this.mono,
      required this.requestType,
      required this.panNumber,
      required this.email,
      required this.selectStockType,
      required this.uploadFilePath,
      required this.uploadFileName});
}

class CreateLoanReview extends ReviewEvent {
  final int userid;
  final String mobile;
  final String bankname;
  final int loantype;
  final int loanamount;
  final int tenure;
  final int email;
  final double rateofinterest;

  CreateLoanReview(
      {required this.userid,
      required this.mobile,
      required this.bankname,
      required this.loantype,
      required this.loanamount,
      required this.tenure,
      required this.email,
      required this.rateofinterest});

  @override
  String toString() {
    return 'CreateLoanReview{userid: $userid, mobile: $mobile, bankname: $bankname, loantype: $loantype, loanamount: $loanamount, tenure: $tenure, emi: $email, rateofinterest: $rateofinterest}';
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
