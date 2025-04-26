import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:buslink_flutter/Utils/Theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

mixin GlobalFunctions {
  void showLoadingDialog() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void closeLoadingDialog() {
    print(Get.isDialogOpen);
    if (Get.isDialogOpen! == true) {
      Get.back();
    }
  }

  Future<void> openWhatsApp(String phone) async {
    // Format the WhatsApp URL using the driver's phone number and a default message.
    try {
      final whatsappUrl = Uri.parse(
        'https://api.whatsapp.com/send?phone=$phone&text=Hello from Bus Link',
      );
      // Check if WhatsApp can be launched and, if so, launch it.
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        Get.snackbar(
          'Error',
          'WhatsApp is not available on this device',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      AppDialog.showError(e.toString());
    }
  }
}
