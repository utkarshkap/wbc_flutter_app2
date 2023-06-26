import 'dart:convert';

import 'package:wbc_connect_app/presentations/Review/loan_EMI.dart';

import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/loan_review_model.dart';
import '../models/mf_review_model.dart';

class ReviewLoanRepository {
  setReviewLoan({
    required int userid,
    required String mobile,
    required String bankname,
    required int loantype,
    required int loanamount,
    required int tenure,
    required int emi,
    required double rateofinterest,
  }) async {
    try {
      final data = jsonEncode(LoanReviewModel(
          userid: userid,
          mobile: mobile,
          bankname: bankname,
          loantype: loantype,
          loanamount: loanamount,
          tenure: tenure,
          emi: emi,
          rateofinterest: rateofinterest));

      print('review-insurance-data------$data');
      final response = await ApiHandler.post(url: reviewLoanUrl, body: data);

      print('xapi--order--response------${response.statusCode}');
      print(response.statusCode);
      return response;
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }
}
