// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'services/fcm_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();

  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/images/cat.png';

  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    await _fcmService.initialize(
      onData: (message) {
        final assetName = message.data['asset'] ?? 'cat';

        setState(() {
          statusText = message.notification?.title ?? 'Payload received';
          imagePath = 'assets/images/$assetName.png';
        });
      },
    );

    final token = await _fcmService.getToken();
    debugPrint('Current device token: $token');
    
    _fcmService.listenToTokenRefresh((token) {
    debugPrint('Updated device token: $token');
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Image.asset(
              imagePath,
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/cat.png',
                  width: 200,
                  height: 200,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}