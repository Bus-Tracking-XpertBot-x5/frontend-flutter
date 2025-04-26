import 'package:flutter/widgets.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Image.asset('images/logo.png', fit: BoxFit.contain),
    );
  }
}
