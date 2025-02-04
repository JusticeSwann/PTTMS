import 'package:flutter/material.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 30,),
                Center(
                  child: DropdownMenu(
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 1, label: 'label')
                    ],
                    leadingIcon: Icon(Icons.location_pin),
                    width: 300,
                    hintText: 'Select route',
                    
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}