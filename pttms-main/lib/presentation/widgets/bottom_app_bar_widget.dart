import 'package:flutter/material.dart';

class BottomAppBarWidget extends StatefulWidget {
  const BottomAppBarWidget({super.key});

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return const BottomAppBar(
      child: Text('test')
    );
  }
}