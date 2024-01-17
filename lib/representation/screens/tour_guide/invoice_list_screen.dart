import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/representation/screens/report_detail.dart';
import 'package:nbtour/representation/screens/send_report_screen.dart';
import 'package:nbtour/representation/screens/tour_guide/payment_screen.dart';
import 'package:nbtour/representation/widgets/invoice_item_widget.dart';
import 'package:nbtour/representation/widgets/report_list_widget.dart';
import 'package:nbtour/services/api/invoice_service.dart';
import 'package:nbtour/services/api/report_service.dart';
import 'package:nbtour/services/models/invoice_model.dart';
import 'package:nbtour/services/models/report_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/services/models/season_model.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userId = '';
String tourId = '';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});
  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTab = 0;
  bool isSearching = false;
  bool isLoading = true;
  List<Invoices> filteredSchedule = [];
  String _searchValue = '';
  List<Invoices> listTour = [];
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  initState() {
    super.initState();
    setState(() {});
    fetchUserId();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? fetchUserId = prefs.getString('user_id');
    if (fetchUserId != null) {
      setState(() {
        userId = fetchUserId;
      });
    }
  }

  void openAddExpenseOverlay() {
    showModalBottomSheet(
      showDragHandle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: SendReportScreen(
          onReportSent: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  void openReportOverlay(Reports report) {
    showModalBottomSheet(
      showDragHandle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,

          // child: TimelinesScreen(route: route)),
          child: ReportDetailScreen(
            report: report,
          )),
    );
  }

  List<Reports> filteredTours = []; // Store the filtered tours

  List<Season> selectedCategories = [];
  Widget loadPendingScheduledTour() {
    return FutureBuilder<List<Invoices>?>(
      future: InvoiceServices.getInvoiceList(userId, false),
      builder: (BuildContext context, AsyncSnapshot<List<Invoices>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding * 6),
            child: CircularProgressIndicator(color: ColorPalette.primaryColor),
          ));
        } else if (snapshot.hasData) {
          List<Invoices>? listScheduledTour = snapshot.data!;

          if (!isSearching) {
            filteredSchedule = listScheduledTour;
          }
          if (filteredSchedule.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: kDefaultPadding / 5,
                ),
                for (var i = 0; i < filteredSchedule.length; i++)
                  InvoiceItemWidget(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => PaymentScreen(
                                    invoice: filteredSchedule[i],
                                  )));
                    },

                    // announcementImage: Image.network(),
                    title: filteredSchedule[i].scheduleId!,
                    price: filteredSchedule[i].paidBackPrice.toString(),
                    status: "Đang chờ",
                  ),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
              ],
            );
          } else {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Không có dữ liệu'),
              ],
            ));
          }
        } else if (snapshot.hasError) {
          // Display an error message if the future completed with an error
          return Center(
              child: Column(
            children: [
              ImageHelper.loadFromAsset(AssetHelper.error),
              const SizedBox(height: 10),
              Text(
                snapshot.error.toString(),
                style: TextStyles.regularStyle,
              )
            ],
          ));
        } else {
          return const SizedBox(); // Return an empty container or widget if data is null
        }
      },
    );
  }

  Widget loadCompletedScheduledTour() {
    return FutureBuilder<List<Invoices>?>(
      future: InvoiceServices.getInvoiceList(userId, true),
      builder: (BuildContext context, AsyncSnapshot<List<Invoices>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding * 6),
            child: CircularProgressIndicator(color: ColorPalette.primaryColor),
          ));
        } else if (snapshot.hasData) {
          List<Invoices>? listScheduledTour = snapshot.data!;

          if (!isSearching) {
            filteredSchedule = listScheduledTour;
          }
          if (filteredSchedule.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: kDefaultPadding / 5,
                ),
                for (var i = 0; i < filteredSchedule.length; i++)
                  InvoiceItemWidget(
                    onTap: () {},

                    // announcementImage: Image.network(),
                    title: filteredSchedule[i].scheduleId!,
                    price: filteredSchedule[i].paidBackPrice.toString(),
                    status: "Hoàn tất",
                  ),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
              ],
            );
          } else {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Không có dữ liệu'),
              ],
            ));
          }
        } else if (snapshot.hasError) {
          // Display an error message if the future completed with an error
          return Center(
              child: Column(
            children: [
              ImageHelper.loadFromAsset(AssetHelper.error),
              const SizedBox(height: 10),
              Text(
                snapshot.error.toString(),
                style: TextStyles.regularStyle,
              )
            ],
          ));
        } else {
          return const SizedBox(); // Return an empty container or widget if data is null
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              labelStyle: TextStyles.defaultStyle,
              isScrollable: true,
              onTap: (int index) {
                setState(() {
                  selectedTab = index;
                  _tabController.index =
                      index; // Set the index of _tabController
                });
              },
              labelColor: ColorPalette.primaryColor,
              indicatorColor: ColorPalette.primaryColor,
              splashFactory: NoSplash.splashFactory,
              automaticIndicatorColorAdjustment: true,
              tabs: const [
                Tab(
                  text: 'Đang chờ',
                ),
                Tab(text: 'Đã hoàn thành'),
              ]),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Text(
            'Chọn 1 hóa đơn',
            style: TextStyles.defaultStyle.bold.fontHeader,
          ),
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            child: _tabController.index == 0
                ? loadPendingScheduledTour()
                : loadCompletedScheduledTour(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
