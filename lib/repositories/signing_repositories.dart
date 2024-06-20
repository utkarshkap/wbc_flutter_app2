import 'dart:convert';

import 'package:http/http.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/add_contacts_model.dart';

import '../core/api/api_handler.dart';
import '../models/signing_screen_model.dart' as sigingmodel;

class SigningRepository {
  setLoginUser(
      {required String name,
      required String mobileNo,
      required String email,
      String? address,
      String? area,
      String? city,
      String? country,
      String? deviceId,
      int? pincode,
      DateTime? dob,
      required bool tnc}) async {
    try {
      final data = jsonEncode(sigingmodel.Data(
          name: name,
          mobileNo: mobileNo,
          email: email,
          address: address,
          area: area,
          city: city,
          country: country,
          pincode: pincode,
          deviceId: deviceId,
          dob: dob,
          tnc: tnc));

      print('data------$data');
      final response = await ApiHandler.post(url: setUser, body: data);

      print('api--------------response-------------');
      // print(response.statusCode);
      return response;
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }

  Future<ApiResponse<Response>> getUser(String moNo) async {
    try {
      final response = await ApiHandler.get(getUserKey + moNo);

      print('responsedata------${response.statusCode}');

      // print('jsondecode-------${jsonDecode(response.body)}');

      return ApiResponse.withSuccess(response);
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }

  // getContact(String userId) async{
  //   try {
  //
  //     final response = await ApiHandler.get(getc+moNo);
  //
  //     print('api--------------response-------------');
  //     print(response.statusCode);
  //     return response;
  //   } on BadRequestException {
  //     return ApiResponse.withError('Something went wrong', statusCode: 400);
  //   } on ApiException catch (e) {
  //     return ApiResponse.withError(e.message);
  //   } catch (e) {
  //     return ApiResponse.withError('Unable to load page');
  //   }
  //
  // }

  postContactsData(
      {required String mobileNo,
      required String date,
      required List<ContactData> contacts}) async {
    try {
      final data = jsonEncode(
          AddContact(mobileNo: mobileNo, date: date, contacts: contacts));

      print('data------$data');
      final response = await ApiHandler.post(url: addContact, body: data);

      print('addcontactapi--------------response-------------${response.body}');
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

  deleteUserAccount(String moNo) async {
    try {
      final response = await ApiHandler.get(deleteAccountKey + moNo);
      return jsonDecode(response.body)['code'];
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }

  getPendingDeleteUser(String moNo) async {
    try {
      final response = await ApiHandler.get(getPendingDeleteUserKey + moNo);
      return jsonDecode(response.body)['message'];
    } on BadRequestException {
      return ApiResponse.withError('Something went wrong', statusCode: 400);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to load page');
    }
  }
}
