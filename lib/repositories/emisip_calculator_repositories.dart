import 'dart:convert';
import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/emi_sip_calcularor_model.dart';

class EMISIPCalculatorRepo {
  setSIPCalculator({
    required String name,
    required int loanAmount,
    required int noOfYear,
    required int loanInterestRate,
    required int interestRateOnInvestment,
  }) async {
    try {
      final data = jsonEncode(EMISIPDetails(
        name: name,
        noOfYear: noOfYear,
        loanAmount: loanAmount,
        loanInterestRate: loanInterestRate,
        interestRateOnInvestment: interestRateOnInvestment,
      ));

      print('EMISIPCalculator--url------${emiSipCalculator}');
      print('EMISIP-data---calculator------$data');

      final response = await ApiHandler.post(url: emiSipCalculator, body: data);

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