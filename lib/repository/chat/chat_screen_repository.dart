import 'package:dio/dio.dart';

class ChatRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://45.129.87.38:6065",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  // Fetch chat messages for a chatId
  Future<List<dynamic>> fetchMessages(String chatId) async {
    try {
      final response = await _dio.get(
        "/messages/get-messagesformobile/$chatId",
      );
      print("responseeeeeeeee $response");
      if (response.data is List) {
        return response.data;
      } else {
        throw Exception("Invalid chat messages format");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? "Failed to fetch chat messages",
      );
    }
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = "text",
    String fileUrl = "",
  }) async {
    try {
      final body = {
        "chatId": chatId,
        "senderId": senderId,
        "content": content,
        "messageType": messageType,
        "fileUrl": fileUrl,
      };

      await _dio.post("/messages/sendMessage", data: body);
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? "Failed to send message");
    }
  }
}
