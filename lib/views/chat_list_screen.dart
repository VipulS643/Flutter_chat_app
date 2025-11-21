import 'package:chat_app/repository/chat/chat_screen_repository.dart';
import 'package:chat_app/viewmodels/chat_screen/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/chat_list/chat_list_bloc.dart';
import '../viewmodels/chat_list/chat_list_event.dart';
import '../viewmodels/chat_list/chat_list_state.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final String userId;

  ChatListScreen({required this.userId});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatListBloc>().add(FetchChatList(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f7fa),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatListError) {
            return Center(
              child: Text(state.message, style: const TextStyle(fontSize: 16)),
            );
          }

          if (state is ChatListLoaded) {
            if (state.chats.isEmpty) {
              return const Center(
                child: Text("No chats found", style: TextStyle(fontSize: 16)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                final participants = (chat["participants"] as List)
                    .where((p) => p is Map<String, dynamic>)
                    .toList();

                if (participants.isEmpty) {
                  return _unknownUserTile();
                }

                final otherUser = participants.firstWhere(
                  (p) => p["_id"] != widget.userId,
                  orElse: () => {},
                );

                if (otherUser == null || otherUser.isEmpty) {
                  return _unknownUserTile();
                }

                final profilePath = otherUser["profile"];
                final username = otherUser["name"] ?? "Unknown User";

                final lastMessage = chat["lastMessage"];
                final lastMessageText = lastMessage is Map
                    ? (lastMessage["content"] ?? "No messages")
                    : "No messages";

                final chatId = chat["_id"];
                final receiverId = otherUser["_id"];
                final updatedAt = chat["updatedAt"] ?? "";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => ChatBloc(ChatRepository()),
                          child: ChatScreen(
                            chatId: chatId,
                            userId: widget.userId,
                            receiverId: receiverId,
                            username: username,
                            profileUrl: profilePath,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                          color: Colors.black12.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage:
                                  (profilePath != null &&
                                      profilePath.isNotEmpty)
                                  ? NetworkImage(profilePath)
                                  : null,
                              child:
                                  (profilePath == null || profilePath.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            // Online dot
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: otherUser["isOnline"] == true
                                      ? Colors.green
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lastMessageText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          updatedAt.toString().split("T").first,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _unknownUserTile() {
    return ListTile(
      title: const Text("Unknown User"),
      subtitle: const Text("Unable to load chat"),
      leading: const CircleAvatar(child: Icon(Icons.person)),
    );
  }
}
