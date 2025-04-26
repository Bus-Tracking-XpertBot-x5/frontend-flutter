import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/UpdateProfileController.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Utils/GlobalFunctions.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/phone_number.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage>
    with GlobalFunctions {
  final UpdateProfileController controller =
      Get.find<UpdateProfileController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneNumberController;
  PhoneNumber? number;
  @override
  void initState() {
    super.initState();
    final user = controller.authService.globalUser!;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    number = PhoneNumber.fromCompleteNumber(completeNumber: user.phoneNumber);
    phoneNumberController = TextEditingController(text: number!.number);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(),

      bottomNavigationBar: const MyBottomNavbar(),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Obx(
            () => SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    MyHeader(title: 'Update Profile'),
                    const SizedBox(height: 30),

                    // Name Field
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        errorText: controller.fieldErrors['name'],
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        errorText: controller.fieldErrors['email'],
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required";
                        }
                        if (!GetUtils.isEmail(value.trim())) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Phone Field
                    IntlPhoneField(
                      initialValue: number!.completeNumber,
                      initialCountryCode: number?.countryISOCode,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                        errorText: controller.fieldErrors['phone_number'],
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (phone) {
                        phoneNumberController.text = phone.completeNumber;
                        print(phoneNumberController.text);
                      },
                    ),
                    const SizedBox(height: 30),

                    // Update Button
                    ElevatedButton(
                      onPressed: () {
                        if (!controller.isLoading.value &&
                            formKey.currentState!.validate()) {
                          controller.updateProfile(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            phoneNumber: phoneNumberController.text.trim(),
                          );
                        }
                      },
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Update"),
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
