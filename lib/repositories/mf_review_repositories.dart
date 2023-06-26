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
    required String requestPan,
    required String requestEmail,
  }) async {
    try {
      final data = jsonEncode(MfReview(
          requestUserid: requestUserid,
          requestMobile: requestMobile,
          requestDate: requestDate,
          requestType: requestType,
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

  uploadMfReview(
      {required String userId,
      required String mono,
      required String requestType,
      required String panNumber,
      required String email,
      required String uploadFilePath,
      required String uploadFileName}) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(uploadMfReviewBaseUrl));
    request.fields['request_userid'] = userId;
    request.fields['request_mobile'] = mono;
    request.fields['request_type'] = requestType;
    request.fields['request_pan'] = panNumber;
    request.fields['request_email'] = email;
    request.files.add(await http.MultipartFile.fromPath(
      'pdffile',
      uploadFilePath,
      filename: uploadFileName,
      contentType: MediaType('application', 'x-tar'),
    ));
    final response = await request.send().then((response) {
      if (response.statusCode == 200) {
        print('200-------');

        return response;
      }
    });
    return response;
  }
}
