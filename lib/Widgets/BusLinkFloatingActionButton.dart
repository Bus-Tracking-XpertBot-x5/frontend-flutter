import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusLinkFloatingActionButton extends StatefulWidget {
  const BusLinkFloatingActionButton({super.key});

  @override
  State<BusLinkFloatingActionButton> createState() =>
      _BusLinkFloatingActionButtonState();
}

class _BusLinkFloatingActionButtonState
    extends State<BusLinkFloatingActionButton> {
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
                  Get.toNamed('/live map location');
                },
                tooltip: 'Live Location',
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                foregroundColor: Colors.white,
                shape: CircleBorder(),
                child: Icon(Icons.place_rounded, size: 30),
              ),
    );
  }
}
