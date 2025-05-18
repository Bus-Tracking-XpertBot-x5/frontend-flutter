import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Services/DriverService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class DriverDashboardController extends GetxController {
  final DriverService driverService = Get.find();

  var scheduledPassengers = {}.obs;
  var boardedPassengers = {}.obs;
  var monthlyMoney = {}.obs;
  var monthlyTime = {}.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      scheduledPassengers.value = await driverService.getScheduledPassengers();
      boardedPassengers.value = await driverService.getBoardedPassengers();
      monthlyMoney.value = await driverService.getMonthlyMoney();
      monthlyTime.value = await driverService.getMonthlyTime();
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to fetch dashboard data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red);
    }
  }
}

class DriverDashboardPage extends StatelessWidget {
  DriverDashboardPage({super.key});
    final controller = Get.put(DriverDashboardController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchData(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                _buildHeader(context),
                SizedBox(height: screenHeight * 0.02),
                _buildServiceGrid(context),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02),
                  child: Text(
                    "Journey Overview",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildStatisticsGrid(context),
                SizedBox(height: screenHeight * 0.03),

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
        mainAxisAlignment: MainAxisAlignment.center,
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
          callback: () {
            Get.toNamed('/addTrip');
          },
        ),
        _buildGridItem(
          context,
          icon: Icons.history,
          title: "Trip History",
          color: Colors.teal[600]!,
          callback: () {
            Get.offAllNamed('/driverTrips');
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

  Widget _buildStatisticsGrid(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildStatCard(
            context,
            icon: Icons.schedule,
            title: 'Scheduled Passengers',
            value: '${controller.scheduledPassengers['count']}',
            color: Colors.blue[800]!,
          ),
          _buildStatCard(
            context,
            icon: Icons.people_alt,
            title: 'Boarded Passengers',
            value: '${controller.boardedPassengers['count']}',
            color: Colors.green[800]!,
          ),
          _buildStatCard(
            context,
            icon: Icons.monetization_on,
            title: 'Monthly Earnings',
            value: '\$${controller.monthlyMoney['totalMoney']}',
            color: Colors.purple[800]!,
          ),
          _buildStatCard(
            context,
            icon: Icons.timer,
            title: 'Monthly Hours',
            value:
            '${controller.monthlyTime['hours']}h ${controller.monthlyTime['minutes']}m',
            color: Colors.orange[800]!,
          ),
        ],
      ),
    ));
  }

  Widget _buildStatCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required Color color,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    )),
                Text(title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}