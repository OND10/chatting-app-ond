import 'package:flutter/material.dart';
import 'package:jobseeking/chatting/pages/chat_details.dart';

class ChatTile extends StatelessWidget {
  final String chatId;
  final String lastMessage;
  final DateTime timestamp;
  final Map<String, dynamic> receiverData;

  const ChatTile(
      {super.key,
      required this.chatId,
      required this.lastMessage,
      required this.timestamp,
      required this.receiverData});

  @override
  Widget build(BuildContext context) {
    return lastMessage != ""
        ? ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFF8C68EC),
            ),
            title: Text(receiverData['username']),
            subtitle: Text(lastMessage, maxLines: 2),
            trailing: Text(
              '${timestamp.hour} : ${timestamp.minute}',
              style: TextStyle(fontSize: 12, color: Colors.lightBlue),
            ),
            onTap: () {
              final receiverId = receiverData['userId'];
              if (receiverId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetails(
                      chatId: chatId,
                      receiverId: receiverId,
                    ),
                  ),
                );
              } else {
                print('Receiver ID is null for chatId: $chatId');
              }
            },
          )
        : Container();
  }
}
