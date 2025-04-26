import 'package:buslink_flutter/Controllers/DriverBusInfoController.dart';
import 'package:buslink_flutter/Models/BusModel.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyBusCard.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverBusInfoPage extends StatefulWidget {
  const DriverBusInfoPage({super.key});

  @override
  State<DriverBusInfoPage> createState() => _DriverBusInfoPageState();
}

class _DriverBusInfoPageState extends State<DriverBusInfoPage> {
  final DriverBusInfoController _controller =
      Get.find<DriverBusInfoController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.fetchBuses();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: MyAppBar(),

      bottomNavigationBar: const MyBottomNavbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: screenHeight * 0.02,
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [MyHeader(title: "My Buses"), _buildBody(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: _controller.fetchBuses,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          itemCount: _controller.buses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder:
              (context, index) => MyBusCard(bus: _controller.buses[index]),
        ),
      ),
    );
  }
}
