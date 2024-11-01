import 'package:flutter/material.dart';
import 'package:pttms/screens/map/views/map_page.dart';
import 'package:pttms/screens/routes/views/routes_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const  MaterialApp(
      home: MapPage(),
    );
  }
}