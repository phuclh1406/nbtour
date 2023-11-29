// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/representation/screens/tab_screen.dart';
import 'package:nbtour/representation/screens/tour_guide/home_screen.dart';
import 'package:nbtour/services/api/booking_service.dart';
import 'package:nbtour/services/api/payment_service.dart';
import 'package:nbtour/services/api/tracking_service.dart';
import 'package:nbtour/services/models/booking_ticket_model.dart';
import 'package:nbtour/services/models/ticket_model.dart';

import 'package:nbtour/services/models/tour_model.dart';

import 'package:nbtour/services/models/tracking_station_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';

import 'package:nbtour/representation/widgets/button_widget/button_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SubmitBookingScreen extends StatefulWidget {
  const SubmitBookingScreen({super.key, required this.tour});
  final Tour tour;
  @override
  State<SubmitBookingScreen> createState() => _SubmitBookingScreenState();
}

List<TrackingStations>? futureList;
List<TrackingStations> stationList = [];
TrackingStations? selectedStation;
String? bookingId;

class _SubmitBookingScreenState extends State<SubmitBookingScreen> {
  Future<String> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? roleName = prefs.getString('role_name');
    return roleName ?? ''; // Return an empty string if userName is null
  }

  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    return userId ?? ''; // Return an empty string if userName is null
  }

  Future<List<TrackingStations>?> fetchStations(String tourId) async {
    futureList = await TrackingServices.getTrackingStationsByTourId(tourId);
    if (futureList!.isNotEmpty) {
      stationList = [];
      for (var i = 0; i < futureList!.length - 1; i++) {
        if (futureList![i].status == "NotArrived" ||
            futureList![i].status == "Active") {
          stationList.add(futureList![i]);
          print(stationList.length);
        }
      }
      return stationList;
    } else {
      return [];
    }
  }

  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPhone = '';
  var _enteredName = '';
  var price = 0;
  var checkoutPrice = 0;
  List<Tickets> ticketList = [];
  List<Tickets> ticketCheckoutList = [];

  void showAlertSuccess() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      title: 'Đã thanh toán',
      desc: 'Thanh toán thành công',
      btnOkOnPress: () {},
      btnOkText: 'Xác nhận',
      btnCancelText: 'Về trang chủ',
      btnCancelOnPress: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      },
    ).show();
  }

  void showAlertFail(String response) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      title: 'Thanh toán thất bại',
      desc: 'Thanh toán thất bại, vui lòng kiểm tra lại thông tin!',
      btnOkOnPress: () {},
      btnOkText: 'Thực hiện lại',
      btnCancelText: 'Về trang chủ',
      btnCancelOnPress: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      },
    ).show();
  }

  void showConfirmDialog(String id) {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.question,
            title: 'Xác nhận thanh toán',
            desc:
                'Xác nhận đã nhận tiền đầy đủ và thanh toán tour này! Hành động này không thể hoàn tác sau khi bấm Xác nhận',
            btnOkOnPress: () {
              pay(id);
            },
            btnOkText: 'Xác nhận',
            btnCancelText: 'Quay lại',
            btnCancelOnPress: () {})
        .show();
  }

  void pay(String bookingId) async {
    String paymentCheck = await PaymentServices.paymentOffline(bookingId);
    if (paymentCheck == "Payment process successfully") {
      Navigator.of(context).pop();
      showAlertSuccess();
    } else {
      showAlertFail(paymentCheck);
    }
  }

  Widget checkout(String bookingId) {
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
                      'Chi tiết',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width - kMediumPadding,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Email: ',
                              style: TextStyles.defaultStyle.subTitleTextColor,
                            ),
                            Flexible(
                              child: Text(
                                _enteredEmail,
                                style: TextStyles.defaultStyle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kDefaultIconSize / 2),
                        Row(
                          children: [
                            Text(
                              'Họ và Tên: ',
                              style: TextStyles.defaultStyle.subTitleTextColor,
                            ),
                            Flexible(
                              child: Text(
                                _enteredName,
                                style: TextStyles.defaultStyle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kDefaultIconSize / 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Số điện thoại: ',
                              style: TextStyles.defaultStyle.subTitleTextColor,
                            ),
                            Flexible(
                              child: Text(
                                _enteredPhone,
                                style: TextStyles.defaultStyle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kDefaultIconSize / 2),
                        for (var i = 0; i < ticketCheckoutList.length; i++)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ticketCheckoutList[i]
                                        .ticketType!
                                        .ticketTypeName!,
                                    style: TextStyles
                                        .defaultStyle.subTitleTextColor,
                                  ),
                                  Text(
                                    ': ${ticketCheckoutList[i].quantity}',
                                    style: TextStyles.defaultStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(height: kDefaultIconSize / 2),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng giá: ',
                              style: TextStyles.defaultStyle.subTitleTextColor,
                            ),
                            Flexible(
                              child: Text(
                                '${checkoutPrice.toString()} vnđ',
                                style: TextStyles.defaultStyle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kDefaultIconSize),
                        const SizedBox(height: kDefaultIconSize),
                        ButtonWidget(
                          isIcon: false,
                          title: 'Thanh toán',
                          ontap: () {
                            showConfirmDialog(bookingId);
                          },
                          color: const Color.fromARGB(168, 0, 0, 0),
                          textStyle: TextStyles.regularStyle.whiteTextColor,
                        ),
                        const SizedBox(height: kMediumPadding * 2),
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
          throw UnimplementedError;
        },
      ),
    );
  }

  void _submit(BuildContext context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    bookingId = await BookingServices.bookingOffline(
        price,
        selectedStation!,
        widget.tour.tourId!,
        _enteredEmail,
        _enteredName,
        _enteredPhone,
        ticketList.toList());
    checkoutPrice = price;
    ticketCheckoutList = ticketList;
    print(ticketCheckoutList.length);
    price = 0;
    ticketList = [];
    if (bookingId != null) {
      checkout(bookingId!);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Fail')));
    }
  }

  void fetchTicketList() {
    for (var ticket in widget.tour.ticket) {
      ticketList.add(ticket);
    }
  }

  @override
  void initState() {
    super.initState();

    selectedStation = null;
    fetchStations(widget.tour.tourId!);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 255, 255, 255),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kMediumPadding / 2),
              child: Text('Mua vé',
                  style: TextStyles.regularStyle.subTitleTextColor),
            ),
            const SizedBox(height: kDefaultIconSize / 2),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kMediumPadding / 2),
                child: Text(widget.tour.tourName!,
                    style: TextStyles.regularStyle.bold)),
            const SizedBox(height: kMediumPadding),
            Form(
              key: _form,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMediumPadding / 2),
                        child: TextFormField(
                          cursorColor: ColorPalette.primaryColor,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            prefixIconColor: Color.fromARGB(255, 112, 111, 111),
                            hintText: 'Tên khách hàng (Bắt buộc)',
                            hintStyle: TextStyles.defaultStyle,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 246, 243, 243)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kMediumPadding / 2.5))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 62, 62, 62)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kMediumPadding / 2.5))),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Tên khách hàng không được bỏ trống';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredName = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: kMediumPadding),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMediumPadding / 2),
                        child: TextFormField(
                          cursorColor: ColorPalette.primaryColor,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            prefixIconColor: Color.fromARGB(255, 112, 111, 111),
                            hintText: 'Địa chỉ email (Không bắt buộc)',
                            hintStyle: TextStyles.defaultStyle,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 246, 243, 243)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kMediumPadding / 2.5))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 62, 62, 62)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kMediumPadding / 2.5))),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: kMediumPadding),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMediumPadding / 2),
                        child: TextFormField(
                          cursorColor: ColorPalette.primaryColor,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone_android_outlined),
                            prefixIconColor: Color.fromARGB(255, 112, 111, 111),
                            hintText: 'Số điện thoại (Bắt buộc)',
                            hintStyle: TextStyles.defaultStyle,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 246, 243, 243)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kMediumPadding / 2.5))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 62, 62, 62)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kMediumPadding / 2.5))),
                          ),
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().length != 10) {
                              return 'Số điện thoại phải có 10 chữ số';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPhone = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: kMediumPadding),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMediumPadding / 2),
                        child: DropdownButtonFormField<TrackingStations>(
                          alignment: AlignmentDirectional.bottomCenter,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.busSimple),
                            prefixIconColor: Color.fromARGB(255, 112, 111, 111),
                            labelText: 'Chọn trạm khởi hành',
                            labelStyle: TextStyles.defaultStyle,
                            hintText: 'Chọn trạm khởi hành',
                            hintStyle: TextStyles.defaultStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 246, 243, 243),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(kMediumPadding / 2.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 62, 62, 62),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(kMediumPadding / 2.5),
                              ),
                            ),
                          ),
                          onSaved: (value) {
                            // _enteredStation = value!;
                          },
                          items: stationList.map((station) {
                            return DropdownMenuItem<TrackingStations>(
                              value: station,
                              child: Text(
                                  station.tourDetailStation!.stationName!,
                                  style: TextStyles.defaultStyle),
                            );
                          }).toList(),
                          onChanged: (TrackingStations? newValue) {
                            setState(() {
                              selectedStation = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: kMediumPadding),
                      for (var i = 0; i < widget.tour.ticket.length; i++)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kMediumPadding / 2),
                              child: TextFormField(
                                cursorColor: ColorPalette.primaryColor,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(FontAwesomeIcons.ticket),
                                  prefixIconColor:
                                      const Color.fromARGB(255, 112, 111, 111),
                                  hintText:
                                      'Nhập số lượng ${widget.tour.ticket[i].ticketType!.ticketTypeName}',
                                  hintStyle: TextStyles.defaultStyle,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 246, 243, 243)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              kMediumPadding / 2.5))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 62, 62, 62)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              kMediumPadding / 2.5))),
                                ),
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                onSaved: (value) {
                                  widget.tour.ticket[i].quantity =
                                      int.parse(value!);
                                  ticketList.add(widget.tour.ticket[i]);

                                  price = price +
                                      int.parse(value) *
                                          widget.tour.ticket[i].ticketType!
                                              .price!.amount!;
                                },
                              ),
                            ),
                            const SizedBox(height: kMediumPadding),
                          ],
                        ),
                      ButtonWidget(
                        isIcon: false,
                        title: 'Xác nhận đặt vé',
                        ontap: () {
                          _submit(context);
                        },
                        color: ColorPalette.primaryColor,
                        textStyle: TextStyles.regularStyle.whiteTextColor,
                      ),
                      const SizedBox(height: kMediumPadding / 2),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: kMediumPadding / 2),
          ]),
        ),
      ),
    );
  }
}
