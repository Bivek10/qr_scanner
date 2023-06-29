import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utils/theme/colors.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({super.key});

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  TextEditingController qrTxtCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey _screenShotKey = GlobalKey();

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
            "Generate QR",
            style: TextStyle(color: AppColors.backgroundColor2, fontSize: 16),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  TextFormField(
                    controller: qrTxtCtrl,
                    decoration: InputDecoration(
                      fillColor: AppColors.blueLight.withOpacity(0.2),
                      filled: true,
                      hintText: "Enter QR code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter qr code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      _settingModalBottomSheet(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.errorColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: 24.sp,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Generate QR"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RepaintBoundary(
                  key: _screenShotKey,
                  child: Container(
                    color: AppColors.backgroundColor2,
                    child: QrImageView(
                      data: qrTxtCtrl.text,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        saveImageToGallery();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.blueLight),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: AppColors.errorColor),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.qr_code,
                            size: 24.sp,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Save"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _settingModalBottomSheet(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.errorColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: const Text("Cancel"),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<Uint8List?> captureQR() async {
    try {
      RenderRepaintBoundary boundary = _screenShotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List qrBytes = byteData!.buffer.asUint8List();
      return qrBytes;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> saveImageToGallery() async {
    try {
      Uint8List? imageBytes = await captureQR();
      if (imageBytes != null) {
        var data = await ImageGallerySaver.saveImage(imageBytes);
        if (data["isSuccess"] == true) {
          if (mounted) {
            Navigator.pop(context);
            showSnackbar(context);
          }
        }
      }
    } catch (e) {
      print('Error saving image to gallery: $e');
    }
  }

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'QR imaged saved',
            style: TextStyle(color: AppColors.backgroundColor2),
          ),
        ),
      ),
    );
  }
}
