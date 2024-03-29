// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/main.dart';

import 'package:nbtour/services/api/report_service.dart';

import 'package:nbtour/services/models/tracking_station_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/representation/widgets/button_widget/button_widget.dart';
import 'package:quickalert/quickalert.dart';

class SendReportScreen extends StatefulWidget {
  const SendReportScreen({super.key, this.onReportSent});
  final Function()? onReportSent;
  @override
  State<SendReportScreen> createState() => _SendReportScreenState();
}

List<TrackingStations>? futureList;
List<TrackingStations> stationList = [];
TrackingStations? selectedStation;
String? bookingId;

class _SendReportScreenState extends State<SendReportScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredDescription = '';
  String userId = sharedPreferences.getString('user_id')!;

  void showAlertSuccess() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      title: 'Thành công',
      desc: 'Đã gửi đơn thành công',
      btnOkOnPress: () {},
      btnOkText: 'Xác nhận',
    ).show();
  }

  void showAlertFail() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      title: 'Thất bại',
      desc: 'Đã gửi đơn thất bại',
      btnOkOnPress: () {},
      btnOkText: 'Xác nhận',
    ).show();
  }

  void _submit(BuildContext context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    String reportResult = await ReportServices.sendReport(
      userId,
      _enteredTitle,
      _enteredDescription,
    );

    if (reportResult == 'Send report successfully') {
      showAlertSuccess();
      if (widget.onReportSent != null) {
        widget.onReportSent!();
      }
    } else {
      showAlertFail();
    }
  }

  @override
  void initState() {
    super.initState();
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
              child: Text('Gửi đơn', style: TextStyles.regularStyle.fontHeader),
            ),
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
                          maxLines: null,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.title_outlined),
                            prefixIconColor:
                                const Color.fromARGB(255, 112, 111, 111),
                            hintText: 'Nhập tiêu đề (Bắt buộc)',
                            hintStyle:
                                TextStyles.defaultStyle.subTitleTextColor,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 246, 243, 243)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kMediumPadding / 2.5))),
                            focusedBorder: const OutlineInputBorder(
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
                              return 'Tiêu đề không được bỏ trống';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredTitle = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: kMediumPadding),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMediumPadding / 2),
                        child: TextFormField(
                          maxLines: null,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.description_outlined),
                            prefixIconColor:
                                const Color.fromARGB(255, 112, 111, 111),
                            hintText: 'Nhập mô tả (Bắt buộc)',
                            hintStyle:
                                TextStyles.defaultStyle.subTitleTextColor,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 246, 243, 243)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kMediumPadding / 2.5))),
                            focusedBorder: const OutlineInputBorder(
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
                              return 'Mô tả không được bỏ trống';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredDescription = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: kMediumPadding),
                      ButtonWidget(
                        isIcon: false,
                        title: 'Gửi đơn',
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
