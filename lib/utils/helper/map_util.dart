import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    try {
      if (await canLaunchUrl(googleMapUrl)) {
        await launchUrl(googleMapUrl);
      } else {
        throw 'Cannot launch URL';
      }
    } catch (e) {
      print('Error launching URL: $e');
      throw 'Không thể mở app';
    }
  }
}
