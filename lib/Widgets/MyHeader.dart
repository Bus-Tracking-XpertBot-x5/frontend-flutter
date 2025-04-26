import 'package:flutter/material.dart';

class MyHeader extends StatelessWidget {
  final String title;
  const MyHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
