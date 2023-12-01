// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/main.dart';

import 'package:nbtour/services/api/report_service.dart';
import 'package:nbtour/services/models/report_model.dart';

import 'package:nbtour/services/models/tracking_station_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/representation/widgets/button_widget/button_widget.dart';
import 'package:quickalert/quickalert.dart';

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key, required this.report});
  final Reports report;
  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

List<TrackingStations>? futureList;
List<TrackingStations> stationList = [];
TrackingStations? selectedStation;
String? bookingId;

class _ReportDetailScreenState extends State<ReportDetailScreen> {
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
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: kMediumPadding, right: kMediumPadding),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chi tiết',
                          style: TextStyles.defaultStyle.subTitleTextColor),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Text(widget.report.title!,
                          style: TextStyles.regularStyle.bold),
                      const SizedBox(height: kMediumPadding),
                      Text('Nội dung: ',
                          style: TextStyles.defaultStyle.subTitleTextColor),
                      const SizedBox(
                        height: kDefaultIconSize / 2,
                      ),
                      Text(
                          widget.report.description != null
                              ? widget.report.description!
                              : "",
                          style: TextStyles.defaultStyle),
                      const SizedBox(height: kDefaultIconSize / 4),
                      const Divider(),
                      const SizedBox(height: kDefaultIconSize / 4),
                      Text('Phản hồi: ',
                          style: TextStyles.defaultStyle.subTitleTextColor),
                      const SizedBox(
                        height: kDefaultIconSize / 2,
                      ),
                      Text(
                          widget.report.response != null
                              ? widget.report.response!
                              : "Chưa có phản hồi",
                          style: TextStyles.defaultStyle),
                      const SizedBox(height: kDefaultIconSize / 4),
                      const Divider(),
                      const SizedBox(height: kDefaultIconSize / 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Trạng thái đơn ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          const Spacer(),
                          if (widget.report.reportStatus == "Pending")
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding,
                                        vertical: kDefaultPadding / 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color.fromARGB(
                                            22, 158, 158, 158)),
                                    child: Text(
                                      widget.report.reportStatus!,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ),
                          if (widget.report.reportStatus == "Approved")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(24, 76, 175, 79)),
                              child: Text(
                                widget.report.reportStatus!,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          if (widget.report.reportStatus == "Rejected")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(24, 244, 67, 54)),
                              child: Text(
                                widget.report.reportStatus!,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          if (widget.report.reportStatus != "Pending" &&
                              widget.report.reportStatus != "Approved" &&
                              widget.report.reportStatus != "Rejected")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(19, 255, 235, 59)),
                              child: const Text(
                                "Not defined",
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: kMediumPadding * 2),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
