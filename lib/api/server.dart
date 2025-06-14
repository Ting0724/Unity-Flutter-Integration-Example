import 'dart:html' as html;
import 'package:flutter/foundation.dart';

late String server_IP;
late String APILocation;

class InitServer {
  static init() {
    String currentUrl = html.window.location.href;
    Uri uri = Uri.parse(currentUrl);
    String domain = uri.host;
    server_IP = domain;
    APILocation = 'http://' + server_IP + '/PHPtool/';
  }
}
