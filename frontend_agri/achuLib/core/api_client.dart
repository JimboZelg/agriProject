import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:5000',
      headers: {'Content-Type': 'application/json'},
    ),
  );
}