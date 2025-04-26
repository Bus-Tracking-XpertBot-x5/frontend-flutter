import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerDashboardPage extends StatelessWidget {
  const PassengerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildHeader(context),
              SizedBox(height: screenHeight * 0.02),
              _buildServiceGrid(context),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02),
                child: Text(
                  "Passenger Dasbhoard",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildInfoCard(
                context,
                icon: Icons.departure_board,
                title: "Next Departure",
                subtitle: "Route 23 to Central Park",
                meta: "8:15 AM · Stop #12",
                color: Colors.blue[600]!,
              ),
              _buildInfoCard(
                context,
                icon: Icons.timelapse,
                title: "Current Journey",
                subtitle: "Downtown Station",
                meta: "On time · 5 mins ETA",
                color: Colors.green[600]!,
              ),
              _buildInfoCard(
                context,
                icon: Icons.assignment,
                title: "Travel Updates",
                subtitle: "No disruptions reported",
                meta: "Last updated: 8:00 AM",
                color: Colors.orange[600]!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good Morning, Lisa",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Wednesday, 24 April · 8:10 AM",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.6,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      children: [
        _buildGridItem(
          context,
          icon: Icons.route,
          title: "Plan Route",
          color: Colors.purple[600]!,
          callback: () {
            Get.toNamed('busRoutes');
          },
        ),
        _buildGridItem(
          context,
          icon: Icons.history,
          title: "Trip History",
          color: Colors.teal[600]!,
          callback: () {
            Get.toNamed('tripHistory');
          },
        ),
      ],
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? callback, // Using VoidCallback for clarity
  }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: color.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String meta,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Text(
          meta,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}
