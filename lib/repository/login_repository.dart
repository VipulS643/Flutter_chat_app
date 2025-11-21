import 'package:dio/dio.dart';

class LoginRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://45.129.87.38:6065",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<Map<String, dynamic>> login(
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await _dio.post(
        "/user/login",
        data: {"email": email, "password": password, "role": role},
      );
      print("responseeeeeeeeeeeeee: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      print("Login errorrrrrrrrrrrrrr: ${e.message}");
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data?["message"] ?? "Login failed",
        };
      } else {
        return {
          "success": false,
          "message": "Network error. Check your internet connection.",
        };
      }
    } catch (_) {
      return {"success": false, "message": "Something went wrong"};
    }
  }
}
