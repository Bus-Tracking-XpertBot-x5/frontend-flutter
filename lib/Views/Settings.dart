import 'package:buslink_flutter/Controllers/LogoutController.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = Get.find<AuthService>();
  final LogoutController _logoutController = Get.find<LogoutController>();

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
              const MyHeader(title: 'Settings'),
              SizedBox(height: screenHeight * 0.03),
              _buildSettingsSection(context, 'Account', [
                _buildSettingsItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  subtitle: 'Update personal information',
                  color: Colors.blue[800]!,
                  onTap: () {
                    Get.toNamed('/updateProfile');
                  },
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Modify for more security',
                  color: Colors.deepOrange[600]!,
                  onTap: () {
                    Get.toNamed('/changePassword');
                  },
                ),
                if (_authService.globalUser!.role != "driver")
                  _buildSettingsItem(
                    context,
                    icon: Icons.history,
                    title: 'Trip History',
                    subtitle: 'View past journeys',
                    color: Colors.purple[600]!,
                    onTap: () {
                      Get.toNamed('/tripHistory');
                    },
                  ),
                _buildSettingsItem(
                  context,
                  icon: Icons.place,
                  title: 'Location',
                  subtitle: 'Enable GPS Location',
                  color: Colors.lightGreen[600]!,
                  onTap: () {
                    Get.toNamed('/enableGpsLocation');
                  },
                ),
              ]),
              SizedBox(height: screenHeight * 0.02),
              _buildSettingsSection(context, 'Preferences', [
                if (_authService.globalUser!.role != "driver")
                  _buildSettingsItem(
                    context,
                    icon: Icons.wysiwyg_outlined,
                    title: 'Organization',
                    subtitle: 'Pick your organization',
                    color: Colors.teal[600]!,
                    onTap: () {
                      Get.toNamed('/pickOrganization');
                    },
                  ),
                if (_authService.globalUser!.role == "driver")
                  _buildSettingsItem(
                    context,
                    icon: Icons.directions_bus_filled_rounded,
                    title: 'Bus',
                    subtitle: 'View your bus info.',
                    color: Colors.amber[600]!,
                    onTap: () {
                      Get.toNamed('/driverBusInfo');
                    },
                  ),
                if (_authService.globalUser!.role == "driver")
                  _buildSettingsItem(
                    context,
                    icon: FontAwesome.drivers_license,
                    title: 'Driver',
                    subtitle: 'View your driver info.',
                    color: Colors.blue[600]!,
                    onTap: () {
                      Get.toNamed('/driverInfo');
                    },
                  ),
                if (_authService.globalUser!.role == "driver")
                  _buildSettingsItem(
                    context,
                    icon: Icons.wysiwyg_outlined,
                    title: 'Organization',
                    subtitle: 'Pick your organization',
                    color: Colors.teal[600]!,
                    onTap: () {
                      Get.toNamed('/driverOrganizationsInfo');
                    },
                  ),
              ]),
              SizedBox(height: screenHeight * 0.03),
              _buildLogoutButton(context),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Card(
          elevation: 0,
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: Obx(() {
        _logoutController.isLoading.value ? print('LOADING>>>>>>>') : "";
        return MaterialButton(
          onPressed: () {
            if (!_logoutController.isLoading.value) {
              AppDialog.showConfirm(
                message: 'Are you sure you want to logout?',
                title: 'Confirm Logout.',
                onConfirm: () async {
                  await _logoutController.logout();
                },
              );
            }
          },
          color: Colors.red[600],
          textColor: Colors.white,
          child:
              _logoutController.isLoading.value
                  ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Text('Log Out'),
        );
      }),
    );
  }
}
