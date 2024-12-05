import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jobseeking/auth/Handlers/auth_provider.dart';
import 'package:jobseeking/auth/pages/login.dart';
import 'package:jobseeking/chatting/Handlers/chat_provider.dart';
import 'package:jobseeking/chatting/Handlers/user_provider.dart';
import 'package:jobseeking/chatting/pages/chats.dart';
import 'package:jobseeking/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => AuthsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthsProvider>(
      builder: (context, authProvider, child) {
        return authProvider.isSignedIn ? Chats() : Login();
      },
    );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePage();
// }

// class _HomePage extends State<HomePage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         print('============User is currently signed out! =============');
//       } else {
//         print('============ User is signed in! ===========');
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 350),
//             child: Center(
//               child: Container(
//                 width: 300,
//                 height: 200,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.cyan,
//                     image: DecorationImage(
//                         image: AssetImage("assets/images/background.png"),
//                         fit: BoxFit.cover)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(
//                       'Welcome to Firebase Authentication',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: const Color.fromARGB(255, 255, 255, 255)),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         TextButton(
//                             onPressed: () => {
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                       builder: (context) => Login()))
//                                 },
//                             child: Text(
//                               'login',
//                               style: TextStyle(color: Colors.white),
//                             )),
//                         TextButton(
//                             onPressed: () => {
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                       builder: (context) => Signup()))
//                                 },
//                             child: Text('signUp',
//                                 style: TextStyle(color: Colors.white)))
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
// }
