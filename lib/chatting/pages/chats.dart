import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobseeking/auth/Handlers/auth_provider.dart';
import 'package:jobseeking/chatting/Handlers/chat_provider.dart';
// import 'package:jobseeking/chatting/Handlers/user_provider.dart';
import 'package:jobseeking/chatting/pages/search_screen.dart';
import 'package:jobseeking/utilities/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:jobseeking/utilities/widgets/chat_tile.dart';
import 'package:provider/provider.dart';

// import 'chat_details.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchChatData(String chatId) async {
    final chatDoc =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data();
    final users = chatData!['users'] as List<dynamic>;
    final receiverId =
        users.firstWhere((userId) => userId != loggedInUser!.uid);
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    final userData = userDoc.data();
    return {
      'chatId': chatId,
      'lastMessage': chatData['lastMessage'] ?? '',
      'timestamp': chatData['timestamp']?.toDate() ?? DateTime.now(),
      'userData': userData,
    };
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    final authProvider = Provider.of<AuthsProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        backgroundColor: Colors.white,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          // ElevatedButton(
          //   onPressed: () async {
          //     // await userProvider.fetchUsers();
          //   },
          //   child: Text('Fetch Users'),
          // ),

          IconButton(
              onPressed: () async {
                final result = chatProvider.getChats(loggedInUser!.uid);
                print('======================================');
                print(loggedInUser!.uid);
                print('======================================');
                await authProvider.signout(context);
              },
              icon: Icon(
                Icons.logout,
                color: Color(0xFF3E8DF3),
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: chatProvider.getChats(loggedInUser!.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      // print('=================');
                      // print(snapshot.hasData);
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final chatDocs = snapshot.data!.docs;
                    // print('===============');
                    // print(chatDocs);
                    // print('===============');
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: Future.wait(chatDocs
                          .map((chatDoc) => _fetchChatData(chatDoc.id))),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          print('===========');
                          print(snapshot.hasData);
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final chatDataList = snapshot.data!;
                        print('=============== chatDataList===========');
                        print(chatDataList);
                        print('===============');
                        return SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              const CustomHeading(
                                title: 'Groups',
                              ),
                              Container(
                                height: 150,
                                child: ListView.builder(
                                  itemCount: chatDataList.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.all(15),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          width: 90,
                                          height: 90,
                                          margin:
                                              const EdgeInsets.only(right: 15),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomRight,
                                              stops: [0.1, 1],
                                              colors: [
                                                Color(0xFF8C68EC),
                                                Color(0xFF3E8DF3),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(
                                            Icons.chat,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text('Group Name'),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const CustomHeading(
                                title: 'Direct Messages',
                              ),
                              ListView.builder(
                                itemCount: chatDataList.length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final chatData = chatDataList[index];
                                  return ChatTile(
                                      chatId: chatData['chatId'],
                                      lastMessage: chatData['lastMessage'],
                                      timestamp: chatData['timestamp'],
                                      receiverData: chatData['userData']);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF8C68EC),
        child: Icon(
          Icons.search,
          color: Color(0xFF8C68EC),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}
