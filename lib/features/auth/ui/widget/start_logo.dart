import 'package:flutter/cupertino.dart';

class StartLogo extends StatelessWidget {
  const StartLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Image.asset('assets/login_logo.png'),
    );
  }
}
