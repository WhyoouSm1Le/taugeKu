import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'app_icon.dart';

/// Tombol bulat kecil untuk memperbarui data.
/// Selama [onRefresh] berjalan, ikon diganti indikator putar.
class RefreshButton extends StatefulWidget {
  const RefreshButton({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  bool _isRefreshing = false;

  Future<void> _handleTap() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    await widget.onRefresh();
    if (!mounted) return; // layar sudah ditutup -> jangan setState
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.line),
        ),
        alignment: Alignment.center,
        child: _isRefreshing
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.pink500),
              )
            : const AppIcon(AppIcons.refresh, size: 18, color: Color(0xFF5D535B)),
      ),
    );
  }
}
