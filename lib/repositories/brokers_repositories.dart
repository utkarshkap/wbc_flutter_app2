import 'dart:convert';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/5PaisaDataModel.dart';
import '../models/5PaisaHoldingDataModel.dart';

class BrokersRepo {
  get5PaisaAccessTokenData({
    required String RequestToken,
  }) async {
    try {
      final data = jsonEncode(Get5PaisaDataModel(
          head: Head(key: userKey),
          body: Body(
              encryKey: encryKey, requestToken: RequestToken, userId: userId)));

      print('get5PaisaAccessToken-data---------$data');

      final response = await ApiHandler.postWithoutBaseURL(
          url: get5PaisaAccessTokenUrl, body: data);
      print('api--order--response------${response.statusCode}');
      print(response.body);
      return response;
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }

  get5PaisaHoldingsData({
    required String ClientCode,
    required String AccessToken,
  }) async {
    try {
      final data = jsonEncode(Get5PaisaHoldingsDataModel(
          head: HoldingHead(key: userKey),
          body: HoldingBody(clientCode: ClientCode)));
      print('get5PaisaAccessToken-data---------$data');
      final response = await ApiHandler.post3(
          url: get5PaisaHoldingUrl, body: data, accessToken: AccessToken);
      print('api--order--response------${response.statusCode}');
      print('API------Response${response}');

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
