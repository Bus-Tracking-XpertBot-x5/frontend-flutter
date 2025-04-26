import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({super.key});

  @override
  State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return AnimatedOpacity(
      opacity: isKeyboardOpen ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child:
          isKeyboardOpen
              ? SizedBox.shrink() // Hide FAB when keyboard is open
              : FloatingActionButton(
                onPressed: () {
                  Get.offAllNamed('/busLocations');
                },
                tooltip: 'Live Location',
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                shape: CircleBorder(),
                child: Icon(Icons.place_rounded, size: 30),
              ),
    );
  }
}
