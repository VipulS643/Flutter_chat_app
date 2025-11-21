abstract class ChatEvent {}

class FetchMessages extends ChatEvent {
  final String chatId;

  FetchMessages(this.chatId);
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String fileUrl;

  SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.content,
    this.messageType = "text",
    this.fileUrl = "",
  });
}
