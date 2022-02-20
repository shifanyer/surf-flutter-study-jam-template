import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

import '../data/chat/models/message.dart';
import '../data/chat/models/user.dart';
import '../data/chat/repository/firebase.dart';
import '../widgets/message_field.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;
  final ChatUserLocalDto localUser;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
    required this.localUser,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController usernameController;
  late ScrollController listViewController;

  @override
  void initState() {
    usernameController = TextEditingController();
    listViewController = ScrollController();
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
            controller: usernameController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    listViewController.animateTo(listViewController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 500), curve: Curves.ease);
                  });
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
                    controller: listViewController,
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (index == (0)) {
                        return const SizedBox(
                          height: 50,
                        );
                      } else {
                        return ListTile(
                          tileColor: (snapshot.data?[index - 1].author.name == widget.localUser.name)
                              ? Colors.yellow.withOpacity(0.2)
                              : ((usernameController.text == snapshot.data?[index - 1].author.name) ? Colors.blue.withOpacity(0.2) : Colors.white),
                          leading: Container(
                            decoration: BoxDecoration(color: ThemeData.light().backgroundColor, shape: BoxShape.circle),
                            width: 60,
                            height: 60,
                            child: FittedBox(
                              child: Text(
                                snapshot.data?[index - 1].author.name[0] ?? 'X',
                                style: const TextStyle(fontSize: 300, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          title: Text(
                            snapshot.data?[index - 1].author.name ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(snapshot.data?[index - 1].message ?? ''),
                          onTap: () {},
                        );
                      }
                    },
                    itemCount: (snapshot.data?.length ?? 0) + 1,
                    dragStartBehavior: DragStartBehavior.down,
                  );
                } else {
                  return const Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 50.0,
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                alignment: Alignment.bottomCenter,
                child: Center(
                    child: MessageField(
                  chatRepository: widget.chatRepository,
                  listViewController: listViewController,
                  localUser: widget.localUser,
                )
                    /*
                  TextField(
                    controller: messageController,
                    autocorrect: false,
                    onTap: () {
                      listViewController.animateTo(listViewController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500), curve: Curves.ease);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.blue,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          await widget.chatRepository.sendMessage(widget.localUser.name, messageController.text);
                          messageController.clear();
                          listViewController.animateTo(listViewController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 500), curve: Curves.ease);
                          setState(() {});
                        },
                      ),
                      hintText: 'Сообщение',
                      hintStyle: TextStyle(fontSize: 20.0, color: Colors.black.withOpacity(0.5)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  */
                    )),
          )
        ],
      ),
    );
  }
}
