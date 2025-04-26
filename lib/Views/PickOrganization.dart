import 'package:buslink_flutter/Models/OrganizationModel.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/PickOrganizationController.dart';

class PickOrganizationPage extends StatefulWidget {
  const PickOrganizationPage({super.key});

  @override
  State<PickOrganizationPage> createState() => _PickOrganizationPageState();
}

class _PickOrganizationPageState extends State<PickOrganizationPage> {
  final AuthService _authService = Get.find<AuthService>();

  final PickOrganizationController controller =
      Get.find<PickOrganizationController>();
  int selectedOrganization = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getAllOrganizations();
    setState(() {});
  }

  // ... Keep all previous imports and class declarations

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
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(screenWidth),

              // Current Organization Card
              if (_authService.globalUser!.organization != null) ...[
                _buildCurrentOrganizationCard(
                  context,
                  _authService.globalUser!.organization!,
                  screenWidth,
                ),
                const SizedBox(height: 16),
                const Divider(thickness: 1.5),
                const SizedBox(height: 16),
              ],

              // Organization List
              Expanded(
                child: _buildOrganizationList(screenWidth, screenHeight),
              ),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Organization",
          style: TextStyle(
            fontSize: screenWidth * 0.065,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose your organization from the list below',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCurrentOrganizationCard(
    BuildContext context,
    OrganizationModel organization,
    double screenWidth,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.business_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Organization',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    organization.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (organization.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      organization.description!,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationList(double screenWidth, double screenHeight) {
    return Obx(
      () =>
          controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: controller.organizations.length,
                itemBuilder: (context, index) {
                  final organization = controller.organizations[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.005,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1,
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: selectedOrganization,
                      onChanged:
                          (value) =>
                              setState(() => selectedOrganization = value!),
                      title: Text(
                        organization.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle:
                          organization.description != null
                              ? Text(
                                organization.description!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                              : null,
                      secondary: Icon(
                        Icons.business_rounded,
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.6),
                      ),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed:
                controller.isLoading.value
                    ? null
                    : () async {
                      await controller.submitSelection(
                        organizationId:
                            controller.organizations[selectedOrganization].id,
                      );

                      setState(() {});
                    },

            child:
                controller.isLoading.value
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      "Confirm Selection",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
