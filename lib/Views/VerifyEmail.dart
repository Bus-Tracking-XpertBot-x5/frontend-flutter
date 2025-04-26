import 'package:buslink_flutter/Controllers/VerifyEmailController.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Utils/GlobalFunctions.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with GlobalFunctions {
  final formKey = GlobalKey<FormState>();
  final VerifyEmailController _verifyEmailController = VerifyEmailController();

  late final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Adjust horizontal padding
            vertical: screenHeight * 0.02, // Adjust vertical padding
          ),
          child: Obx(
            () => SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Text
                    const SizedBox(height: 12),
                    Text(
                      "Verification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05, // Responsive spacing
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        radius: 60, // Adjust radius as needed
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.lock,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.06, // Responsive spacing
                    ),
                    // Name TextFormField
                    TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: "Enter Verification Code",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        errorText: _verifyEmailController.fieldErrors['otp'],
                        // Show full name error
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // VerifyEmail Button
                    ElevatedButton(
                      onPressed: () {
                        if (!_verifyEmailController.isLoading.value &&
                            formKey.currentState!.validate()) {
                          _verifyEmailController.veriyfEmailUser(
                            otpController.text.trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        textStyle: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      child:
                          _verifyEmailController.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Submit"),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Already have an account? Text Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't recieve an SMS? "),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Resend.",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
