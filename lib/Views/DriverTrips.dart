import 'package:buslink_flutter/Controllers/DriverTripsController.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyTripCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverTripsPage extends StatefulWidget {
  const DriverTripsPage({super.key});

  @override
  State<DriverTripsPage> createState() => _DriverTripsPageState();
}

class _DriverTripsPageState extends State<DriverTripsPage> {
  final DriverTripsController _driverTripsController =
      Get.find<DriverTripsController>();
  final TextEditingController _searchController = TextEditingController();
  final AuthService authService = Get.find<AuthService>();
  RxString selectedFilter = "All".obs;

  @override
  void initState() {
    super.initState();
    _driverTripsController.getAllTrips();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'My Trips',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchBar(context),
              const SizedBox(height: 24),
              Expanded(
                child:
                    _driverTripsController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : _driverTripsController.busMovements == null ||
                            _driverTripsController.busMovements!.isEmpty
                        ? Center(child: Text("No Trips Found"))
                        : RefreshIndicator(
                          onRefresh: () async {
                            await _driverTripsController.getAllTrips(
                              search: _searchController.text.trim(),
                              statusFilter: _getStatusFilterValue(),
                            );
                          },
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                _driverTripsController.busMovements!.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 12),
                            itemBuilder:
                                (context, index) => MyTripCard(
                                  busMovement:
                                      _driverTripsController
                                          .busMovements![index],
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

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[500]),
                hintText: 'Search routes...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
              ),
              onChanged: (value) {
                _driverTripsController.getAllTrips(
                  search: _searchController.text.trim(),
                  statusFilter: _getStatusFilterValue(),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Align(
          alignment: Alignment.centerRight,
          child: DropdownButton<String>(
            value: selectedFilter.value,
            onChanged: (newValue) {
              selectedFilter.value = newValue!;
              _driverTripsController.getAllTrips(
                search: _searchController.text.trim(),
                statusFilter: _getStatusFilterValue(),
              );
            },
            items:
                ["All", "Scheduled", "In Progress", "Completed", "Cancelled"]
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

  String _getStatusFilterValue() {
    switch (selectedFilter.value) {
      case 'All':
        return '';
      case 'In Progress':
        return 'in_progress';
      default:
        return selectedFilter.value.toLowerCase();
    }
  }
}
