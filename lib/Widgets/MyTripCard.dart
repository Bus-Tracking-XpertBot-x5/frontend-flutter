// lib/Widgets/my_trip_card.dart
import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:buslink_flutter/Widgets/MyChatButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:buslink_flutter/Models/BusMovementModel.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching WhatsApp

class MyTripCard extends StatelessWidget {
  final BusMovementModel busMovement;

  const MyTripCard({Key? key, required this.busMovement}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return const Color(0xFF6366F1);
      case 'in_progress':
        return const Color(0xFFF59E0B);
      case 'completed':
        return const Color(0xFF10B981);
      case 'canceled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _buildDateTimeSection({
    required IconData icon,
    required Color color,
    required String date,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassengerProgress({
    required int booked,
    required int actual,
    required int capacity,
  }) {
    final progress = booked / capacity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Passengers',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              width: 100,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 100 * progress,
              height: 8,
              decoration: BoxDecoration(
                color: _getStatusColor('in_progress'),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$booked / $capacity',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo({required String name, required String bus}) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFFE0E7FF),
          child: Icon(Icons.person_rounded, size: 18, color: Color(0xFF4F46E5)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(bus, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildOrganizationInfo({required String name}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.business_rounded,
            size: 18,
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organization',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceInfo({required double price}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.price_change,
            size: 18,
            color: Colors.lightBlue,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              price.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(busMovement.status);

    return Container(
      margin: const EdgeInsets.all(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        highlightColor: statusColor.withOpacity(0.1),
        onTap: () {
          final targetRoute = '/viewSingleTrip/${busMovement.id}';
          if (Get.currentRoute != targetRoute) {
            Get.toNamed(targetRoute);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Route Name and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      busMovement.busRoute.routeName,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[800],
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      busMovement.status.replaceAll('_', ' ').toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Date and Passenger Progress Row
              Row(
                children: [
                  _buildDateTimeSection(
                    icon: Icons.calendar_month_rounded,
                    color: const Color(0xFF10B981),
                    date: DateFormat(
                      'MMM dd, yyyy',
                    ).format(busMovement.estimatedStart),
                    time:
                        '${DateFormat("hh:mm a").format(busMovement.estimatedStart)} - ${DateFormat("hh:mm a").format(busMovement.estimatedEnd)}',
                  ),
                  const Spacer(),
                  _buildPassengerProgress(
                    booked: busMovement.bookedPassengerCount,
                    actual: busMovement.actualPassengerCount,
                    capacity: busMovement.bus.capacity,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 12),
              // Bottom Row: Driver Info and WhatsApp Button
              Row(
                children: [
                  _buildDriverInfo(
                    name: busMovement.bus.driver!.user!.name,
                    bus: busMovement.bus.name,
                  ),
                  const Spacer(),
                  MyChatButton(
                    phoneNumber: busMovement.bus.driver!.user!.phoneNumber,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 12),
              // Organization Info Row
              Row(
                children: [
                  _buildOrganizationInfo(
                    name: busMovement.organization?.name ?? 'Unknown',
                  ),
                  const Spacer(),
                  _buildPriceInfo(price: busMovement.price),
                ],
              ),
              if (busMovement.status == "completed" &&
                  busMovement.actualStart != null &&
                  busMovement.actualEnd != null) ...[
                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 12),

                Row(
                  children: [
                    _buildDateTimeSection(
                      icon: Icons.calendar_month_rounded,
                      color: const Color(0xFF10B981),
                      date:
                          "Completed - ${DateFormat('MMM dd, yyyy').format(busMovement.estimatedStart)}",
                      time:
                          '${DateFormat("hh:mm a").format(busMovement.actualStart!)} - ${DateFormat("hh:mm a").format(busMovement.actualEnd!)}',
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
