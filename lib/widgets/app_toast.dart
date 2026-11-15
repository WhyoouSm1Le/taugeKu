import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../providers/toast_provider.dart';
import 'app_icon.dart';

/// Pesan singkat di bawah layar. Isinya diatur oleh [ToastProvider].
class AppToast extends StatelessWidget {
  const AppToast({super.key});

  @override
  Widget build(BuildContext context) {
    final message = context.select<ToastProvider, String?>((t) => t.message);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(animation),
          child: child,
        ),
      ),
      child: message == null
          ? const SizedBox.shrink(key: ValueKey('toast-empty'))
          : Container(
              key: ValueKey(message),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              constraints: const BoxConstraints(minHeight: 46),
              decoration: BoxDecoration(
                color: AppColors.toast,
                borderRadius: AppRadius.leaf(18, 7),
                boxShadow: const [
                  BoxShadow(color: Color.fromRGBO(30, 45, 38, 0.25), blurRadius: 30, offset: Offset(0, 10)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(color: Color(0xFF4C7966), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const AppIcon(AppIcons.check, size: 15, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      style: AppText.sans(size: 12, weight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
