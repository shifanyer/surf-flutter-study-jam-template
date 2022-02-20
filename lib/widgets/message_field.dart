import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:surf_practice_chat_flutter/data/chat/chat.dart';

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
        prefixIcon: IconButton(
          icon: Icon(
            Icons.share_location_outlined,
            color: ThemeData.light().primaryColor,
          ),
          onPressed: () async {
            Location location = Location();

            bool _serviceEnabled;
            PermissionStatus _permissionGranted;
            LocationData _locationData;

            _serviceEnabled = await location.serviceEnabled();
            if (!_serviceEnabled) {
              _serviceEnabled = await location.requestService();
              if (!_serviceEnabled) {
                return;
              }
            }

            _permissionGranted = await location.hasPermission();
            if (_permissionGranted == PermissionStatus.denied) {
              _permissionGranted = await location.requestPermission();
              if (_permissionGranted != PermissionStatus.granted) {
                return;
              }
            }

            _locationData = await location.getLocation();
            print('_locationData: ${_locationData.latitude} ${_locationData.longitude}');
            // widget.chatRepository.sendGeolocationMessage(
            //     nickname: widget.localUser.name,
            //     location: ChatGeolocationDto(latitude: _locationData.latitude!, longitude: _locationData.longitude!), message: 'my geolocation');
          },
        ),
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
