import 'dart:convert';
import '../core/api/api_consts.dart';
import '../models/fasttrack_model.dart';
import '../core/api/api_handler.dart';

class FastTrackRepository{

  updateFastTrackUserAPI(
      {required int userId,
        required String mobileNo,
        required String date,
        required String paymentAmount,
        }) async {
    try {
      final data = jsonEncode(UpdateFastTrackModel(
          userid: userId,
          mobile: mobileNo,
          date: date,
          amount: paymentAmount
      ));

      print('data------$data');
      final response = await ApiHandler.post(url: updateFastTrackUser, body: data);

      print('api--------------response-------------');
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