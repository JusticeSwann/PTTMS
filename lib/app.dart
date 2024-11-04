import 'package:flutter/material.dart';
import 'screens/routes/views/routes_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RoutesPage(),
    );
  }
}
