import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/screens/tab_screen.dart';
import 'package:nbtour/representation/widgets/button_widget/rectangle_button_widget.dart';
import 'package:nbtour/services/api/payment_service.dart';
import 'package:nbtour/services/api/payment_stripe_service.dart';
import 'package:nbtour/services/models/invoice_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.invoice});

  final Invoices invoice;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntent;
  int _type = 1;

  void _handleRadio(Object? e) => setState(() {
        _type = e as int;
      });

  @override
  void initState() {
    super.initState();
  }

  void showAlertSuccess() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      title: 'Thành công',
      desc: 'Thanh toán thành công',
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
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
      dialogType: DialogType.warning,
      title: 'Thất bại',
      desc: response,
      btnOkOnPress: () {},
      btnOkText: 'Thực hiện lại',
      btnCancelText: 'Về trang chủ',
      btnCancelOnPress: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      },
    ).show();
  }

  void makePayment(int price) async {
    try {
      paymentIntent =
          await PaymentStripeServices.paymentStripe(price.toString());
      var gPay = const PaymentSheetGooglePay(
          merchantCountryCode: "SG", currencyCode: "VND", testEnv: true);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!["client_secret"],
              style: ThemeMode.dark,
              customFlow: true,
              allowsDelayedPaymentMethods: true,
              merchantDisplayName: sharedPreferences.getString("user_name"),
              googlePay: gPay));
      displayPaymentSheet();
    } catch (e) {
      showAlertFail('Số tiền quá lớn, vui lòng thử lại sau');
      print('FAIL');
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      var paid =
          await PaymentServices.paidBackToManager(widget.invoice.scheduleId);
      if (paid == 'Success') {
        showAlertSuccess();
      } else {
        showAlertFail(paid);
      }
    } catch (e) {
      showAlertFail('Thanh toán thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'Chọn hình thức thanh toán',
            style: TextStyles.regularStyle.bold.fontHeader,
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
              child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                width: size.width,
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.5, color: ColorPalette.primaryColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: 1,
                            onChanged: _handleRadio,
                            activeColor: ColorPalette.primaryColor,
                          ),
                          Text("Thanh toán bằng Visa",
                              style: TextStyles.regularStyle.bold),
                        ],
                      ),
                      Row(
                        children: [
                          ImageHelper.loadFromAsset(AssetHelper.payment,
                              width: 40, height: 40, fit: BoxFit.cover),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Số tiền cần thanh toán',
                      style: TextStyles.regularStyle.bold),
                  Text('${widget.invoice.paidBackPrice} vnđ',
                      style: TextStyles.regularStyle)
                ],
              ),
              const Spacer(),
              RectangleButtonWidget(
                  width: size.width - kDefaultPadding / 2,
                  title: 'THANH TOÁN',
                  ontap: () {
                    makePayment(widget.invoice.paidBackPrice!);
                  },
                  buttonColor: ColorPalette.primaryColor,
                  textStyle: TextStyles.defaultStyle.whiteTextColor.bold,
                  isIcon: false,
                  borderColor: Colors.transparent,
                  icon: const Icon(Icons.abc)),
              const SizedBox(
                height: 20,
              )
            ],
          )),
        ),
      ),
    );
  }
}
