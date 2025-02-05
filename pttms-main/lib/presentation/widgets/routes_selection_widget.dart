import 'package:flutter/material.dart';

class RoutesSelectionWidget extends StatelessWidget {
  const RoutesSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DropdownMenu(
          dropdownMenuEntries: [
            DropdownMenuEntry(value: 1, label: 'label')
          ],
          leadingIcon: Icon(Icons.location_pin),
          width: 300,
          hintText: 'Select route',
        ),
        Padding(
          padding: const  EdgeInsets.symmetric(
            horizontal: 100,
            vertical: 7,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: IconButton.outlined(
                onPressed: () {
                  
                },
                icon: const Icon(Icons.bus_alert),
              )),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(child: IconButton.outlined(
                onPressed: () {
                  
                },
                icon: const Icon(Icons.bus_alert),
                
              )),
            ],
          ),
        ),
      ],
    );
  }
}
