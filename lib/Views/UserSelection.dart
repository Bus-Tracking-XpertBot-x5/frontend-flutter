import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSelectionPage extends StatelessWidget {
  const UserSelectionPage({super.key});

  // Function to launch WhatsApp or Email
  void _contactAdmin() async {
    const String adminWhatsApp =
        "https://wa.me/96171595345"; // Replace with actual number

    await launchUrl(
      Uri.parse(adminWhatsApp),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08, // Adjusted horizontal padding
            vertical: screenHeight * 0.05, // Adjusted vertical padding
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    'images/contact-us.png',
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                ),
              ),
              Text(
                "Welcome to BusLink",
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),

              // Continue as Passenger Button
              ElevatedButton(
                onPressed:
                    () => Get.toNamed(
                      '/enableGpsLocation',
                    ), // Replace with actual route
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, screenHeight * 0.07),
                  textStyle: TextStyle(fontSize: screenWidth * 0.045),
                ),
                child: const Text("Continue as Passenger"),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Register as Organization Button
              OutlinedButton(
                onPressed: _contactAdmin,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, screenHeight * 0.07),
                  textStyle: TextStyle(fontSize: screenWidth * 0.045),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Text(
                  "Register as Organization",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Info Text
              Text(
                "For organization registration, contact our admin via WhatsApp.",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
