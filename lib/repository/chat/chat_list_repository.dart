import 'package:dio/dio.dart';

class ChatListRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://45.129.87.38:6065",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<List<dynamic>> fetchChatList(String userId) async {
    try {
      final response = await _dio.get("/chats/user-chats/$userId");

      print("Chat List Response: ${response.data}");

      if (response.data is List) {
        return response.data;
      } else {
        throw Exception("Chat list is not a list");
      }
    } on DioException catch (e) {
      print("Chat list error: ${e.message}");

      if (e.response != null) {
        throw Exception(
          e.response?.data?["message"] ?? "Failed to load chat list",
        );
      } else {
        throw Exception("Network error fetching chat list");
      }
    }
  }
}
