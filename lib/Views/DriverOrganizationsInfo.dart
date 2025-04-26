import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:buslink_flutter/Widgets/MyOrganizationCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/DriverOrganizationsInfoController.dart';

class DriverOrganizationsInfoPage extends StatefulWidget {
  const DriverOrganizationsInfoPage({super.key});

  @override
  State<DriverOrganizationsInfoPage> createState() =>
      _DriverOrganizationsInfoPageState();
}

class _DriverOrganizationsInfoPageState
    extends State<DriverOrganizationsInfoPage> {
  final DriverOrganizationsInfoController controller =
      Get.find<DriverOrganizationsInfoController>();

  @override
  void initState() {
    super.initState();
    controller.getDriverOrganizations();
  }

  Future<void> _refreshOrganizations() async {
    await controller.getDriverOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
      bottomNavigationBar: MyBottomNavbar(),
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
              MyHeader(title: 'My Organizations'),
              const SizedBox(height: 20),
              // Organization List with Refresh Indicator
              Expanded(
                child: Obx(
                  () =>
                      controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                            onRefresh: _refreshOrganizations,
                            child:
                                controller.organizations.isEmpty
                                    ? ListView(
                                      children: const [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text('No results found.'),
                                          ),
                                        ),
                                      ],
                                    )
                                    : ListView.builder(
                                      itemCount:
                                          controller.organizations.length,
                                      itemBuilder: (context, index) {
                                        final organization =
                                            controller.organizations[index];
                                        return MyOrganizationCard(
                                          organization: organization,
                                        );
                                      },
                                    ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
