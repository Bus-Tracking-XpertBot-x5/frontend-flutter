import 'package:buslink_flutter/Widgets/BusLinkBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/BusLinkFloatingActionButton.dart';
import 'package:buslink_flutter/Widgets/BusLinkLogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerDashboard extends StatelessWidget {
  const PassengerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: BusLinkFloatingActionButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: BusLinkBottomNavbar(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: BusLinkLogo(),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Get.toNamed('/notifications');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            _buildInfoCard(
              context,
              icon: Icons.directions_bus,
              title: "Next Bus ETA",
              subtitle: "Arriving in 5 mins at Stop #12",
              color: Colors.blue,
            ),
            _buildInfoCard(
              context,
              icon: Icons.location_on,
              title: "Current Location",
              subtitle: "Downtown Station, Stop #8",
              color: Colors.red,
            ),
            _buildInfoCard(
              context,
              icon: Icons.map,
              title: "Bus Route",
              subtitle: "Route 23: Downtown → Central Park",
              color: Colors.green,
            ),
            _buildInfoCard(
              context,
              icon: Icons.info,
              title: "Bus Status",
              subtitle: "On Time - Expected Arrival: 10:30 AM",
              color: Colors.orange,
            ),
            _buildInfoCard(
              context,
              icon: Icons.announcement,
              title: "Announcements",
              subtitle: "Bus fares will increase by 5% next month.",
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white, // Background color
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          radius: 24,
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).primaryColor, // Primary text color
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700], // Secondary text color
          ),
        ),
      ),
    );
  }
}
