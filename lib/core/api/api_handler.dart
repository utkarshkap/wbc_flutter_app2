import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
part 'api_response.dart';

class ApiHandler {
  static String baseUrl = 'https://wbcapi.kagroup.in/api/User/';

  /// API GET method
  static Future<Response> get(String url) async {
    try {
      log('----------------------------------------------------------------');
      log(baseUrl + url);
      log('----------------------------------------------------------------');

      final response = await Client()
          .get(Uri.parse(baseUrl + url))
          .timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      print('Going to request timeout');
      throw RequestTimeoutException();
    } on FormatException {
      print('Going to format');
      throw GeneralException();
    }
  }

  static Future<Response> post(
      {required String url, required String body}) async {
    try {
      print('----------------------------------------------------------------');
      print(baseUrl + url);
      print('----------------------------------------------------------------');
      final response = await http.post(Uri.parse(baseUrl + url),
          body: body,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          }).timeout(const Duration(seconds: 60));
      print('STATUS : ${response.statusCode}');
      print('----------------------------------------------------------------');
      print(response.body);
      print('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      print('Going to request timeout');
      throw RequestTimeoutException();
    } on FormatException {
      print('Going to format');
      throw GeneralException();
    }
  }

  static Future<Response> postWithoutBaseURL(
      {required String url, required String body}) async {
    try {
      log('----------------------------------------------------------------');
      log(url);
      log('----------------------------------------------------------------');
      final response = await http.post(Uri.parse(url), body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      }).timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      print('Going to request timeout');
      throw RequestTimeoutException();
    } on FormatException {
      print('Going to format');
      throw GeneralException();
    }
  }

  static Future<Response> postIIFL(
      {required String url,
      required String clientCode,
      required String password,
      required String dob}) async {
    var data = json.encode({
      "head": {
        "appName": "IIFLMarUTKARSH",
        "appVer": "1.0",
        "key": iiflkey,
        "osName": "", //Android, ios
        "requestCode": "IIFLMarRQLoginRequestV2",
        "userId": iifluserId,
        "password": iiflpassword
      },
      "body": {
        "ClientCode": clientCode,
        "Password": password,
        "LocalIP": "",
        "PublicIP": "",
        "HDSerialNumber": "",
        "MACAddress": "",
        "MachineID": "",
        "VersionNo": "",
        "RequestNo": 1,
        "My2PIN": dob,
        "ConnectionType": "1"
      }
    });

    try {
      log('----------------------------------------------------------------');
      log(url);
      log('----------------------------------------------------------------');
      final response = await http.post(Uri.parse(url), body: data, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Ocp-Apim-Subscription-Key": iiflSubscriptionKey,
      }).timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      print('Going to request timeout');
      throw RequestTimeoutException();
    } on FormatException {
      print('Going to format');
      throw GeneralException();
    }
  }

  static Future<Response> postIIFLHolding(
      {required String url,
      required String clientCode,
      required String cookie}) async {
    var data = json.encode({
      "head": {
        "appName": iiflAppName,
        "appVer": "1.0",
        "key": iiflkey,
        "osName": "Android",
        "requestCode": "IIFLMarRQHoldingV2",
        "userId": iifluserId,
        "password": iiflpassword
      },
      "body": {"ClientCode": clientCode}
    });

    try {
      log('----------------------------------------------------------------');
      log(url);
      log('----------------------------------------------------------------');
      final response = await http.post(Uri.parse(url), body: data, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Ocp-Apim-Subscription-Key": iiflSubscriptionKey,
        "Cookie": cookie
      }).timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      print('Going to request timeout');
      throw RequestTimeoutException();
    } on FormatException {
      print('Going to format');
      throw GeneralException();
    }
  }

  static Future<Response> post3(
      {required String url,
      required String body,
      required String accessToken}) async {
    try {
      log('----------------------------------------------------------------');
      log(url);
      log('----------------------------------------------------------------');
      final response = await http.post(Uri.parse(url), body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "bearer " + accessToken.toString()
      }).timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      print('Going to request timeout');
      throw RequestTimeoutException();
    } on FormatException {
      print('Going to format');
      throw GeneralException();
    }
  }

  static Future<Response> put(
      {required String url, required String body}) async {
    try {
      log('----------------------------------------------------------------');
      log(baseUrl + url);
      log('----------------------------------------------------------------');
      final response =
          await http.put(Uri.parse(baseUrl + url), body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      }).timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      print('Going to request timeout');
      throw RequestTimeoutException();
    } on FormatException {
      print('Going to format');
      throw GeneralException();
    }
  }

  static Future<Response> delete({required String url}) async {
    try {
      log('----------------------------------------------------------------');
      log(baseUrl + url);
      log('delete----------------------------------------------------------------');
      final response = await http.delete(Uri.parse(baseUrl + url));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      print('Going to request timeout');
      throw RequestTimeoutException();
    } on FormatException {
      print('Going to format');
      throw GeneralException();
    }
  }
}

/// Function that handle response by status code
Response getResponse(Response response) {
  switch (response.statusCode) {
    case 200:
      return response;

    case 400:
      throw BadRequestException(response);

    case 404:
      throw DataNotFoundException(response);

    default:
      throw GeneralException();
  }
}

/// General class for API call exception
class ApiException implements Exception {
  final String message;
  final Response? response;

  ApiException({required this.message, this.response});
}

/// Internet exception
class InternetException extends ApiException {
  InternetException() : super(message: 'Internet not available');
}

/// Request timeout exception
class RequestTimeoutException extends ApiException {
  RequestTimeoutException() : super(message: 'Request timeout');
}

/// General exception
class GeneralException extends ApiException {
  GeneralException() : super(message: 'Something went wrong');
}

/// Bad request exception {400}
class BadRequestException extends ApiException {
  @override
  final Response response;

  BadRequestException(this.response)
      : super(message: 'Invalid or missing parameters', response: response);
}

/// Data not found exception {404}
class DataNotFoundException extends ApiException {
  @override
  final Response response;

  DataNotFoundException(this.response)
      : super(message: 'Requested data is not available', response: response);
}
