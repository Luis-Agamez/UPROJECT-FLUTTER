import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messagge = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _streamController =
      StreamController.broadcast();

  static Stream<String> get MessageStream => _streamController.stream;

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    // print('on onMessageHandler ${message.messageId}');
    // print(message.data);
    _streamController.add(message.data['action'] ?? 'No action');
  }

  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    // print('backgroundMessageHandler ${message.messageId}');
    // print(message.data);
    _streamController.add(message.data['action'] ?? 'No action');
  }

  static Future<void> _onOpenMessaggeOpenApp(RemoteMessage message) async {
    // print('onOpenMessaggeOpenApp ${message.messageId}');
    // print(message.data);
    _streamController.add(message.data['action'] ?? 'No action');
  }

  static Future initializeApp() async {
    //Push Notifications

    //Local Notifications

    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenMessaggeOpenApp);
  }

  static closeStreams() {
    _streamController.close();
  }
}



























/* Variant: debugAndroidTest
Config: debug
Store: C:\Users\LUIS AGAMEZ\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 56:94:5B:C1:6E:A3:6F:D3:5D:0C:CD:05:DB:D5:DD:5D
SHA1: B2:12:BC:B0:08:91:34:8E:4D:A6:82:32:64:B4:B2:3A:2A:7E:F9:75
SHA-256: 0C:97:24:D8:0E:7D:56:A5:2A:61:7A:84:00:8F:AC:CD:00:FE:76:7F:C7:38:45:61:A6:AC:66:6A:4F:76:34:81
Valid until: jueves, 19 de octubre de 2051 */


