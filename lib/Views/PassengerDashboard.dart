import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Services/PassengerBoardingService.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PassengerDashboardController extends GetxController {
  final nextTripData = <String, dynamic>{}.obs;
  final statisticsData = <String, dynamic>{}.obs;
  final currentTripData = <String, dynamic>{}.obs;
  final tripHistoryData = <dynamic>[].obs;

  final AuthService authService = Get.find<AuthService>();
  final PassengerBoardingService passengerBoardingService = Get.find<PassengerBoardingService>();
  @override
  void onInit() {
    fetchAllData();
    super.onInit();
  }

  Future<void> fetchAllData() async {
    await Future.wait([
      fetchNextTrip(),
      fetchStatistics(),
      fetchCurrentTrip(),
    ]);
  }

  Future<void> fetchNextTrip() async {
    try {
      nextTripData.value = await passengerBoardingService.getNextTrip();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load next trip data');
    }
  }

  Future<void> fetchStatistics() async {
    try {

  //     {
  //     "total_trips": 12,
  //   "completed": 10,
  //   "missed": 1,
  //   "scheduled": 1
  // }
      statisticsData.value = await passengerBoardingService.getStatistics();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load statistics');
    }
  }

  Future<void> fetchCurrentTrip() async {
    try {
  //     {
  //       "passengers": 24,
  //   "remaining_passengers": 8,
  //   "route": "Downtown Express",
  //   "bus": "City Transporter 12",
  //   "driver": "Driver John Doe",
  //   "estimated_end": "2024-02-20 09:45:00"
  // }
      currentTripData.value = await passengerBoardingService.getCurrentTrip();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load current trip');
    }
  }
  String formatDateTime(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy · hh:mm a').format(date);
  }

  String formatTime(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('hh:mm a').format(date);
  }
}

class PassengerDashboardPage extends StatelessWidget {
  PassengerDashboardPage({super.key});

  final controller = Get.put(PassengerDashboardController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchAllData(),
        child: Padding(
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
                    "Journey Overview",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Obx(() => controller.currentTripData.isNotEmpty
                    ? _buildCurrentTripCard(context)
                    : const SizedBox.shrink()),
                SizedBox(height: screenHeight * 0.02),
                Obx(() => _buildNextTripCard(context)),
                SizedBox(height: screenHeight * 0.02),
                _buildStatisticsGrid(context),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
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
            "Good Morning, ${controller.authService.globalUser!.name}",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, d MMMM · hh:mm a').format(DateTime.now()),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
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
          callback: () => Get.toNamed('busRoutes'),
        ),
        _buildGridItem(
          context,
          icon: Icons.history,
          title: "Trip History",
          color: Colors.teal[600]!,
          callback: () => Get.toNamed('tripHistory'),
        ),
      ],
    );
  }

  Widget _buildGridItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        VoidCallback? callback,
      }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: color.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: callback,
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

  Widget _buildCurrentTripCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(

        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_bus, color: Colors.green[800], size: 28),
              const SizedBox(width: 12),
              Text(
                "Current Journey",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTripDetailRow(
            "Route",
            controller.currentTripData['route'],
            Icons.route,
          ),
          _buildTripDetailRow(
            "Bus",
            controller.currentTripData['bus'],
            Icons.directions_bus_filled,
          ),
          _buildTripDetailRow(
            "Driver",
            controller.currentTripData['driver'],
            Icons.person,
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPassengerStats(
                "On Board",
                controller.currentTripData['passengers'].toString(),
                Colors.blue,
              ),
              _buildPassengerStats(
                "Remaining",
                controller.currentTripData['remaining_passengers'].toString(),
                Colors.orange,
              ),
              _buildPassengerStats(
                "ETA",
                controller.formatTime(controller.currentTripData['estimated_end']),
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextTripCard(BuildContext context) {
    return controller.nextTripData.isEmpty
        ? _buildLoadingCard()
        : _buildInfoCard(
      context,
      icon: Icons.departure_board,
      title: "Next Departure",
      subtitle: "${controller.nextTripData['route_name']}\n${controller.nextTripData['bus_name']}",
      meta: controller.formatDateTime(
          controller.nextTripData['estimated_boarding_time']),
      color: Colors.blue[600]!,
    );
  }

  Widget _buildStatisticsGrid(BuildContext context) {
    return Obx(() => controller.statisticsData.isEmpty
        ? _buildLoadingCard()
        : GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildStatCard(
          context,
          value: controller.statisticsData['total_trips'].toString(),
          label: "Total Trips",
          color: Colors.purple[600]!,
        ),
        _buildStatCard(
          context,
          value: controller.statisticsData['completed'].toString(),
          label: "Completed",
          color: Colors.green[600]!,
        ),
        _buildStatCard(
          context,
          value: controller.statisticsData['missed'].toString(),
          label: "Missed",
          color: Colors.red[600]!,
        ),
        _buildStatCard(
          context,
          value: controller.statisticsData['scheduled'].toString(),
          label: "Upcoming",
          color: Colors.amber[600]!,
        ),
      ],
    ));
  }

  Widget _buildHistoryCard(BuildContext context, dynamic trip) {
    final statusColor = trip['boarding']['status'] == 'departed'
        ? Colors.green
        : Colors.red;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trip['boarding']['status'].toString().toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                controller.formatTime(trip['boarding']['boarding_time']),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            trip['trip']['route_name'],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trip['trip']['bus_name'],
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            "Driver: ${trip['trip']['driver_name']}",
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const Spacer(),
          Text(
            "Departed at ${controller.formatTime(trip['trip']['start_time'])}",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPassengerStats(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      BuildContext context, {
        required String value,
        required String label,
        required Color color,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
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

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}