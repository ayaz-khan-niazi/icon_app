// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late SharedPreferences _preferences;
  String _loggedInUsername = '';

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
  void initState() {
    super.initState();
    _initSharedPreferences();
    // ... existing code ...
  }

  // Initialize SharedPreferences instance
  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _loggedInUsername = _preferences.getString('loggedInUsername') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // if (result != null)
                  // Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  // else
                  //   const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text(
                                    'Flash: ${snapshot.data == true ? "On" : "Off"}');
                              },
                            )),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         await controller?.flipCamera();
                      //         setState(() {});
                      //       },
                      //       child: FutureBuilder(
                      //         future: controller?.getCameraInfo(),
                      //         builder: (context, snapshot) {
                      //           if (snapshot.data != null) {
                      //             return Text(
                      //                 'Camera facing ${describeEnum(snapshot.data!)}');
                      //           } else {
                      //             return const Text('loading');
                      //           }
                      //         },
                      //       )),
                      // )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Container(
                      //   margin: const EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     onPressed: () async {
                      //       await controller?.pauseCamera();
                      //     },
                      //     child: const Text('pause',
                      //         style: TextStyle(fontSize: 20)),
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('Refresh Camera',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
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
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      controller.pauseCamera();
      //https request start

      // Make the HTTPS request
      if (_loggedInUsername != "Unauthorized") {
        if (result != null) {
          // final url = Uri.https('event.tih.org.pk', '/markuserattendance', {
          //   'code': result!.code,
          //   'username': _loggedInUsername,
          // });

          // final response = await http.get(url);
          final url =
              Uri.parse('https://event.tih.org.pk/Login.aspx/MarkAttendance');
          final headers = {
            'Content-Type': 'application/json',
          };
          final body = jsonEncode({
            'qrCodeResult': result!.code,
            'username': _loggedInUsername,
          });
          final response = await http.post(url, headers: headers, body: body);
          if (response.statusCode == 200) {
            final responseData = response.body;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Response of Attendance: ${responseData.toString()}')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'There is some issue marking your attendance. Please try again.')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Scanning unsuccessfull. Please try again.')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please login first to mark attendance')));
      }
      //https request end
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
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
}
