import 'package:aplikasi_desa/auth/auth_provider.dart';
import 'package:aplikasi_desa/pages/request_surat_page.dart';
import 'package:aplikasi_desa/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:aplikasi_desa/services/api_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

// Navigator global
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Plugin notifikasi lokal
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Handler saat notifikasi diterima di background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showFlutterNotification(message);
}

// Menampilkan notifikasi lokal + payload
void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel', // harus sama dengan yang dikirim backend
          'Default Notifications',
          channelDescription: 'This channel is used for default notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['user_id'], // ambil user_id dari notifikasi
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Minta izin notifikasi (Android 13+)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Inisialisasi plugin lokal notifikasi
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      if (payload != null) {
        handleNotificationClick(payload);
      }
    },
  );

  // Handler notifikasi background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Saat aplikasi aktif (foreground), tampilkan notifikasi
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFlutterNotification(message);
    });

    return MaterialApp(
      navigatorKey: navigatorKey, // Penting untuk navigasi global
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// Navigasi saat notifikasi ditekan
void handleNotificationClick(String payload) {
  final userId = int.tryParse(payload);
  if (userId != null && navigatorKey.currentState != null) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => RequestSuratPage(userId: userId),
      ),
    );
  }
}

// Kirim FCM token ke backend
Future<void> sendFcmTokenToBackend(int userId) async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    final result = await ApiService.saveFcmToken(userId: userId, fcmToken: token);
    print('Send FCM token result: $result');
  }
}
