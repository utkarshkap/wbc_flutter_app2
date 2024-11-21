import 'dart:convert';

import 'package:http/http.dart';
import 'package:wbc_connect_app/models/review_insurance_model.dart';

import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';

class ReviewInsuranceRepository {
  setReviewInsurance({
    required int userid,
    required String mobile,
    required String company,
    required int insurancetype,
    required int insuranceamount,
    required double premium,
    required int premiumterm,
    required String renewaldate,
    required String premiumPayingDate,
    required String premiumPayingFrequency,
  }) async {
    try {
      final data = jsonEncode(InsuranceReview(
          userid: userid,
          mobile: mobile,
          company: company,
          insurancetype: insurancetype,
          insuranceamount: insuranceamount,
          premium: premium,
          premiumterm: premiumterm,
          renewaldate: renewaldate,
          premiumPayingDate: premiumPayingDate,
          premiumPayingFrequency: premiumPayingFrequency));

      print('review-insurance-data------$data');
      final response =
          await ApiHandler.post(url: setInsuranceReviewKey, body: data);

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
