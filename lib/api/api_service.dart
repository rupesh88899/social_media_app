import 'package:dio/dio.dart';
import 'package:social_media/exceptions/app_exceptions.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  //get request
  Future<Response> getRequest(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException("Unknown error occurred", "API Error: ");
    }
  }

  //post request
  Future<Response> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException("Unknown error occurred", "API Error: ");
    }
  }
}
