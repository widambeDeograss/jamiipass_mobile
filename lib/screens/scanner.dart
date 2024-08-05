import 'dart:convert';
import 'dart:io';

// import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/screens/scanner_results.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/custom_colors.dart';
// import 'package:symptoms_recorder_app/utils/app_color.dart';
// import 'package:symptoms_recorder_app/utils/encryption.dart';

class QRViewExample extends StatefulWidget {
  // const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool resultObtained = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // if (result != null)
                    //   Text(
                    //       '', overflow: TextOverflow.ellipsis,)
                    // else
                    Text(
                      getTranslated(context, "scan_scan_code").toString(),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => AppColors.mainColor)),
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null ||
                                  snapshot.data == false) {
                                return Text(
                                  '${getTranslated(context, "scan_page_flash").toString()}: OFF',
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                return Text(
                                  '${getTranslated(context, "scan_page_flash").toString()}: ON',
                                  style: const TextStyle(color: Colors.white),
                                );
                              }
                            },
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = MediaQuery.of(context).size.width * 0.8;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
      result = scanData;
      scannedData(scanData.code.toString());
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void scannedData(String results) {
  print('Processing scanned data: $results');
  if (!resultObtained) {
    try {
      List<dynamic>? data = jsonDecode(results);
      if (data != null && data[0]['card'] is String) {
        setState(() {
          resultObtained = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScannerResults(scannerResults: data),
          ),
        );
      }
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  }
}
}
