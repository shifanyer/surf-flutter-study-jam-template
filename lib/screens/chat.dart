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
  late TextEditingController messageController;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

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
                  setState(() {});
                },
              ),
              hintText: 'Введите ник',
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
            ),
          ),
        ),
      )),
      body: Stack(
        children: [
          FutureBuilder<List<ChatMessageDto>>(
              future: widget.chatRepository.messages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      if (index == (snapshot.data?.length ?? 0)) {
                        return const SizedBox(
                          height: 50,
                        );
                      }
                      return ListTile(
                        leading: Container(
                          decoration: BoxDecoration(color: ThemeData.light().backgroundColor, shape: BoxShape.circle),
                          width: 60,
                          height: 60,
                          child: FittedBox(
                            child: Text(
                              snapshot.data?[index].author.name[0] ?? 'X',
                              style: const TextStyle(fontSize: 300, fontWeight: FontWeight.bold),
                            ),
                          ),
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
                    itemCount: snapshot.data?.length ?? 0 + 1,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Center(
                      child: TextField(
                        controller: messageController,
                        autocorrect: false,
                        decoration: InputDecoration(
                          fillColor: Colors.blue,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              widget.chatRepository.sendMessage('Vano', messageController.text);
                              setState(() {
                                messageController.clear();
                              });
                            },
                          ),
                          hintText: 'Сообщение',
                          hintStyle: TextStyle(fontSize: 20.0, color: Colors.black.withOpacity(0.5)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
    throw UnimplementedError();
  }
}
