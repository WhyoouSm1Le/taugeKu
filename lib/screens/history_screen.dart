import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../providers/batch_provider.dart';
import '../providers/toast_provider.dart';
import '../widgets/app_icon.dart';
import '../widgets/batch_cards.dart';
import '../widgets/empty_state.dart';
import '../widgets/icon_bubble.dart';
import '../widgets/page_title.dart';

/// Pilihan filter pada halaman Riwayat.
enum _BatchFilter {
  active('Aktif'),
  finished('Selesai'),
  all('Semua');

  const _BatchFilter(this.label);
  final String label;
}

/// Halaman RIWAYAT: daftar siklus tanam (aktif & selesai).
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  _BatchFilter _filter = _BatchFilter.active;

  @override
  Widget build(BuildContext context) {
    final batches = context.watch<BatchProvider>();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final active = batches.activeBatches;
    final finished = batches.finishedBatches;

    final showActive = _filter != _BatchFilter.finished;
    final showFinished = _filter != _BatchFilter.active;
    final isEmpty = (showActive ? active.length : 0) + (showFinished ? finished.length : 0) == 0;

    void comingSoon() => context.read<ToastProvider>().show('Fitur ini akan segera hadir');

    return ListView(
      padding: EdgeInsets.fromLTRB(17, 0, 17, 110 + bottomInset),
      children: [
        PageTitle(
          eyebrow: 'RIWAYAT SIKLUS',
          title: 'Riwayat',
          subtitle: '${active.length} siklus aktif',
          trailing: GestureDetector(
            onTap: comingSoon,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.line),
              ),
              alignment: Alignment.center,
              child: const AppIcon(AppIcons.calendar, size: 18, color: Color(0xFF5D535B)),
            ),
          ),
        ),

        // ---- Kartu ringkasan ----
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppRadius.leaf(22, 8),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF1F4), Color(0xFFF6FAEE)],
            ),
          ),
          child: Row(
            children: [
              const IconBubble(
                icon: AppIcons.chart,
                iconColor: AppColors.pink600,
                background: Colors.white,
                size: 42,
                iconSize: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Catatan budidaya', style: AppText.sans(size: 13, weight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                      'Semua siklus tanam tersimpan di Firebase.',
                      style: AppText.sans(size: 11, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('${batches.totalCount}', style: AppText.mono(size: 22, color: AppColors.pink600)),
                  Text(
                    'SIKLUS',
                    style: AppText.sans(size: 8, weight: FontWeight.w800, letterSpacing: 1, color: AppColors.muted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---- Filter ----
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(241, 235, 237, 0.8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              for (final filter in _BatchFilter.values)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 36,
                      decoration: BoxDecoration(
                        color: _filter == filter ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: _filter == filter
                            ? const [
                                BoxShadow(
                                  color: Color.fromRGBO(66, 43, 52, 0.09),
                                  blurRadius: 13,
                                  offset: Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        filter.label,
                        style: AppText.sans(
                          size: 12,
                          weight: FontWeight.w700,
                          color: _filter == filter ? AppColors.pink600 : const Color(0xFF897F85),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ---- Daftar batch ----
        if (batches.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.pink500)),
          )
        else if (isEmpty)
          const EmptyState(
            icon: AppIcons.chart,
            title: 'Belum ada siklus',
            message: 'Siklus tanam akan tampil di sini setelah dibuat.',
          )
        else ...[
          if (showActive)
            for (final batch in active) ActiveBatchCard(batch: batch, onMore: comingSoon),
          if (showFinished)
            for (final batch in finished) FinishedBatchCard(batch: batch),
        ],
      ],
    );
  }
}
