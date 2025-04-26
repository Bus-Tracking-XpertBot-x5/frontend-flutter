// AddTripPage.dart
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/AddTripController.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:intl/intl.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final AddTripController controller = Get.find<AddTripController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadInitialData(); // Load mock data
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartTime) {
            controller.selectedStartTime.value = finalDateTime;
            _startTimeController.text = DateFormat(
              'yyyy-MM-dd HH:mm',
            ).format(finalDateTime);
          } else {
            controller.selectedEndTime.value = finalDateTime;
            _endTimeController.text = DateFormat(
              'yyyy-MM-dd HH:mm',
            ).format(finalDateTime);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(),
      bottomNavigationBar: const MyBottomNavbar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Obx(
            () => SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const MyHeader(title: 'Add New Trip'),
                    const SizedBox(height: 30),

                    // Organization Dropdown
                    DropdownButtonFormField<String>(
                      value:
                          controller.selectedOrganization.value.isEmpty
                              ? null
                              : controller.selectedOrganization.value,
                      items:
                          controller.organizations
                              .map(
                                (org) => DropdownMenuItem(
                                  value: org.id.toString(),
                                  child: Text(org.name),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) =>
                              controller.selectedOrganization.value =
                                  value ?? '',
                      decoration: InputDecoration(
                        labelText: "Organization",
                        prefixIcon: const Icon(Icons.business),
                        errorText: controller.fieldErrors['organization'],
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select an organization'
                                  : null,
                    ),
                    const SizedBox(height: 20),

                    // Route Dropdown
                    DropdownButtonFormField<String>(
                      value:
                          controller.selectedRoute.value.isEmpty
                              ? null
                              : controller.selectedRoute.value,
                      items:
                          controller.routes
                              .map(
                                (route) => DropdownMenuItem(
                                  value: route.id.toString(),
                                  child: Text(route.routeName),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) =>
                              controller.selectedRoute.value = value ?? '',
                      decoration: InputDecoration(
                        labelText: "Route",
                        prefixIcon: const Icon(Icons.route),
                        errorText: controller.fieldErrors['route'],
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select a route'
                                  : null,
                    ),
                    const SizedBox(height: 20),

                    // Bus Dropdown
                    DropdownButtonFormField<String>(
                      value:
                          controller.selectedBus.value.isEmpty
                              ? null
                              : controller.selectedBus.value,
                      items:
                          controller.buses
                              .map(
                                (bus) => DropdownMenuItem(
                                  value: bus.id.toString(),
                                  child: Text(bus.name),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => controller.selectedBus.value = value ?? '',
                      decoration: InputDecoration(
                        labelText: "Bus",
                        prefixIcon: const Icon(Icons.directions_bus),
                        errorText: controller.fieldErrors['bus'],
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select a bus'
                                  : null,
                    ),
                    const SizedBox(height: 20),

                    // Start Time Picker
                    TextFormField(
                      controller: _startTimeController,
                      readOnly: true,
                      onTap: () => _selectDateTime(context, true),
                      decoration: InputDecoration(
                        labelText: "Estimated Start Time",
                        prefixIcon: const Icon(Icons.calendar_today),
                        errorText: controller.fieldErrors['start_time'],
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select start time'
                                  : null,
                    ),
                    const SizedBox(height: 20),

                    // End Time Picker
                    TextFormField(
                      controller: _endTimeController,
                      readOnly: true,
                      onTap: () => _selectDateTime(context, false),
                      decoration: InputDecoration(
                        labelText: "Estimated End Time",
                        prefixIcon: const Icon(Icons.calendar_today),
                        errorText: controller.fieldErrors['end_time'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please select end time';
                        if (controller.selectedStartTime.value.isAfter(
                          controller.selectedEndTime.value,
                        )) {
                          return 'End time must be after start time';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Price Input
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: "Trip Price",
                        prefixIcon: const Icon(Icons.attach_money),
                        errorText: controller.fieldErrors['price'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        final num? price = num.tryParse(value);
                        if (price == null || price < 0) {
                          return 'Enter a valid positive number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading.value) return;
                        if (formKey.currentState!.validate()) {
                          controller.addTrip(
                            price: num.parse(_priceController.text),
                          );
                        }
                      },
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Create Trip"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
