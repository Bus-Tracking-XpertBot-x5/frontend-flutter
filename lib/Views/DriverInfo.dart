import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/DriverInfoController.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Utils/GlobalFunctions.dart';

class DriverInfoPage extends StatefulWidget {
  const DriverInfoPage({super.key});

  @override
  State<DriverInfoPage> createState() => _DriverInfoPageState();
}

class _DriverInfoPageState extends State<DriverInfoPage> with GlobalFunctions {
  final DriverInfoController controller = Get.find<DriverInfoController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController licenseNumberController;

  @override
  void initState() {
    super.initState();
    // Assume that the user model now has a 'licenseNumber' property.
    final driver = controller.driverService.globalDriver!;
    licenseNumberController = TextEditingController(text: driver.licenseNumber);
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
                    MyHeader(title: 'Update License Number'),
                    const SizedBox(height: 30),

                    // License Number Field
                    TextFormField(
                      controller: licenseNumberController,
                      decoration: InputDecoration(
                        labelText: "License Number",
                        prefixIcon: const Icon(Icons.confirmation_number),
                        errorText: controller.fieldErrors['license_number'],
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "License number is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Update Button
                    ElevatedButton(
                      onPressed: () {
                        if (!controller.isLoading.value &&
                            formKey.currentState!.validate()) {
                          controller.updateDriverInfo(
                            licenseNumber: licenseNumberController.text.trim(),
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
