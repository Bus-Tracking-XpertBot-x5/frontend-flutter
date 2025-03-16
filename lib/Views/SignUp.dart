import 'package:buslink_flutter/Widgets/BusLinkLogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/AuthController.dart';
import 'package:buslink_flutter/Utils/GlobalFunctions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with GlobalFunctions {
  var isLoading = false.obs;
  final authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  late final TextEditingController fullNameController = TextEditingController();
  late final TextEditingController phoneNumberController =
      TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController passwordConfirmationController =
      TextEditingController();

  Future<void> _submitForm() async {
    if (isLoading.value) return;

    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    isLoading = true.obs;
    final isSuccess = await authController.signUp(
      fullNameController.text.trim(),
      phoneNumberController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      passwordConfirmationController.text.trim(),
    );
    isLoading = false.obs;
    if (isSuccess) {
      Get.toNamed('home');
    }
  }

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
                      "Create an Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05, // Responsive spacing
                    ),
                    // Name TextFormField
                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        errorText: authController.fieldErrors['full_name'],
                        // Show full name error
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Username TextFormField
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                        border: const OutlineInputBorder(),
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
                    // Email TextFormField
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: const OutlineInputBorder(),
                        errorText:
                            authController
                                .fieldErrors['email'], // Show email error
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (!GetUtils.isEmail(value)) {
                          return "Invalid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Password TextFormField
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        errorText: authController.fieldErrors['password'],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        if (passwordConfirmationController.text
                                .trim()
                                .isNotEmpty &&
                            value !=
                                passwordConfirmationController.text.trim()) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Password Confirmation TextFormField
                    TextFormField(
                      controller: passwordConfirmationController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        errorText:
                            authController.fieldErrors['password_confirmation'],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Get.toNamed('user-selection');
                          },
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Signup Button
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('verify-sms');
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
                              : const Text("Sign Up"),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Already have an account? Text Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
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
                            Get.toNamed('/sign-in');
                          },
                          child: Text(
                            "Login",
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
