import 'dart:convert';
import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/sip_calculator_model.dart';

class SIPCalculatorRepo {
  setSIPCalculator({
    required String name,
    required int sipAmount,
    required int noOfYear,
    required int expectedReturn,
  }) async {
    try {
      final data = jsonEncode(SIPDetails(
        name: name,
        sipAmount: sipAmount,
        noOfYear: noOfYear,
        expectedReturn: expectedReturn,
      ));

      print('SIPCalculator--url------${sipCalculator}');
      print('SIP-data---calculator------$data');

      final response = await ApiHandler.post(url: sipCalculator, body: data);

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