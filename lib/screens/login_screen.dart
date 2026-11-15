import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_icon.dart';
import '../widgets/eyebrow.dart';

/// Halaman masuk (login) dengan Firebase Authentication.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus(); // tutup keyboard
    // Jika berhasil, AuthGate otomatis pindah ke halaman utama.
    await context.read<AuthProvider>().signIn(
          _usernameController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final photoHeight = math.max(260.0, MediaQuery.of(context).size.height * 0.40);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---- Foto bagian atas ----
            SizedBox(
              height: photoHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/tauge.jpg', fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color.fromRGBO(22, 40, 30, 0.25), Color.fromRGBO(23, 32, 26, 0.85)],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.pink500,
                                  borderRadius: AppRadius.leaf(12, 5),
                                ),
                                alignment: Alignment.center,
                                child: const AppIcon(AppIcons.leaf, size: 22, color: Colors.white),
                              ),
                              const SizedBox(width: 9),
                              Text(
                                'TaugeKu',
                                style: AppText.sans(size: 19, weight: FontWeight.w800, color: Colors.white),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'GROW SMARTER',
                            style: AppText.sans(
                              size: 10,
                              weight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: const Color(0xFFFFC3D2),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Tumbuh baik,\ntanpa rumit.',
                            style: AppText.sans(
                              size: 30,
                              weight: FontWeight.w800,
                              letterSpacing: -1.2,
                              height: 1.08,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---- Form ----
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 26, 26, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('SELAMAT DATANG'),
                    const SizedBox(height: 4),
                    Text('Masuk', style: AppText.sans(size: 24, weight: FontWeight.w800, letterSpacing: -0.7)),
                    const SizedBox(height: 20),
                    _label('Username'),
                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => context.read<AuthProvider>().clearError(),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Username wajib diisi' : null,
                      decoration: const InputDecoration(
                        hintText: 'contoh: admin',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(13),
                          child: AppIcon(AppIcons.leaf, size: 17, color: AppColors.muted),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _label('Password'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      onChanged: (_) => context.read<AuthProvider>().clearError(),
                      validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(13),
                          child: AppIcon(AppIcons.settings, size: 17, color: AppColors.muted),
                        ),
                        suffixIcon: TextButton(
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                          child: Text(
                            _showPassword ? 'Tutup' : 'Lihat',
                            style: AppText.sans(size: 12, weight: FontWeight.w700, color: AppColors.pink600),
                          ),
                        ),
                      ),
                    ),
                    if (auth.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.dangerBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          auth.errorMessage!,
                          style: AppText.sans(size: 12, weight: FontWeight.w600, color: AppColors.danger),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pink600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.leaf(16, 6)),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                              )
                            : Text(
                                'Masuk  →',
                                style: AppText.sans(size: 14, weight: FontWeight.w800, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppText.sans(size: 12, weight: FontWeight.w700, color: const Color(0xFF655B61))),
    );
  }
}
