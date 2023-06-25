import 'package:flutter/material.dart';
import 'package:qr_maker/utils/theme/colors.dart';

import 'home.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false);
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 20,
              color: AppColors.blackColor,
            )),
      ),
    );
  }
}
