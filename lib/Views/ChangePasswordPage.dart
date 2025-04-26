import 'package:buslink_flutter/Controllers/ChangePasswordController.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ChangePasswordController _controller =
      Get.find<ChangePasswordController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: screenHeight * 0.02,
          ),
          child: Obx(
            () => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const MyHeader(title: 'Change Password'),
                  const SizedBox(height: 32),

                  // Old Password
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Old Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      errorText: _controller.fieldErrors['old_password'],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Old password is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // New Password
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: const Icon(Icons.lock),
                      errorText: _controller.fieldErrors['new_password'],
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "New password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      errorText: _controller.fieldErrors['confirm_password'],
                    ),
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () {
                      if (!_controller.isLoading.value &&
                          _formKey.currentState!.validate()) {
                        _controller.changePassword(
                          oldPassword: oldPasswordController.text.trim(),
                          newPassword: newPasswordController.text.trim(),
                          confirmPassword:
                              confirmPasswordController.text.trim(),
                        );
                      }
                    },
                    child:
                        _controller.isLoading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : const Text("Update Password"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
