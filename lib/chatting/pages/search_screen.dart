import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobseeking/chatting/Handlers/chat_provider.dart';
import 'package:jobseeking/chatting/pages/chat_details.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? loggedInUser;
  String searchQuery = '';

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
      print('Logged in user: ${loggedInUser!.email}');
    } else {
      print('No user logged in.');
    }
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Users"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search Users",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: handleSearch,
            ),
          ),
          Expanded(
            child: searchQuery.isEmpty
                ? const Center(
                    child: Text("Start typing to search for users."),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: chatProvider.searchUsers(searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No users found.'));
                      }
                      final users = snapshot.data!.docs;
                      List<UserTile> userWidgets = [];
                      for (var user in users) {
                        final userData = user.data() as Map<String, dynamic>;
                        // print('User data: $userData'); // Debugging
                        if (userData['userId'] != loggedInUser?.uid) {
                          final userWidget = UserTile(
                            userId: userData['userId'] ?? '',
                            username: userData['username'] ?? 'Unknown User',
                            email: userData['email'] ?? 'No Email',
                            profilePicture: userData['profilePicture'] ?? '',
                          );
                          userWidgets.add(userWidget);
                        }
                      }
                      return ListView(children: userWidgets);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String userId;
  final String username;
  final String email;
  final String profilePicture;

  const UserTile({
    super.key,
    required this.userId,
    required this.username,
    required this.email,
    required this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: const Color(0xFF8C68EC),
        backgroundImage: profilePicture.isNotEmpty
            ? NetworkImage(profilePicture)
            : const AssetImage('assets/default_profile_pic.png')
                as ImageProvider,
      ),
      title: Text(username.isEmpty ? 'Unknown User' : username),
      subtitle: Text(email.isEmpty ? 'No Email' : email),
      onTap: () async {
        if (userId.isEmpty) {
          print('Invalid userId'); // Debug null userId
          return;
        }
        // Navigate to chat details or create chat room
        // Uncomment and implement the following lines as needed:
        final chatId = await chatProvider.getChatRoom(userId) ??
            await chatProvider.createChatRoom(userId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetails(
              chatId: chatId,
              receiverId: userId,
            ),
          ),
        );
      },
    );
  }
}
