import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  late Size size;

  final GlobalKey _qrKey = GlobalKey(debugLabel: "QR");

  QRViewController? _controller;
  Barcode? result;

  bool _isBuild = false;
  bool _isDialogOpen = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    if (!_isBuild && _controller != null) {
      _controller?.pauseCamera;
      _controller?.resumeCamera;
      setState(() {
        _isBuild = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 9,
              child: _buildQrView(context),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _controller?.toggleFlash();
                        },
                        child: const Icon(
                          Icons.flash_on,
                          size: 24,
                          color: Color(0xFFF7524F),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _controller?.flipCamera();
                        },
                        child: const Icon(
                          Icons.flip_camera_android_outlined,
                          size: 24,
                          color: Color(0xFFF7524F),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = 250.0;
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
      overlay: QrScannerOverlayShape(
        cutOutSize: scanArea,
        borderWidth: 10,
        borderRadius: 5.0,
        borderColor: const Color(0xFFF7524F),
      ),
    );
  }

  void _onQRViewCreated(QRViewController _qrController) {
    setState(() {
      this._controller = _qrController;
    });

    _controller?.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        _controller?.pauseCamera();
      });
      if (result?.code != null) {
        print("QR code Scanned and showing Result");
        if (!_isDialogOpen) {
          _isDialogOpen = true; // Set the flag to true
          _showResult();
        }
      }
    });
  }

  void onPermissionSet(
      BuildContext context, QRViewController _ctrl, bool _permission) {
    if (!_permission) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No permission')));
    }
  }

  Widget _showResult() {
    bool _validURL = Uri.parse(result!.code.toString()).isAbsolute;

    return Center(
        child: FutureBuilder<dynamic>(
      future: showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
                child: AlertDialog(
                  title: const Text('Scan Result!',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: SizedBox(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          result!.code.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isDialogOpen = false;
                            });
                            _controller?.resumeCamera();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xff7524f),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            shadowColor: const Color(0xff7524f),
                          ),
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  ),
                ),
                onWillPop: () async => false);
          }),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        throw UnimplementedError;
      },
    ));
  }
}