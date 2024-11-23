import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../core/api/api_consts.dart';
import '../core/api/api_handler.dart';

class ReviewInsuranceRepository {
  setReviewInsurance(
      {required String userid,
      required String mobile,
      required String company,
      required String insurancetype,
      required String insuranceamount,
      required String premium,
      required String premiumterm,
      required String renewaldate,
      required String premiumPayingDate,
      required String premiumPayingFrequency,
      required String uploadFilePath,
      required String uploadFileName}) async {
    print(
        "userid$userid----mobile$mobile------company$company-------insurancetype$insurancetype---------insuranceamount$insuranceamount-----");
    print(
        'premium$premium------------premiumterm$premiumterm-------renewaldate$renewaldate---------premiumPayingDate$premiumPayingDate-------premiumPayingFrequency$premiumPayingFrequency');
    print(
        "uploadFilePath$uploadFilePath---------uploadFileName$uploadFileName");

    print("url------$setInsuranceReviewKey");

    // // try {
    // //   final data = jsonEncode(InsuranceReview(
    // //       userid: userid,
    // //       mobile: mobile,
    // //       company: company,
    // //       insurancetype: insurancetype,
    // //       insuranceamount: insuranceamount,
    // //       premium: premium,
    // //       premiumterm: premiumterm,
    // //       renewaldate: renewaldate,
    // //       premiumPayingDate: premiumPayingDate,
    // //       premiumPayingFrequency: premiumPayingFrequency));

    // //   print('review-insurance-data------$data');
    // //   final response =
    // //       await ApiHandler.post(url: setInsuranceReviewKey, body: data);

    // //   print('api--order--response------${response.statusCode}');
    // //   print(response.statusCode);
    // //   return response;
    // // } on BadRequestException {
    // //   return ApiResponse.withError('Something went wrong', statusCode: 400);
    // // } on ApiException catch (e) {
    // //   return ApiResponse.withError(e.message);
    // // } catch (e) {
    // //   return ApiResponse.withError('Unable to load page');
    // // }
    // var request =
    //     http.MultipartRequest("POST", Uri.parse(setInsuranceReviewKey));
    // // request.fields['userid'] = userId;
    // // request.fields['mobile'] = mobile;
    // // request.fields['company'] = company;
    // // request.fields['insurancetype'] = insurancetype;
    // // request.fields['insuranceamount'] = insuranceamount;
    // // request.fields['premium'] = premium;
    // // request.fields['premiumterm'] = premiumterm;
    // // request.fields['renewalDate'] = renewaldate;
    // // request.fields['premiumPayingDate'] = premiumPayingDate;
    // // request.fields['premiumPayingFrequency'] = premiumPayingFrequency;

    // request.fields.addAll({
    //   'userid': userId,
    //   'mobile': mobile,
    //   'company': company,
    //   'insurancetype': insurancetype,
    //   'insuranceamount': insuranceamount,
    //   'premium': premium,
    //   'premiumterm': premiumterm,
    //   'renewalDate': renewaldate,
    //   'premiumPayingDate': premiumPayingDate,
    //   'premiumPayingFrequency': premiumPayingFrequency
    // });
    // if (uploadFileName != '' || uploadFileName.isNotEmpty) {
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'PdfFile', uploadFilePath,
    //       filename: uploadFileName,
    //       contentType: MediaType('application/json', 'pdf')));
    // }
    // http.StreamedResponse response = await request.send();
    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    //   return response;
    // } else {
    //   print(response.reasonPhrase);
    // }

    // // final response = await request.send().then((response) {
    // //   print(
    // //       '------${response.stream.bytesToString()}------${response.statusCode}-------${response.stream}');

    // //   if (response.statusCode == 200) {
    // //     print("Response:::::::::::::${response.stream.isBroadcast}");
    // //     return response;
    // //   }
    // // });
    // return response;

    var request =
        http.MultipartRequest('POST', Uri.parse(setInsuranceReviewKey));
    request.fields.addAll({
      'userid': userid,
      'mobile': mobile,
      'company': company,
      'insurancetype': insurancetype,
      'insuranceamount': insuranceamount,
      'premium': premium,
      'premiumterm': premiumterm,
      'renewalDate': renewaldate,
      'premiumPayingDate': premiumPayingDate,
      'premiumPayingFrequency': premiumPayingFrequency
    });
    request.files
        .add(await http.MultipartFile.fromPath('PdfFile', uploadFilePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return response;
    } else {
      print(response.reasonPhrase);
    }
    return response;
  }

  Future<ApiResponse<Response>> getAllReview(String mobNo) async {
    try {
      final response = await ApiHandler.get('$getAllReviewKey$mobNo');

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
