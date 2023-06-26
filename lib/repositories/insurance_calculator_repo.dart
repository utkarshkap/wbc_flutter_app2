import 'dart:convert';

import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/insurance_calculator_model.dart';

import '../core/api/api_handler.dart';

class InsuranceCalculatorRepo {
  setInsuranceCalculator({
    required String name,
    required String gender,
    required int annualincome,
    required int existinglifecoverunt,
    required int totalloandue,
    required int totalsaving,
    required int homeloandue,
    required DateTime insDate,
  }) async {
    try {
      final data = jsonEncode(Insdeatils(
          name: name,
          gender: gender,
          annualincome: annualincome,
          existinglifecover: existinglifecoverunt,
          totalloandue: totalloandue,
          homeloandue: homeloandue,
          totalsaving: totalsaving,
          insDate: insDate
      ));

      print('insurance--url------${insuranceKey}');

      print('insurance-data---calculator------$data');
      final response = await ApiHandler.post(url: insuranceKey, body: data);

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
}
