import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:wbc_connect_app/repositories/real_estate_repositories.dart';

import '../../core/fetching_api.dart';
import '../../models/review_history_model.dart';
import '../../repositories/insurance_review_repositories.dart';
import '../../repositories/loan_review_repositories.dart';
import '../../repositories/mf_review_repositories.dart';
import '../../repositories/uploadstock_repositories.dart';

part 'review_event.dart';

part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewInitial()) {
    on<CreateInsuranceReview>((event, emit) async {
      emit(InsuranceReviewDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final insuranceReviewRepo = ReviewInsuranceRepository();

        final StreamedResponse response =
            await insuranceReviewRepo.setReviewInsurance(
                userid: event.userid,
                mobile: event.mobile,
                company: event.company,
                insurancetype: event.insurancetype,
                insuranceamount: event.insuranceamount,
                premium: event.premium,
                premiumterm: event.premiumterm,
                renewaldate: event.renewaldate,
                premiumPayingDate: event.premiumPayingDate,
                premiumPayingFrequency: event.premiumPayingFrequency,
                uploadFilePath: event.uploadFilePath,
                uploadFileName: event.uploadFileName);

        // print(
        //     '--upload------mf--review--data--=---${mfReviewRepo.uploadMfReview(userId: event.userId, mono: event.mono, requestType: event.requestType, requestSubtype: event.requestSubtype, panNumber: event.panNumber, email: event.email, uploadFilePath: event.uploadFilePath, uploadFileName: event.uploadFileName)}');

        response.statusCode == 200
            ? emit(InsuranceReviewDataAdded())
            : emit(InsuranceReviewFailed());
      });
    });

    on<CreateMFReview>((event, emit) async {
      emit(MFReviewDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final mfReviewRepo = ReviewMFRepository();

        final response = await mfReviewRepo.setReviewMF(
            requestUserid: event.requestUserid,
            requestMobile: event.requestMobile,
            requestDate: event.requestDate,
            requestType: event.requestType,
            requestPan: event.requestPan,
            requestSubtype: event.requestSubtype,
            requestEmail: event.requestEmail);

        print('--mf--review--data--=---$response');

        response.statusCode == 200
            ? emit(MFReviewDataAdded(response))
            : emit(MFReviewFailed());
      });
    });

    on<CreateLoanReview>((event, emit) async {
      emit(LoanReviewInitial());
      await Future.delayed(const Duration(seconds: 3), () async {
        final loanReviewRepo = ReviewLoanRepository();

        final response = await loanReviewRepo.setReviewLoan(
            userid: event.userid,
            mobile: event.mobile,
            bankname: event.bankname,
            loantype: event.loantype,
            loanamount: event.loanamount,
            tenure: event.tenure,
            emi: event.email,
            rateofinterest: event.rateofinterest);

        print('--loan--review--data--=---$response');

        response.statusCode == 200
            ? emit(LoanReviewDataAdded(response))
            : emit(LoanReviewFailed());
      });
    });

    on<LoadReviewHistoryEvent>((event, emit) async {
      emit(ReviewHistoryInitial());
      try {
        print('-=-------review history---${event.mobNo}');
        final historyData = await FetchingApi().getReviewHistory(event.mobNo);

        print('state emit success-----');
        emit(ReviewHistoryLoadedState(historyData));
      } catch (e) {
        print('error------$e');

        emit(ReviewHistoryErrorState(e.toString()));
      }
    });

    on<UploadMFReview>((event, emit) async {
      emit(UploadMFReviewDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final mfReviewRepo = ReviewMFRepository();

        final StreamedResponse response = await mfReviewRepo.uploadMfReview(
            userId: event.userId,
            mono: event.mono,
            requestType: event.requestType,
            requestSubtype: event.requestSubtype,
            panNumber: event.panNumber,
            email: event.email,
            uploadFilePath: event.uploadFilePath,
            uploadFileName: event.uploadFileName);

        print(
            '--upload------mf--review--data--=---${mfReviewRepo.uploadMfReview(userId: event.userId, mono: event.mono, requestType: event.requestType, requestSubtype: event.requestSubtype, panNumber: event.panNumber, email: event.email, uploadFilePath: event.uploadFilePath, uploadFileName: event.uploadFileName)}');

        response.statusCode == 200
            ? emit(UploadReviewDataAdded())
            : emit(UploadMFReviewFailed());
      });
    });

    on<UploadStockReview>((event, emit) async {
      emit(UploadStockReviewDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final stockReviewRepo = ReviewStockRepository();

        final StreamedResponse response =
            await stockReviewRepo.uploadStockReview(
                userId: event.userId,
                mono: event.mono,
                requestType: event.requestType,
                panNumber: event.panNumber,
                email: event.email,
                selectStockType: event.selectStockType,
                uploadFilePath: event.uploadFilePath,
                uploadFileName: event.uploadFileName);

        print(
            '--upload------mf--review--data--=---${stockReviewRepo.uploadStockReview(userId: event.userId, mono: event.mono, requestType: event.requestType, panNumber: event.panNumber, email: event.email, selectStockType: event.selectStockType, uploadFilePath: event.uploadFilePath, uploadFileName: event.uploadFileName)}');

        response.statusCode == 200
            ? emit(UploadStockDataAdded())
            : emit(UploadStockReviewFailed());
      });
    });

    on<UploadRealEstateData>((event, emit) async {
      emit(UploadRealEstateDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final realEstateRepo = RealEstateRepository();

        final StreamedResponse response =
            await realEstateRepo.uploadRealEstateData(
                propertyType: event.propertyType,
                carpetArea: event.carpetArea,
                BuiltUpArea: event.BuiltUpArea,
                Location: event.Location,
                ProjectName: event.ProjectName,
                carParking: event.carParking,
                enterFacing: event.enterFacing,
                Year: event.Year,
                Price: event.Price,
                userId: event.userId,
                imgPath: event.imgPath);

        print('realEstate statuscode-------${response.statusCode}');

        response.statusCode == 200
            ? emit(UploadRealEstateDataAdded())
            : emit(UploadRealEstateDataFailed());
      });
    });
  }
}
