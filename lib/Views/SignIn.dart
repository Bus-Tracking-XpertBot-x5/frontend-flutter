import 'package:buslink_flutter/Widgets/BusLinkLogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/AuthController.dart';
import 'package:buslink_flutter/Utils/GlobalFunctions.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with GlobalFunctions {
  var isLoading = false.obs;
  final authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  late final TextEditingController phoneNumberController =
      TextEditingController();
  late final TextEditingController passwordController = TextEditingController();

  // Future<void> _submitForm() async {
  //   if (isLoading.value) return;
  //   final isValid = formKey.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   isLoading = true.obs;
  //   final isSuccess = await authController.signUp(
  //     phoneNumberController.text.trim(),
  //     passwordController.text.trim()
  //   );
  //   isLoading = false.obs;
  //   if (isSuccess) {
  //     Get.toNamed('home');
  //   }
  // }

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
              icon: Icon(
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
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05, // Responsive spacing
                    ),
                    // Phone Number
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        errorText: authController.fieldErrors['phone_number'],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Password
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        errorText: authController.fieldErrors['password'],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // TextButton(
                        //   style: TextButton.styleFrom(
                        //     padding: EdgeInsets.zero,
                        //     minimumSize: Size(0, 0),
                        //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //   ),
                        //   onPressed: () {
                        //     print("Forget Password?");
                        //   },
                        //   child: Text(
                        //     "Forget Password?",
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize:
                        //           screenWidth * 0.04, // Responsive font size
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Signup Button
                    ElevatedButton(
                      onPressed: () {
                        // _submitForm();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        textStyle: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      child:
                          isLoading.value
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : Text("Sign Up"),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Already have an account? Text Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
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
                          onPressed: () {
                            Get.toNamed('/sign-up');
                          },
                          child: Text(
                            "Sign Up",
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
