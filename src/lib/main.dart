// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:blog/views/main_screens/tab_bar_screen.dart';
import 'package:blog/views/startup_screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF19B26B),
        accentColor: Color(0xFF19B26B),
        backgroundColor: Colors.grey[50],
      ),
      home: LoginScreen(),
    );
  }
}
