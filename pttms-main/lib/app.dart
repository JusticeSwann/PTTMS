import 'package:flutter/material.dart';
import 'package:pttms/presentation/widgets/bottom_navbar_widget.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child:  Center(
              child: Text('Home'),
            ),
          )
        ),
        bottomNavigationBar:  BottomNavBarWidget()
      ),
    );
  }
}
