import 'package:flutter/material.dart';
import 'package:mixmate_mobile/fetching_api_page.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        "/recommendation": (context) => const FetchingApiPage(),
      },
    );
  }
}
