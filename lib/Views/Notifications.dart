import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyFloatingActionButton.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: const MyFloatingActionButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              const MyHeader(title: 'Notifications'),
              SizedBox(height: screenHeight * 0.03),
              _buildNotificationCard(
                context,
                icon: Icons.directions_bus_rounded,
                title: "Bus Arriving Soon",
                message: "Route 23 to Downtown is 5 mins away from Stop #12",
                time: "9:45 AM",
                color: Colors.blue[800]!,
              ),
              _buildNotificationCard(
                context,
                icon: Icons.schedule_rounded,
                title: "Delay Alert",
                message: "Route 45 is delayed by 15 mins due to traffic",
                time: "9:30 AM",
                color: Colors.orange[800]!,
              ),
              _buildNotificationCard(
                context,
                icon: Icons.check_circle_rounded,
                title: "Trip Completed",
                message: "Your journey on Route 12 has been completed",
                time: "Yesterday",
                color: Colors.green[600]!,
              ),
              _buildNotificationCard(
                context,
                icon: Icons.payment_rounded,
                title: "Payment Received",
                message: "Monthly pass payment confirmed",
                time: "Yesterday",
                color: Colors.purple[600]!,
              ),
              _buildNotificationCard(
                context,
                icon: Icons.notifications_active_rounded,
                title: "New Feature Available",
                message: "Try our new real-time tracking feature",
                time: "2 days ago",
                color: Colors.teal[600]!,
              ),
              _buildNotificationCard(
                context,
                icon: Icons.warning_rounded,
                title: "Service Update",
                message: "Route 18 will have temporary schedule changes",
                time: "3 days ago",
                color: Colors.red[600]!,
              ),
              SizedBox(height: screenHeight * 0.03),
              _buildMarkAllReadButton(context),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      elevation: 0.3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkAllReadButton(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.mark_email_read_rounded, color: Colors.grey[600]),
          ),
          title: const Text(
            'Mark All as Read',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
