import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taugeku_mobile03/firebase_options.dart';

import 'core/app_colors.dart';
import 'core/app_constants.dart';
import 'core/app_theme.dart';
import 'providers/activity_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/batch_provider.dart';
import 'providers/device_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/toast_provider.dart';
import 'providers/watering_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

/// Titik awal aplikasi. Dijalankan pertama kali saat aplikasi dibuka.
Future<void> main() async {
  // Wajib dipanggil sebelum memakai plugin (Firebase) sebelum runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Aplikasi hanya tampil tegak (portrait), sesuai desain.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Menyambungkan aplikasi ke project Firebase Anda.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const TaugeKuApp());
}

/// Akar aplikasi: mendaftarkan SEMUA provider, lalu menjalankan MaterialApp.
///
/// Dua jenis provider yang dipakai:
///
/// 1. `ChangeNotifierProvider`
///    Provider biasa yang berdiri sendiri (Auth, Navigation, Toast).
///
/// 2. `ChangeNotifierProxyProvider`
///    Provider yang BERGANTUNG pada provider lain. Contoh: DeviceProvider
///    butuh tahu siapa yang login (AuthProvider). Setiap kali AuthProvider
///    berubah (login/logout), fungsi `update` dipanggil dan kita memberi
///    tahu DeviceProvider siapa penggunanya lewat `setUser(...)`.
class TaugeKuApp extends StatelessWidget {
  const TaugeKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ---- Provider mandiri ----
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ToastProvider()),

        // ---- Provider yang bergantung pada pengguna yang login ----
        ChangeNotifierProxyProvider<AuthProvider, DeviceProvider>(
          create: (_) => DeviceProvider(),
          update: (_, auth, provider) => provider!..setUser(auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, BatchProvider>(
          create: (_) => BatchProvider(),
          update: (_, auth, provider) => provider!..setUser(auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ActivityProvider>(
          create: (_) => ActivityProvider(),
          update: (_, auth, provider) => provider!..setUser(auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, NotificationProvider>(
          create: (_) => NotificationProvider(),
          update: (_, auth, provider) => provider!..setUser(auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (_) => ProfileProvider(),
          update: (_, auth, provider) => provider!..syncWithAuth(auth.user),
        ),

        // ---- Provider yang bergantung pada pengguna DAN perangkat terpilih ----
        ChangeNotifierProxyProvider2<AuthProvider, DeviceProvider, SensorProvider>(
          create: (_) => SensorProvider(),
          update: (_, auth, devices, provider) => provider!
            ..setTarget(userId: auth.userId, deviceId: devices.selectedDevice?.id),
        ),
        ChangeNotifierProxyProvider2<AuthProvider, DeviceProvider, WateringProvider>(
          create: (_) => WateringProvider(),
          update: (_, auth, devices, provider) => provider!
            ..setTarget(
              userId: auth.userId,
              deviceId: devices.selectedDevice?.id,
              deviceOnline: devices.selectedDevice?.isOnline ?? false,
              isConnected: devices.isConnected ?? false,
              durationSeconds:
                  devices.selectedDevice?.wateringSeconds ?? AppConstants.wateringSeconds,
            ),
        ),
      ],
      child: MaterialApp(
        title: 'TaugeKu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}

/// Penjaga pintu: memilih halaman berdasarkan status login.
///
///   * Firebase belum menjawab  -> layar pembuka (loading)
///   * Sudah login              -> halaman utama
///   * Belum login              -> halaman login
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isInitializing) {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(child: CircularProgressIndicator(color: AppColors.pink500)),
      );
    }
    return auth.isLoggedIn ? const MainShell() : const LoginScreen();
  }
}

