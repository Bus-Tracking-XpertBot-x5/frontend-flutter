import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:buslink_flutter/Utils/GlobalFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyChatButton extends StatelessWidget with GlobalFunctions {
  const MyChatButton({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.message, size: 16),
      tooltip: 'Chat on WhatsApp',
      onPressed: () async {
        if (phoneNumber.isNotEmpty) {
          await openWhatsApp(phoneNumber);
        } else {
          AppDialog.showError("Error Opening Whatsapp!");
        }
      },
    );
  }
}
