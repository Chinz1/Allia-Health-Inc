import 'package:dio/dio.dart';

class ApiError {
  String? errorDescription;
  ApiError({this.errorDescription = "Cannot process your request. Please check your network and try again"});

  ApiError.fromDio(Object dioError) {
    _handleError(dioError);
  }
  void _handleError(Object error)async {
    if (error is DioError) {
      var dioError = error; // as DioError;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = 'Request canceled';
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = 'Connection timeout';
          break;
        case DioExceptionType.unknown:
          errorDescription = "Cannot process your request. Please check your network and try again";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = 'Receiving timeout';
          break;
        case DioExceptionType.badResponse:
          if (dioError.response!.statusCode == 401) {
            errorDescription = dioError.response?.data["message"] ?? 'Session timeout';
          } else if(dioError.response!.statusCode == 422){
            errorDescription = dioError.response?.data["message"];
          }
          else if (dioError.response!.statusCode == 400 || dioError.response!.statusCode! <= 500) {
            if(dioError.response!.statusCode == 429){
              errorDescription = dioError.response?.data["message"] ?? error.response!.statusMessage! ;
            }
            errorDescription = dioError.response?.data["message"] ?? extractDescriptionFromResponse(dioError.response?.data["message"]);
          }else if(dioError.response!.statusCode == 500){
            errorDescription = 'A Server Error Occurred';
          } else {
            errorDescription = 'Something went wrong, please check your internet connection..';
          }
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Cannot process your request. Please check your network and try again";
          break;
        case DioErrorType.badCertificate:
          errorDescription = "Cannot process your request. Please check your network and try again";
          break;
        case DioErrorType.connectionError:
          errorDescription = "Cannot process your request. Please check your network and try again";
          break;
      }
    } else {
      errorDescription = "Cannot process your request. Please check your network and try again";
    }
  }

  String? extractDescriptionFromResponse(Response? response) {
    String? message;
    try {
      if(response?.data['data']['error'] != null) {
        message = '${message!}. ${response!.data["data"]["error"]}';
      }
      if (response?.data != null && response!.data['message'] != null) {
        message = response.data['message'];

        if(response.data['error'] != null) {
          message = '${message!}. ${response.data['error']}';
        }

      } else {
        message = response!.statusMessage;
      }

    } catch (error) {
      message = response?.statusMessage ?? error.toString();
    }

    return message;
  }

  @override
  String toString() => errorDescription ?? "Cannot process your request. Please try again";
}

