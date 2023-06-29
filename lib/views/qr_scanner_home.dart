import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_maker/views/qr_result.dart';
import '../utils/theme/colors.dart';

class QRScannerHome extends StatefulWidget {
  const QRScannerHome({super.key});

  @override
  State<QRScannerHome> createState() => _QRScannerHomeState();
}

class _QRScannerHomeState extends State<QRScannerHome> {
  QRViewController? controller;
  Barcode? result;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
    super.reassemble();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueLight,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(gradient: AppColors.gradient2),
        child: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: AppColors.backgroundColor2,
                  borderRadius: 5,
                  borderLength: 20,
                  borderWidth: 5,
                  cutOutSize: 250.sp),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.format == BarcodeFormat.qrcode &&
          scanData.code!.isNotEmpty) {
        controller.pauseCamera();
        navigateToNextScreen(scanData.code.toString());
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void navigateToNextScreen(String qrData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRResult(
          scanData: qrData,
        ),
      ),
    );
  }
}
