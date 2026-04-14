import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize({
    required void Function(RemoteMessage) onData,
  }) async {
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint(
      'Notification permission status: ${settings.authorizationStatus}',
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      debugPrint('Foreground message: ${message.messageId}');
      onData(message); 
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      debugPrint('Notification tapped: ${message.messageId}');
      onData(message); 
    });
      
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('Opened from terminated state: ${initialMessage.messageId}');
      onData(initialMessage);
    }
  }

  Future<String?> getToken() async {
    final token = await messaging.getToken();
    debugPrint('FCM token: $token');
    return token;
  }

  void listenToTokenRefresh(void Function(String token) onTokenRefresh) {
    messaging.onTokenRefresh.listen((token) {
      debugPrint('Refreshed FCM token: $token');
      onTokenRefresh(token);
    });
  }
}