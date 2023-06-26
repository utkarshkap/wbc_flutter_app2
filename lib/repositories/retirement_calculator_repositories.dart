import 'dart:convert';

import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/retirement_calculator_model.dart';

class RetirementCalculatorRepo{
  setRetirementCalculator({
    required String name,
    required int currentAge,
    required int retirementAge,
    required int lifeExpectancy,
    required int monthlyExpenses,
    required int preRetirementReturn,
    required int postRetirementReturn,
    required int currentInvestment,
    required int inflationRate,
  }) async {
    try {
      final data = jsonEncode(RetirementDetails(
        name: name,
        currentAge: currentAge,
        retirementAge: retirementAge,
        lifeExpectancy: lifeExpectancy,
        monthlyExpenses: monthlyExpenses,
        preRetirementReturn: preRetirementReturn,
        postRetirementReturn: postRetirementReturn,
        currentInvestment: currentInvestment,
        inflationRate: inflationRate,
      ));

      print('retirementCalculator--url------${retirementCalculator}');
      print('SIP-data---calculator------$data');

      final response = await ApiHandler.post(url: retirementCalculator, body: data);

      print('api--retirementCalculator--response------${response.statusCode}');
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