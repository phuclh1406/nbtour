// import 'dart:convert';

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:nbtour/representation/widgets/button_widget/button_widget.dart';
// import 'package:nbtour/services/api/booking_service.dart';
// import 'package:nbtour/services/models/booking_model.dart';
// import 'package:nbtour/services/models/tour_model.dart';
// import 'package:nbtour/utils/constant/dimension.dart';
// import 'package:nbtour/utils/constant/text_style.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

// class QRScanner extends StatefulWidget {
//   const QRScanner({super.key, required this.tour});

//   final Tour tour;

//   @override
//   State<QRScanner> createState() => _QRScannerState();
// }

// class _QRScannerState extends State<QRScanner> {
//   late Size size;
//   final GlobalKey _qrKey = GlobalKey(debugLabel: "QR");

//   QRViewController? _controller;
//   Barcode? result;
//   bool _isBuild = false;
//   bool _isDialogOpen = false;
//   String notiMsg = "";
//   @override
//   Widget build(BuildContext context) {
//     size = MediaQuery.of(context).size;

//     if (!_isBuild && _controller != null) {
//       _controller?.pauseCamera;
//       _controller?.resumeCamera;
//       setState(() {
//         _isBuild = true;
//       });
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Scanner'),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SizedBox(
//         width: size.width,
//         height: size.height,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: 9,
//               child: _buildQrView(context),
//             ),
//             Expanded(
//                 flex: 1,
//                 child: Container(
//                   color: const Color.fromARGB(255, 0, 0, 0),
//                   width: size.width,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                           await _controller?.toggleFlash();
//                         },
//                         child: const Icon(
//                           Icons.flash_on,
//                           size: 24,
//                           color: Color(0xFFF7524F),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           await _controller?.flipCamera();
//                         },
//                         child: const Icon(
//                           Icons.flip_camera_android_outlined,
//                           size: 24,
//                           color: Color(0xFFF7524F),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     var scanArea = 250.0;
//     return QRView(
//       key: _qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
//       overlay: QrScannerOverlayShape(
//         cutOutSize: scanArea,
//         borderWidth: 10,
//         borderRadius: 5.0,
//         borderColor: const Color(0xFFF7524F),
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController qrController) {
//     setState(() {
//       _controller = qrController;
//     });

//     _controller?.scannedDataStream.listen((event) async {
//       setState(() {
//         result = event;
//         _controller?.pauseCamera();
//       });
//       if (result?.code != null) {
//         print(result?.code?.substring(11));
//         if (!_isDialogOpen) {
//           _isDialogOpen = true;
//           Booking? booking = await BookingServices.getBookingByBookingDetailId(
//               result?.code?.substring(11));
//           if (booking != null) {
//             print('booking success');
//             _showResult(booking);
//           }

//           // Call the API with the scanned data

//           // String msg = await BookingServices.checkInCustomer(result!.code!);
//         }
//       }
//     });
//   }

//   void onPermissionSet(
//       BuildContext context, QRViewController ctrl, bool permission) {
//     if (!permission) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('No permission')));
//     }
//   }

//   void showConfirmDialog(String id) {
//     QuickAlert.show(
//         context: context,
//         type: QuickAlertType.confirm,
//         title: 'Xác nhận',
//         text:
//             'Bạn chắc chắn muốn điểm danh khách hàng này? Hành động này không thể hoàn tác!',
//         showConfirmBtn: true,
//         confirmBtnText: 'Xác nhận',
//         cancelBtnText: 'Hủy',
//         onConfirmBtnTap: () {
//           checkin(id);
//         });
//   }

//   void showAlertSuccess() {
//     QuickAlert.show(
//       context: context,
//       type: QuickAlertType.success,
//       title: 'Thành công',
//       text: 'Bạn đã điểm danh thành công!',
//     );
//   }

//   void showAlertFail(String response) {
//     QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         text: response,
//         title: 'Thất bại');
//   }

//   void checkin(String id) async {
//     String msg = await BookingServices.checkInCustomer(id, widget.tour.tourId!);
//     if (msg == "Check-in success") {
//       setState(() {
//         notiMsg = "Take attendance successfully";
//       });
//     } else if (msg == "Check-in fail") {
//       setState(() {
//         notiMsg = "An error occured";
//       });
//     } else {
//       setState(() {
//         notiMsg = msg;
//       });
//     }
//   }

//   Widget _showResult(Booking? booking) {
//     return Center(
//       child: FutureBuilder<dynamic>(
//         future: showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return WillPopScope(
//               child: AlertDialog(
//                   title: Row(
//                     children: [
//                       const Text(
//                         'Scan Result!',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                           onPressed: () {
//                             setState(() {
//                               _isDialogOpen = false;
//                             });
//                             _controller?.resumeCamera();
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.close))
//                     ],
//                   ),
//                   content: SizedBox(
//                     width: MediaQuery.of(context).size.width - kMediumPadding,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 'Email: ',
//                                 style:
//                                     TextStyles.defaultStyle.subTitleTextColor,
//                               ),
//                               Flexible(
//                                 child: Text(
//                                   booking!.bookingUser!.email ?? '',
//                                   style: TextStyles.defaultStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: kDefaultIconSize / 2),
//                           Row(
//                             children: [
//                               Text(
//                                 'Customer Name: ',
//                                 style:
//                                     TextStyles.defaultStyle.subTitleTextColor,
//                               ),
//                               Flexible(
//                                 child: Text(
//                                   booking.bookingUser!.name ?? '',
//                                   style: TextStyles.defaultStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: kDefaultIconSize / 2),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Phone number: ',
//                                 style:
//                                     TextStyles.defaultStyle.subTitleTextColor,
//                               ),
//                               Flexible(
//                                 child: Text(
//                                   booking.bookingUser!.phone ?? '',
//                                   style: TextStyles.defaultStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: kDefaultIconSize / 2),
//                           for (var i = 0; i < booking.tickets!.length; i++)
//                             Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       booking.tickets![i].bookingDetailTicket!
//                                           .ticketTypeName!,
//                                       style: TextStyles
//                                           .defaultStyle.subTitleTextColor,
//                                     ),
//                                     Text(
//                                       ': ${booking.tickets![i].quantity}',
//                                       style: TextStyles.defaultStyle,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: kDefaultIconSize / 2),
//                               ],
//                             ),
//                           const SizedBox(height: kDefaultIconSize),
//                           const SizedBox(height: kDefaultIconSize),
//                           ButtonWidget(
//                             isIcon: false,
//                             title: 'Checkout',
//                             ontap: () {
//                               showConfirmDialog(booking.bookingId!);
//                             },
//                             color: const Color.fromARGB(168, 0, 0, 0),
//                             textStyle: TextStyles.regularStyle.whiteTextColor,
//                           ),
//                           const SizedBox(height: kMediumPadding * 2),
//                         ],
//                       ),
//                     ),
//                   )),
//               onWillPop: () async => false,
//             );
//           },
//         ),
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           return snapshot.data;
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/representation/screens/driver/tour_screen.dart';
import 'package:nbtour/representation/widgets/button_widget/button_widget.dart';
import 'package:nbtour/services/api/booking_service.dart';
import 'package:nbtour/services/models/booking_model.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key, required this.tour});

  final Tour tour;

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
  String notiMsg = "";
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
      body: SizedBox(
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

  void checkin(String id) async {
    String msg = await BookingServices.checkInCustomer(id, widget.tour.tourId!);
    if (msg == "Check-in success") {
      showAlertSuccess();
    } else if (msg == "Check-in fail") {
      showAlertFail(msg);
    } else {
      showAlertFail(msg);
    }
  }

  void showConfirmDialog(String id) {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.question,
            title: 'Xác nhận điểm danh',
            desc:
                'Xác nhận điểm danh cho khách hàng? Bạn khong thể hoàn tác tác vụ này sau khi nhấn Xác Nhận!',
            btnOkOnPress: () {
              checkin(id);
            },
            btnOkText: 'Xác nhận',
            btnCancelText: 'Quay lại',
            btnCancelOnPress: () {})
        .show();
  }

  void showAlertSuccess() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      title: 'Đã điểm danh',
      desc: 'Điểm danh thành công',
      btnOkOnPress: () {},
      btnOkText: 'Xác nhận',
    ).show();
  }

  void showAlertFail(String response) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      title: 'Điểm danh thất bại',
      desc: response,
      btnOkOnPress: () {},
      btnOkText: 'Xác nhận',
    ).show();
  }

  void showAlertNotFound() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      title: 'Không tìm thấy đơn hàng',
      desc: 'Đơn hàng không tồn tại!',
      btnOkOnPress: () {},
      btnOkText: 'Xác nhận',
    ).show();
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

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      _controller = qrController;
    });

    _controller?.scannedDataStream.listen((event) async {
      setState(() {
        result = event;
        _controller?.pauseCamera();
      });
      if (result?.code != null) {
        print("QR code Scanned and showing Result");
        if (!_isDialogOpen) {
          _isDialogOpen = true;

          // Call the API with the scanned data
          Booking? booking = await BookingServices.getBookingByBookingDetailId(
              result?.code?.substring(11));
          if (booking != null) {
            _showResult(booking);
          } else {
            showAlertNotFound();
          }
        }
      }
    });
  }

  void onPermissionSet(
      BuildContext context, QRViewController ctrl, bool permission) {
    if (!permission) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No permission')));
    }
  }

  Widget _showResult(Booking? booking) {
    return Center(
      child: FutureBuilder<dynamic>(
        future: showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                title: Row(
                  children: [
                    const Text(
                      'Hành khách',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isDialogOpen = false;
                          });
                          _controller?.resumeCamera();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width - kMediumPadding,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Flexible(
                            child: Text(
                              booking!.bookingUser!.name ?? '',
                              style: TextStyles.defaultStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: kDefaultIconSize / 4),
                        const Divider(),
                        const SizedBox(height: kDefaultIconSize / 4),
                        SizedBox(
                          child: Flexible(
                            child: Text(
                              booking.bookingUser!.email ?? '',
                              style: TextStyles.defaultStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: kDefaultIconSize / 4),
                        const Divider(),
                        const SizedBox(height: kDefaultIconSize / 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Trạm: ',
                              style: TextStyles.defaultStyle.subTitleTextColor,
                            ),
                            Flexible(
                              child: Text(
                                booking.bookingDepartureStation!.stationName ??
                                    '',
                                style: TextStyles.defaultStyle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kDefaultIconSize / 4),
                        const Divider(),
                        const SizedBox(height: kDefaultIconSize / 4),
                        if (booking.tickets!.isNotEmpty)
                          for (var i = 0; i < booking.tickets!.length; i++)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking.tickets![i].bookingDetailTicket !=
                                              null
                                          ? booking
                                                  .tickets![i]
                                                  .bookingDetailTicket!
                                                  .ticketType!
                                                  .ticketTypeName ??
                                              'Vé'
                                          : 'Vé',
                                      style: TextStyles
                                          .defaultStyle.subTitleTextColor,
                                    ),
                                    Text(
                                      ': ${booking.tickets![i].quantity}',
                                      style: TextStyles.defaultStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: kDefaultIconSize / 4),
                                const Divider(),
                                const SizedBox(height: kDefaultIconSize / 4),
                              ],
                            ),
                        const SizedBox(height: kDefaultIconSize),
                        ButtonWidget(
                          isIcon: false,
                          title: 'Xác nhận',
                          ontap: () {
                            showConfirmDialog(booking.bookingId!);
                          },
                          color: ColorPalette.primaryColor,
                          textStyle: TextStyles.regularStyle.whiteTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onWillPop: () async => false,
            );
          },
        ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Container();
        },
      ),
    );
  }
}
