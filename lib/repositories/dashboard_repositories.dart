import 'dart:convert';
import 'package:http/http.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/family_member_model.dart';

class DashboardRepo {
  Future<ApiResponse<Response>> getDashboardData(String userId) async {
    try {
      final response = await ApiHandler.get(getDashboardKey + userId);

      print('DashboardUrl------${getDashboardKey + userId}');
      print('responsedata------${response.statusCode}');

      print('jsondecode-------${jsonDecode(response.body)}');

      return ApiResponse.withSuccess(response);
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }

  updateTNCValue({
    required String mobileNo,
    required bool tnc,
  }) async {
    try {
      final response = await ApiHandler.put(
          url: '$updateTncKey$mobileNo&tnc=$tnc', body: '');

      print('api--tnc--response------${response.statusCode}');
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

  setFamilyMemberData({
    required int userId,
    required String name,
    required String mobileNo,
    required String relation,
  }) async {
    try {
      final data = jsonEncode(FamilyMemberModel(
          userid: userId, name: name, mobileNo: mobileNo, relation: relation));

      print('family-data---------$data');
      final response = await ApiHandler.post(url: setFamilyMember, body: data);

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

  deleteFamilyMemberData({
    required String mobileNo,
  }) async {
    try {
      final response = await ApiHandler.delete(url: deleteMemberKey + mobileNo);

      print('api--delete--response------${response.statusCode}');
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
