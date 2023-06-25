import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.chevron_left,
                size: 20,
                color: AppColors.blackColor,
              )),
          title: Text('Generate QR'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: qrTxtCtrl,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    hintText: "Enter QR code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
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
                    if (_formKey.currentState!.validate()) {
                      _settingModalBottomSheet(context);
                    }
                  },
                  child: const Text(
                    "Generate QR",
                  ),
                ),
              ],
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
                  child: QrImageView(
                    data: qrTxtCtrl.text,
                    version: QrVersions.auto,
                    size: 200.0,
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
                        toQrImageData();
                      },
                      child: const Text(
                        "Download QR",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text(
                        "Cancel",
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<Uint8List?> toQrImageData() async {
    print("qrTxtCtrl:::::::, ${qrTxtCtrl.text}");
    try {
      final image = await QrPainter(
        data: qrTxtCtrl.text,
        version: QrVersions.auto,
        gapless: false,
        errorCorrectionLevel: 1,
      ).toImage(300);
      final a = await image.toByteData(format: ImageByteFormat.png);
      print(a!.buffer.asUint8List());
      final result = await ImageGallerySaver.saveImage(a!.buffer.asUint8List());
      print("results:::$result");
      return a.buffer.asUint8List();
    } catch (e) {
      print(
        "error::: $e",
      );
      return null;
    }
  }

  Future<void> saveImageToGallery() async {
    try {
      Uint8List? imageBytes = await toQrImageData();
      if (imageBytes != null) {
        await ImageGallerySaver.saveImage(imageBytes);
        print('Image saved to gallery successfully');
      } else {
        print('Failed to capture the widget');
      }
    } catch (e) {
      print('Error saving image to gallery: $e');
    }
  }
}
