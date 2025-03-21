import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyFloatingActionButton.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:flutter/material.dart';

class BusRoute {
  final String routeNumber;
  final String startPoint;
  final String endPoint;
  final String duration;
  final String frequency;
  final bool isExpress;

  BusRoute({
    required this.routeNumber,
    required this.startPoint,
    required this.endPoint,
    required this.duration,
    required this.frequency,
    required this.isExpress,
  });
}

final List<BusRoute> routes = [
  BusRoute(
    routeNumber: "23",
    startPoint: "Downtown Terminal",
    endPoint: "Central ",
    duration: "45 mins",
    frequency: "Every 10-15 mins",
    isExpress: true,
  ),
  BusRoute(
    routeNumber: "18",
    startPoint: "North Station",
    endPoint: "Southside Mall",
    duration: "35 mins",
    frequency: "Every 20 mins",
    isExpress: false,
  ),
  BusRoute(
    routeNumber: "45",
    startPoint: "Eastgate",
    endPoint: "Westfield Airport",
    duration: "55 mins",
    frequency: "Every 30 mins",
    isExpress: true,
  ),
  // Add more routes as needed
];

class BusRoutesPage extends StatefulWidget {
  const BusRoutesPage({super.key});

  @override
  State<BusRoutesPage> createState() => _BusRoutesPageState();
}

class BusRoutesPageState extends StatefulWidget {
  const BusRoutesPageState({super.key});

  @override
  State<BusRoutesPage> createState() => _BusRoutesPageState();
}

class _BusRoutesPageState extends State<BusRoutesPage> {
  final List<String> filters = ['Express', 'Regular', 'Economy'];
  int selectedFilter = -1;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: const MyFloatingActionButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: const MyBottomNavbar(),
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            const MyHeader(title: 'Search Routes'),
            SizedBox(height: screenHeight * 0.02),
            _buildSearchBar(context),
            SizedBox(height: screenHeight * 0.02),
            _buildFilterChips(),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: routes.length,
                itemBuilder:
                    (context, index) => _buildRouteCard(context, routes[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: List.generate(filters.length, (index) {
          return FilterChip(
            label: Text(
              filters[index],
              style: TextStyle(
                color:
                    selectedFilter == index
                        ? Colors.white
                        : Theme.of(context).primaryColor,
              ),
            ),
            checkmarkColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            selectedColor: Theme.of(context).primaryColor,
            selected: selectedFilter == index,
            onSelected: (bool value) {
              setState(() {
                selectedFilter = value ? index : -1;
              });
            },
          );
        }),
      ),
    );
  }

  // Rest of the methods remain the same as in your original code
  // (_buildSearchBar, _buildRouteCard, etc.)
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
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          hintText: 'Search routes...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, BusRoute route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Handle route card tap if needed
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  route.routeNumber,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          route.startPoint,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.arrow_right_alt, size: 20),
                        ),
                        Text(
                          route.endPoint,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          route.duration,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.repeat, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          route.frequency,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    if (route.isExpress) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'EXPRESS',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.grey[400]),
                onPressed: () {
                  // Handle favorite button press
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
