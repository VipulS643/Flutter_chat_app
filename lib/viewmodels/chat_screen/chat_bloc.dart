import 'package:chat_app/repository/chat/chat_screen_repository.dart';
import 'package:chat_app/viewmodels/chat_screen/chat_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<FetchMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        final messages = await repository.fetchMessages(event.chatId);
        emit(ChatLoaded(messages));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      emit(MessageSending());
      try {
        await repository.sendMessage(
          chatId: event.chatId,
          senderId: event.senderId,
          content: event.content,
        );
        emit(MessageSent());
        // Refresh messages after sending
        final messages = await repository.fetchMessages(event.chatId);
        emit(ChatLoaded(messages));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
