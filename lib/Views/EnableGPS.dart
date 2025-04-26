import 'package:buslink_flutter/Controllers/EnableGPSController.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EnableGPSPage extends StatelessWidget {
  EnableGPSPage({super.key});

  final EnableGPSController _controller = Get.find<EnableGPSController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),

      bottomNavigationBar: const MyBottomNavbar(),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: _controller.isLoading.value,
          child: _buildMainContent(context),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 40),
          _buildStatusCards(),
          const SizedBox(height: 40),
          _buildMapPreview(), // Updated interactive map preview
          const SizedBox(height: 40),
          _buildActionButtons(),
          const SizedBox(height: 20),
          _buildErrorSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location Access Required', style: Get.textTheme.headlineMedium),
        const SizedBox(height: 15),
        Text(
          'To provide the best experience, we need access to your location. '
          'Please enable GPS and grant location permissions.',
          style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStatusCards() {
    return Obx(
      () => Column(
        children: [
          _buildStatusCard(
            icon:
                _controller.isGpsEnabled.value
                    ? FontAwesome.check_circle
                    : FontAwesome.times_circle,
            title: 'GPS Status',
            status: _controller.isGpsEnabled.value ? 'Enabled' : 'Disabled',
            color: _controller.isGpsEnabled.value ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 15),
          _buildStatusCard(
            icon: _getPermissionIcon(_controller.permissionStatus.value),
            title: 'Permission Status',
            status: _getPermissionStatusText(
              _controller.permissionStatus.value,
            ),
            color: _getPermissionColor(_controller.permissionStatus.value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    IconData? icon,
    String? title,
    String? status,
    Color? color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title!, style: Get.textTheme.bodySmall),
                  const SizedBox(height: 5),
                  Text(status!, style: Get.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(
      () => Column(
        children: [
          if (!_controller.isGpsEnabled.value)
            _buildActionButton(
              icon: FontAwesome.location_arrow,
              onPressed: _controller.openLocationSettings,
              color: Colors.blue,
            ),
          if (_controller.permissionStatus.value == LocationPermission.denied ||
              _controller.permissionStatus.value ==
                  LocationPermission.deniedForever)
            _buildActionButton(
              icon: FontAwesome.hand_paper_o,
              onPressed: _controller.requestLocationPermission,
              color: Colors.orange,
            ),
          if (_controller.permissionStatus.value ==
                  LocationPermission.whileInUse ||
              _controller.permissionStatus.value == LocationPermission.always)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: FontAwesome.refresh,
                  onPressed: _controller.getCurrentLocation,
                  color: Colors.green,
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  icon: FontAwesome.save,
                  onPressed: _controller.updateLocation,
                  color: Colors.green,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IconButton(
        icon: Icon(icon, size: 24),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed as void Function()?,
      ),
    );
  }

  Widget _buildMapPreview() {
    return Obx(() {
      if (_controller.currentPosition.value != null) {
        return SizedBox(
          height: 200,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _controller.currentPosition.value!,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('current'),
                position: _controller.currentPosition.value!,
                draggable: true,
                onDragEnd: (newPosition) {
                  _controller.currentPosition.value = newPosition;
                },
              ),
            },
            onTap: (LatLng tappedLocation) {
              _controller.currentPosition.value = tappedLocation;
            },
            myLocationEnabled: true,
          ),
        );
      } else {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            'Location not available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        );
      }
    });
  }

  Widget _buildErrorSection() {
    return Obx(
      () =>
          _controller.locationError.value.isNotEmpty
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _controller.locationError.value,
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ),
                  ],
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  // Helper methods for permission status
  IconData _getPermissionIcon(LocationPermission status) {
    switch (status) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return FontAwesome.check_circle;
      case LocationPermission.denied:
        return FontAwesome.question_circle;
      case LocationPermission.deniedForever:
        return FontAwesome.times_circle;
      default:
        return FontAwesome.exclamation_circle;
    }
  }

  String _getPermissionStatusText(LocationPermission status) {
    switch (status) {
      case LocationPermission.whileInUse:
        return 'Allowed while using app';
      case LocationPermission.always:
        return 'Always allowed';
      case LocationPermission.denied:
        return 'Permission required';
      case LocationPermission.deniedForever:
        return 'Permanently denied';
      default:
        return 'Unknown status';
    }
  }

  Color _getPermissionColor(LocationPermission status) {
    switch (status) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return Colors.green;
      case LocationPermission.denied:
        return Colors.orange;
      case LocationPermission.deniedForever:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
