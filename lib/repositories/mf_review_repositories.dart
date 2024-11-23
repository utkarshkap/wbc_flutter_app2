import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';
import '../models/mf_review_model.dart';
import 'package:http/http.dart' as http;

class ReviewMFRepository {
  setReviewMF({
    required int requestUserid,
    required String requestMobile,
    required String requestDate,
    required int requestType,
    required int requestSubtype,
    required String requestPan,
    required String requestEmail,
  }) async {
    try {
      final data = jsonEncode(MfReview(
          requestUserid: requestUserid,
          requestMobile: requestMobile,
          requestDate: requestDate,
          requestType: requestType,
          requestSubtype: requestSubtype,
          requestPan: requestPan,
          requestEmail: requestEmail));

      print('review-insurance-data------$data');
      final response = await ApiHandler.post(url: setMFReviewKey, body: data);

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

  uploadMfReview({
    required String userId,
    required String requestType,
    required String requestSubtype,
    required String panNumber,
    required String requestId,
    required String uploadFilePath,
  }) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(uploadMfReviewBaseUrl));

    request.fields.addAll({
      'request_userid': userId,
      'request_type': requestType,
      'request_pan': panNumber,
      'request_id': requestId,
      'request_subtype': requestSubtype,
      'pdfpassword': 'Surat@123#'
    });
    request.files
        .add(await http.MultipartFile.fromPath('pdffile', uploadFilePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      ApiUser.uploadMFHolidingApiMessage =
          json.decode(await response.stream.bytesToString())['message'];

      // print("RESPONE----------${await response.stream.bytesToString()}");

      return response;
    } else {
      print(response.reasonPhrase);
    }

    return response;
  }
}
