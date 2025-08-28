import 'dart:convert';
import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/loan_review_model.dart';
import 'package:http/http.dart' as http;

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
      final data = jsonEncode(
        LoanReviewModel(
          userid: userid,
          mobile: mobile,
          bankname: bankname,
          loantype: loantype,
          loanamount: loanamount,
          tenure: tenure,
          emi: emi,
          rateofinterest: rateofinterest,
        ),
      );

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

  uploadStockReview({
    required String userId,
    required String requestType,
    required String requestSubType,
    required String panNumber,
    required String uploadFilePath,
    required String uploadFileName,
    required String selectStockType,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(uploadStockReviewBaseUrl),
    );
    request.fields.addAll({
      'request_userid': userId,
      'request_type': requestType,
      'request_pan': panNumber,
      'request_subtype': requestSubType,
    });

    request.files.add(
      await http.MultipartFile.fromPath('pdffile', uploadFilePath),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return response;
    } else {
      print(response.reasonPhrase);
    }
    return response;
  }
}
