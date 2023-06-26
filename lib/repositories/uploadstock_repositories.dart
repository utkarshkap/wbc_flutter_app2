import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:wbc_connect_app/presentations/Review/loan_EMI.dart';

import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/loan_review_model.dart';
import 'package:http/http.dart' as http;

import '../models/mf_review_model.dart';

class ReviewStockRepository {
  setReviewStock({
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

      print('api--order--response------${response.statusCode}');
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

  uploadStockReview(
      {required String userId,
      required String mono,
      required String requestType,
      required String panNumber,
      required String email,
      required String uploadFilePath,
      required String uploadFileName,
      required String selectStockType}) async {
    var request = http.MultipartRequest("POST", Uri.parse(uploadMfReviewBaseUrl));
    request.fields['request_userid'] = userId;
    request.fields['request_mobile'] = mono;
    request.fields['request_type'] = requestType;
    request.fields['request_pan'] = panNumber;
    request.fields['request_email'] = email;
    request.fields['stinvtype'] = selectStockType;
    request.files.add(await http.MultipartFile.fromPath(
      'pdffile',
      uploadFilePath,
      filename: uploadFileName,
      contentType: MediaType('application', 'x-tar'),
    ));
    final response = await request.send().then((response) {
      if (response.statusCode == 200) {
        print('200-------');

        return response;
      }
    });
    return response;
  }
}