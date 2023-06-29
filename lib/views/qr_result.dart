import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_maker/utils/theme/colors.dart';

import 'home.dart';

class QRResult extends StatefulWidget {
  final String scanData;

  const QRResult({super.key, required this.scanData});

  @override
  State<QRResult> createState() => _QRResultState();
}

class _QRResultState extends State<QRResult> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
            (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blueLight,
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                  (route) => false);
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 25,
              color: AppColors.backgroundColor2,
            ),
          ),
          title: const Text(
            "Scanned QR",
            style: TextStyle(color: AppColors.backgroundColor2, fontSize: 16),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: widget.scanData,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                widget.scanData,
                style: const TextStyle(
                  color: AppColors.blueLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
