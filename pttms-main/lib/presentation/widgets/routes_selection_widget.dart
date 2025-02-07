import 'package:flutter/material.dart';


class RoutesSelectionWidget extends StatefulWidget {
  const RoutesSelectionWidget({super.key});

  @override
  State<RoutesSelectionWidget> createState() => _RoutesSelectionWidgetState();
}


class _RoutesSelectionWidgetState extends State<RoutesSelectionWidget> {
  final List<bool> _isSelected = [true,false,false];
  int? _selectedIndex;

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
              ToggleButtons(
                isSelected:  _isSelected,
                borderRadius: BorderRadius.circular(40),
                onPressed: (int index) {
                  setState(() {
                    if (_selectedIndex == index) {
                      _selectedIndex = null;
                      _isSelected[index] = false;
                    } else {
                      _selectedIndex = index;
                      // Reset all selections to false first
                      for (int i = 0; i < _isSelected.length; i++) {
                        _isSelected[i] = false;
                      }
                      _isSelected[index] = true;
                    }
                  });
                },
                fillColor: Colors.transparent,
                selectedColor: Colors.red,
                highlightColor: Colors.transparent,
                borderColor: Colors.transparent,
                selectedBorderColor: Colors.transparent,
                children: const [
                  Icon(Icons.directions_bus,size: 35,),
                  SizedBox(width: 20,),
                  Icon(Icons.directions_bus_outlined, size: 35,),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
