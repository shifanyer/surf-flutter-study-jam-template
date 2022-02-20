import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

import '../data/chat/models/message.dart';
import '../data/chat/repository/firebase.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  /* Clear the search field */
                },
              ),
              hintText: 'Введите ник',
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
            ),
          ),
        ),
      )),
      body: FutureBuilder<List<ChatMessageDto>>(
          future: widget.chatRepository.messages,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("snapshot.data ${snapshot.data.toString()}");
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: ThemeData.light().backgroundColor,
                        shape: BoxShape.circle
                      ),
                      width: 60,
                      height: 60,
                    ),
                    title: Text(
                      snapshot.data?[index].author.name ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(snapshot.data?[index].message ?? ''),
                    onTap: () {},
                  );
                },
                itemCount: snapshot.data?.length ?? 0,
              );
            } else {
              return const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }
          }),
    );
    throw UnimplementedError();
  }
}
