import 'package:dio/dio.dart';
import '../core/api_client.dart';

class AuthService {
  static Future<String?> login(String username, String password) async {
    try {
      final url = '${ApiClient.dio.options.baseUrl}/auth/login';
      print('🔎 Intentando login → URL: $url');
      final response = await ApiClient.dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      print('✅ Login response: ${response.data}');
      return response.data['token'] as String;
    } on DioException catch (e) {
      print('❌ DioException en login');
      print('Tipo: ${e.type}');
      print('Mensaje: ${e.message}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Sin respuesta del servidor');
      }
      return null;
    } catch (e, stacktrace) {
      print('❌ Excepción inesperada en login → $e');
      print('Stacktrace: $stacktrace');
      return null;
    }
  }

  static Future<bool> register(String username, String password, String rol) async {
    try {
      final url = '${ApiClient.dio.options.baseUrl}/auth/register';
      print('🔎 Intentando register → URL: $url');
      final response = await ApiClient.dio.post(
        '/auth/register',
        data: {'username': username, 'password': password, 'rol': rol},
      );
      print('✅ Register response: ${response.data}');
      return true;
    } on DioException catch (e) {
      print('❌ DioException en register');
      print('Tipo: ${e.type}');
      print('Mensaje: ${e.message}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Sin respuesta del servidor');
      }
      return false;
    } catch (e, stacktrace) {
      print('❌ Excepción inesperada en register → $e');
      print('Stacktrace: $stacktrace');
      return false;
    }
  }
}
