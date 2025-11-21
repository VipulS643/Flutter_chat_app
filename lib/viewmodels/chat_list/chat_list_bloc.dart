import 'package:chat_app/repository/chat/chat_list_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatListRepository repository;

  ChatListBloc(this.repository) : super(ChatListInitial()) {
    on<FetchChatList>((event, emit) async {
      emit(ChatListLoading());

      try {
        final chatList = await repository.fetchChatList(event.userId);
        emit(ChatListLoaded(chatList));
      } catch (e) {
        emit(ChatListError(e.toString()));
      }
    });
  }
}
