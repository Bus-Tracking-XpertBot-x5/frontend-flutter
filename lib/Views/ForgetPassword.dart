import 'package:buslink_flutter/Widgets/BusLinkLogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/AuthController.dart';
import 'package:buslink_flutter/Utils/GlobalFunctions.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>
    with GlobalFunctions {
  var isLoading = false.obs;
  final authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  late final TextEditingController emailController = TextEditingController();

  Future<void> _submitForm() async {}

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Primary color background
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white, // Icon color set to white
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: BusLinkLogo(),
        centerTitle: true,
      ),
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
                      "Forget Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        'An email will be sent for you to reset password.',
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05, // Responsive spacing
                    ),
                    // Name TextFormField
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        prefixIcon: const Icon(Icons.email),
                        border: const OutlineInputBorder(),
                        errorText: authController.fieldErrors['full_name'],
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
                    // ForgetPasswordPage Button
                    ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('enable-gps');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        textStyle: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      child:
                          isLoading.value
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
                        Text(
                          "Didn't recieve an email? ",
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
                          ),
                        ),
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
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  screenWidth * 0.045, // Responsive font size
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
