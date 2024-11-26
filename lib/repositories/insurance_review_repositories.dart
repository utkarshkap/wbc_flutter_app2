import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';

class ReviewInsuranceRepository {
  setReviewInsurance(
      {required String userid,
      required String mobile,
      required String company,
      required String insurancetype,
      required String insuranceSubType,
      required String insuranceamount,
      required String premium,
      required String premiumterm,
      required String renewaldate,
      required String premiumPayingDate,
      required String premiumPayingFrequency,
      required String uploadFilePath,
      required String uploadFileName}) async {
    print(
        "userid$userid----mobile$mobile------company$company-------insurancetype$insurancetype---------insuranceamount$insuranceamount-----");
    print(
        'premium$premium------------premiumterm$premiumterm-------renewaldate$renewaldate---------premiumPayingDate$premiumPayingDate-------premiumPayingFrequency$premiumPayingFrequency');
    print(
        "uploadFilePath$uploadFilePath---------uploadFileName$uploadFileName");

    print("url------$setInsuranceReviewKey");

    var request =
        http.MultipartRequest('POST', Uri.parse(setInsuranceReviewKey));
    request.fields.addAll({
      'userid': userid,
      'mobile': mobile,
      'company': company,
      'insurancetype': insurancetype,
      'insuranceSubType': insuranceSubType,
      'insuranceamount': insuranceamount,
      'premium': premium,
      'premiumterm': premiumterm,
      'renewalDate': renewaldate,
      'premiumPayingDate': premiumPayingDate,
      'premiumPayingFrequency': premiumPayingFrequency
    });
    request.files
        .add(await http.MultipartFile.fromPath('PdfFile', uploadFilePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return response;
    } else {
      print(response.reasonPhrase);
    }
    return response;
  }

  Future<ApiResponse<Response>> getAllReview(String mobNo) async {
    try {
      final response = await ApiHandler.get('$getAllReviewKey$mobNo');

      print('order-code------${response.statusCode}');

      print('order-body-------${jsonDecode(response.body)}');

      return ApiResponse.withSuccess(response);
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }
}
