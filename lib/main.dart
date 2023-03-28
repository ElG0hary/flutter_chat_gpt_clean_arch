import 'package:chatgptwizzard/core/constants/colors.dart';
import 'package:chatgptwizzard/presentation/provider/chat_provider.dart';
import 'package:chatgptwizzard/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatgpt Wizzard',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
