import 'dart:io';
import 'dart:js' as js;

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double lat, double lng) async {
    String url = '';
    url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    _launchUrl(url);
  }

  static void _launchUrl(url){
    js.context.callMethod('open', [url]);
  }
}