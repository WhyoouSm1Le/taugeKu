import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taugeku_mobile03/core/app_colors.dart';
import 'package:taugeku_mobile03/core/app_theme.dart';
import 'package:taugeku_mobile03/firebase_options.dart';
import 'package:taugeku_mobile03/providers/auth_provider.dart';
import 'package:taugeku_mobile03/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    DevicePreview(
      builder: (context) => const TaugeKuApp()
    ),
  );
}

class TaugeKuApp extends StatelessWidget {
  const TaugeKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isInitializing) {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.pink500,
          ),
        ),
      );
    }

    return auth.isLoggedIn ? const _PlaceholderHome() : const LoginScreen();
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().email ?? '-';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Berhasil Login!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Akun: $email'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<AuthProvider>().signOut(), 
              child: const Text('Keluar (Tes Logout)'),
            )
          ],
        ),
      ),
    );
  }
}