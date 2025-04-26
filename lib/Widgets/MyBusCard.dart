import 'package:buslink_flutter/Models/BusModel.dart';
import 'package:buslink_flutter/Widgets/MyDetailRow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================== BUS CARD ========================
class MyBusCard extends StatelessWidget {
  final BusModel bus;

  const MyBusCard({required this.bus});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFF10B981);
      case 'maintenance':
        return const Color(0xFFF59E0B);
      case 'inactive':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(bus.status);

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bus.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[800],
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
                    bus.status.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DetailRow(
              icon: Icons.confirmation_number,
              title: 'License Plate',
              value: bus.licensePlate,
            ),
            DetailRow(
              icon: Icons.airline_seat_recline_normal,
              title: 'Capacity',
              value: '${bus.capacity} seats',
            ),
            DetailRow(
              icon: Icons.person,
              title: 'Driver ID',
              value: '#${bus.driverId}',
            ),
          ],
        ),
      ),
    );
  }
}
