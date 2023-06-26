import 'dart:convert';

import 'package:http/http.dart';
import 'package:wbc_connect_app/models/order_model.dart';

import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';

class OrderRepository {
  setOrder({
    required int userId,
    required int orderId,
    required int amount,
    required String shipName,
    required String shipAddress,
    required String deliverytype,
    required String country,
    required String state,
    required String city,
    required String zipcode,
    required String phone,
    required String orderDate,
    required List<Item> items,
  }) async {
    try {
      final data = jsonEncode(Order(
          orderId: orderId,
          userId: userId,
          amount: amount,
          shipName: shipName,
          shipAddress: shipAddress,
          deliverytype: deliverytype,
          country: country,
          state: state,
          city: city,
          zipcode: zipcode,
          phone: phone,
          orderDate: orderDate,
          items: items));

      print('order-data------$data');
      final response = await ApiHandler.post(url: setOrderKey, body: data);

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

  Future<ApiResponse<Response>> getOrder(String userId) async {
    try {
      final response = await ApiHandler.get("$getAllOrderKey$userId");

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
