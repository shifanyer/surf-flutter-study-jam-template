import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/chat/models/user.dart';
import '../data/chat/repository/repository.dart';

class MessageField extends StatefulWidget {
  final ScrollController listViewController;
  final ChatRepository chatRepository;
  final ChatUserLocalDto localUser;

  const MessageField({Key? key, required this.listViewController, required this.chatRepository, required this.localUser}) : super(key: key);

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  late TextEditingController messageController;
  bool isPause = false;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: messageController,
      autocorrect: false,
      decoration: InputDecoration(
        fillColor: Colors.blue,
        suffixIcon: isPause
            ? const SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  isPause = true;
                  setState(() {});
                  var messageText = messageController.text;
                  messageController.clear();
                  await widget.chatRepository.sendMessage(widget.localUser.name, messageText).then((_) => isPause = false);
                  setState(() {});
                },
              ),
        hintText: 'Сообщение',
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.black.withOpacity(0.5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
        ),
      ),
    );
  }
}
