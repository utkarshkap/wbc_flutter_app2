part of 'api_handler.dart';

/// Common class for API response
class ApiResponse<T> {
  T? data;
  int? statusCode;
  String error = '';

  ApiResponse({this.data, this.statusCode, this.error = ''});

  factory ApiResponse.withSuccess(T data) => ApiResponse<T>(data: data);

  factory ApiResponse.withError(String error, {int? statusCode}) =>
      ApiResponse<T>(error: error, statusCode: statusCode);
}