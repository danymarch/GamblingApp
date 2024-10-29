import 'package:flutter/material.dart';
import 'homepage.dart';
import 'lotterypage.dart';
import 'workpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slot Machine',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/lottery': (context) => const LotteryPage(),
        '/work': (context) => const WorkPage(),
      },
    );
  }
}
