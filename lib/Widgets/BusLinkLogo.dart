import 'package:flutter/widgets.dart';

class BusLinkLogo extends StatelessWidget {
  const BusLinkLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Image.asset('images/logo.png', fit: BoxFit.contain),
    );
  }
}
