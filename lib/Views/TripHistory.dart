import 'package:buslink_flutter/Controllers/TripHistoryController.dart';
import 'package:buslink_flutter/Models/PassengerBoardingModel.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:buslink_flutter/Widgets/MyTripCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripHistoryPage extends StatefulWidget {
  const TripHistoryPage({super.key});

  @override
  State<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  final TripHistoryController _tripHistoryController =
      Get.find<TripHistoryController>();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tripHistoryController.getAllTrips();
  }

  RxString selectedFilter = "All".obs;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const MyHeader(title: 'Trip History'),
              const SizedBox(height: 20),
              _buildSearchBar(context),
              const SizedBox(height: 20),
              Expanded(
                child:
                    Obx(
                        () => _tripHistoryController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : _tripHistoryController.passengerBoardings == null ||
                              _tripHistoryController.passengerBoardings!.isEmpty
                          ? Center(child: Text("No Trips Found."))
                          : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                _tripHistoryController.passengerBoardings!.length,
                            itemBuilder:
                                (context, index) => _buildTripCard(
                                  _tripHistoryController
                                      .passengerBoardings![index],
                                ),
                          ),
                    ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Card(
            color: Colors.white,
            elevation: 1,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                hintText: 'Search routes...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (value) {
                _tripHistoryController.getAllTrips(
                  search: _searchController.text.trim(),
                  statusFilter: selectedFilter.toLowerCase(),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 6),
        Align(
          alignment: Alignment.centerRight,
          child: DropdownButton<String>(
            value: selectedFilter.value,
            onChanged: (newValue) {
              selectedFilter.value = newValue!;
              _tripHistoryController.getAllTrips(
                search: _searchController.text.trim(),
                statusFilter: selectedFilter.toLowerCase(),
              );
            },
            items:
                ["All", "Scheduled", "Boarded", "Missed"]
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
            underline: Container(
              height: 2,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard(PassengerBoardingModel passengerBoarding) {
    final boardingTime = DateFormat(
      'hh:mm a',
    ).format(passengerBoarding.estimatedBoardingTime);
    final boardingDate = DateFormat(
      'MMM dd',
    ).format(passengerBoarding.estimatedBoardingTime);

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (passengerBoarding.status.toLowerCase()) {
      case 'scheduled':
        statusColor = const Color(0xFF6366F1);
        statusIcon = Icons.access_time_rounded;
        statusText = 'Scheduled';
        break;
      case 'boarded':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle_rounded;
        statusText = 'Boarded';
        break;
      case 'missed':
        statusColor = const Color(0xFFEF4444);
        statusIcon = Icons.warning_rounded;
        statusText = 'Missed';
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusIcon = Icons.help_outline_rounded;
        statusText = 'Unknown';
    }

    return Column(
      children: [
        Column(
          children: [
            MyTripCard(busMovement: passengerBoarding.busMovement!),
            Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Boarding Time
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ETA',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: boardingTime,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  •  $boardingDate',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Status Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, size: 16, color: statusColor),
                          const SizedBox(width: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
