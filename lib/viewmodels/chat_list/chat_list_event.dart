abstract class ChatListEvent {}

class FetchChatList extends ChatListEvent {
  final String userId;

  FetchChatList(this.userId);
}
