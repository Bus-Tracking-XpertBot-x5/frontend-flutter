import 'package:buslink_flutter/Models/OrganizationModel.dart';
import 'package:flutter/material.dart';

class MyOrganizationCard extends StatelessWidget {
  const MyOrganizationCard({super.key, required this.organization});

  final OrganizationModel organization;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: ListTile(
        leading: Icon(
          Icons.business_rounded,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        ),
        title: Text(
          organization.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle:
            organization.description != null
                ? Text(
                  organization.description!,
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
                : null,
      ),
    );
  }
}
