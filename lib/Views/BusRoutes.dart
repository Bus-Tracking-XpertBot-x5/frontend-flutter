import 'package:buslink_flutter/Controllers/BusRoutesController.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:buslink_flutter/Widgets/MyTripCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BusRoutesPage extends StatefulWidget {
  const BusRoutesPage({super.key});

  @override
  State<BusRoutesPage> createState() => _BusRoutesPageState();
}

class _BusRoutesPageState extends State<BusRoutesPage> {
  final BusRoutesController _busRoutesController =
      Get.find<BusRoutesController>();
  final TextEditingController _searchController = TextEditingController();

  final AuthService authService = Get.find<AuthService>();
  final loadingItemIds = <int>{};

  @override
  void initState() {
    super.initState();
    final authService = Get.find<AuthService>();
    if (authService.globalUser?.organization != null) {
      _busRoutesController.getAllTrips();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Obx(
          () =>
              authService.globalUser?.organization == null
                  ? Center(
                    child: Text(
                      "Please select an organization to view available routes.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const MyHeader(title: 'Search Routes'),
                      const SizedBox(height: 20),
                      _buildSearchBar(context),
                      const SizedBox(height: 20),
                      Expanded(
                        child:
                            _busRoutesController.isLoading.value
                                ? Center(child: CircularProgressIndicator())
                                : _busRoutesController.busMovements == null ||
                                    _busRoutesController.busMovements!.isEmpty
                                ? Center(child: Text("No Trips found"))
                                : RefreshIndicator(
                                  onRefresh: () async {
                                    await _busRoutesController.getAllTrips();
                                  },
                                  child: ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                        _busRoutesController
                                            .busMovements!
                                            .length,
                                    itemBuilder:
                                        (context, index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyTripCard(
                                              busMovement:
                                                  _busRoutesController
                                                      .busMovements![index],
                                            ),
                                            const SizedBox(height: 10),

                                            loadingItemIds.contains(
                                                  _busRoutesController
                                                      .busMovements![index]
                                                      .id,
                                                )
                                                ? Center(
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton.styleFrom(
                                                      fixedSize: Size(
                                                        60,
                                                        60,
                                                      ), // Sets the button's width and height
                                                      padding:
                                                          EdgeInsets
                                                              .zero, // Removes default padding
                                                    ),
                                                    child: SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2.0,
                                                          ),
                                                    ),
                                                  ),
                                                )
                                                : Center(
                                                  child: ElevatedButton.icon(
                                                    onPressed: () async {
                                                      final busMovementId =
                                                          _busRoutesController
                                                              .busMovements![index]
                                                              .id;
                                                      if (!loadingItemIds
                                                          .contains(
                                                            busMovementId,
                                                          )) {
                                                        loadingItemIds.add(
                                                          busMovementId,
                                                        );
                                                        setState(() {});
                                                        try {
                                                          await _busRoutesController
                                                              .rideTrip(
                                                                busMovementId:
                                                                    busMovementId,
                                                              );
                                                        } finally {
                                                          loadingItemIds.remove(
                                                            busMovementId,
                                                          );
                                                          setState(() {});
                                                        }
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .confirmation_number_rounded,
                                                      size: 20,
                                                    ),
                                                    label: Text(
                                                      'Book Now',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          ],
                                        ),
                                  ),
                                ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Card(
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
      ),
    );
  }
}
