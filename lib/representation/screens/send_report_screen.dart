// ignore_for_file: use_build_context_synchronously

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
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Send report successfully');
  }

  void showAlertFail() {
    QuickAlert.show(
        context: context, type: QuickAlertType.error, text: 'Send report fail');
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
      Navigator.of(context).pop();
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
              child: Text('Send report',
                  style: TextStyles.regularStyle.fontHeader),
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
                          cursorColor: ColorPalette.primaryColor,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.title_outlined),
                            prefixIconColor: Color.fromARGB(255, 112, 111, 111),
                            hintText: 'Enter title (Required)',
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
                              return 'Title is required';
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
                          cursorColor: ColorPalette.primaryColor,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description_outlined),
                            prefixIconColor: Color.fromARGB(255, 112, 111, 111),
                            hintText: 'Enter description (Optional)',
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
                              return 'Description is required';
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
                        title: 'SUBMIT',
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
