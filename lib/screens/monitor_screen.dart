import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../core/app_format.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../core/sensor_rules.dart';
import '../models/device_model.dart';
import '../models/sensor_reading.dart';
import '../providers/device_provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/toast_provider.dart';
import '../widgets/app_icon.dart';
import '../widgets/eyebrow.dart';
import '../widgets/gauge_card.dart';
import '../widgets/icon_bubble.dart';
import '../widgets/page_title.dart';
import '../widgets/refresh_button.dart';
import '../widgets/section_heading.dart';
import '../widgets/sensor_line_chart.dart';
import '../widgets/soft_card.dart';

/// Pengaturan tampilan satu jenis sensor pada grafik.
class _MetricStyle {
  const _MetricStyle(this.label, this.unit, this.color, this.icon);

  final String label;
  final String unit;
  final Color color;
  final AppIcons icon;
}

const Map<SensorMetric, _MetricStyle> _metricStyles = {
  SensorMetric.temperature: _MetricStyle('Suhu', '°C', Color(0xFFD64270), AppIcons.temp),
  SensorMetric.humidity: _MetricStyle('Lembap', '%', Color(0xFF3D8199), AppIcons.water),
  SensorMetric.light: _MetricStyle('Cahaya', '%', Color(0xFFA77832), AppIcons.sun),
};

/// Halaman MONITORING: gauge, grafik tren, status, dan data sensor terbaru.
///
/// Ini StatefulWidget karena ada state lokal yang hanya dipakai di layar ini:
/// sensor mana yang sedang dipilih di grafik ([_metric]).
class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  SensorMetric _metric = SensorMetric.temperature;

  Future<void> _refresh() async {
    final ok = await context.read<DeviceProvider>().refresh();
    if (!mounted) return;
    context.read<ToastProvider>().show(
          ok ? 'Data sensor diperbarui' : 'Gagal memperbarui. Periksa koneksi internet.',
        );
  }

  String _formatValue(SensorMetric metric, double? value) {
    if (value == null) return '--';
    return metric == SensorMetric.temperature ? value.toStringAsFixed(1) : value.round().toString();
  }

  double _fraction(double? value, double max) {
    if (value == null) return 0;
    return (value / max).clamp(0.0, 1.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final device = context.watch<DeviceProvider>().selectedDevice;
    final sensor = context.watch<SensorProvider>();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final style = _metricStyles[_metric]!;
    final chartData = sensor.chartReadings;
    final values = chartData.map((r) => r.valueOf(_metric)).toList();
    final current = values.isEmpty ? null : values.last;
    final average = values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length;

    final eyebrow = device == null
        ? 'BELUM ADA PERANGKAT'
        : '${device.id} · ${device.isOnline ? 'ONLINE' : 'OFFLINE'}';

    return ListView(
      padding: EdgeInsets.fromLTRB(17, 0, 17, 110 + bottomInset),
      children: [
        PageTitle(
          eyebrow: eyebrow,
          title: 'Monitoring',
          trailing: RefreshButton(onRefresh: _refresh),
        ),

        // ---- Dua lingkaran gauge ----
        Row(
          children: [
            Expanded(
              child: GaugeCard(
                icon: AppIcons.temp,
                valueText: device?.temperature == null ? '--' : '${device!.temperature!.toStringAsFixed(1)}°',
                label: 'SUHU',
                fraction: _fraction(device?.temperature, AppConstants.gaugeTempScale),
                color: AppColors.pink500,
                trackColor: const Color(0xFFF5E7EB),
                idealText: '28–30°C',
                radius: AppRadius.leaf(28, 10),
                tintColor: const Color(0xFFFFF8FA),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GaugeCard(
                icon: AppIcons.water,
                valueText: device?.humidity == null ? '--' : '${device!.humidity!.round()}%',
                label: 'LEMBAP',
                fraction: _fraction(device?.humidity, 100),
                color: const Color(0xFF4F8A9D),
                trackColor: const Color(0xFFE7F1F3),
                idealText: '70–80%',
                radius: AppRadius.leafRight(28, 10),
                tintColor: const Color(0xFFF5FBFC),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ---- Kartu grafik ----
        SoftCard(
          radius: AppRadius.leaf(29, 10),
          padding: const EdgeInsets.fromLTRB(15, 17, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow('TREN'),
                        const SizedBox(height: 4),
                        Text(style.label, style: AppText.sans(size: 17, weight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  _RangePicker(current: sensor.range),
                ],
              ),
              const SizedBox(height: 14),
              _MetricSwitch(
                selected: _metric,
                onSelected: (m) => setState(() => _metric = m),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TERKINI',
                          style: AppText.sans(
                            size: 9,
                            weight: FontWeight.w800,
                            letterSpacing: 1,
                            color: const Color(0xFF9D9298),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _formatValue(_metric, current),
                                style: AppText.mono(size: 28, letterSpacing: -1.5),
                              ),
                              TextSpan(
                                text: ' ${style.unit}',
                                style: AppText.sans(size: 12, color: const Color(0xFF9B9096)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rata-rata ',
                            style: AppText.sans(size: 11, color: const Color(0xFF988E94)),
                          ),
                          TextSpan(
                            text: '${_formatValue(_metric, average)}${style.unit}',
                            style: AppText.sans(size: 11, weight: FontWeight.w800, color: const Color(0xFF5F555B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (sensor.isLoading && !sensor.hasData)
                const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.pink500)),
                )
              else if (!sensor.hasData)
                SizedBox(
                  height: 150,
                  child: Center(
                    child: Text(
                      sensor.hasError
                          ? 'Gagal memuat data sensor'
                          : 'Belum ada data sensor\nuntuk rentang ini',
                      textAlign: TextAlign.center,
                      style: AppText.sans(size: 12, color: AppColors.muted),
                    ),
                  ),
                )
              else
                SensorLineChart(
                  values: values,
                  labels: chartData.map(sensor.chartLabel).toList(),
                  color: style.color,
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _InsightCard(device: device),
        const SizedBox(height: 22),

        // ---- Daftar data sensor terbaru ----
        SectionHeading(
          eyebrow: 'TERBARU',
          title: 'Data sensor',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.pink50,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '${sensor.latestReadings.length} DATA',
              style: AppText.mono(size: 9, weight: FontWeight.w500, color: AppColors.pink600, letterSpacing: 0.7),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (sensor.latestReadings.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(child: Text('Belum ada data', style: AppText.sans(size: 12, color: AppColors.muted))),
          )
        else
          for (var i = 0; i < sensor.latestReadings.length; i++)
            _RecordRow(
              reading: sensor.latestReadings[i],
              isLatest: i == 0,
              trend: _trend(sensor.latestReadings, i),
            ),
      ],
    );
  }

  /// Panah tren suhu dibanding data sebelumnya.
  String _trend(List<SensorReading> list, int index) {
    if (index + 1 >= list.length) return '—';
    final diff = list[index].temperature - list[index + 1].temperature;
    if (diff > 0.05) return '↗';
    if (diff < -0.05) return '↘';
    return '—';
  }
}

/// Pilihan rentang waktu (Hari ini / 7 hari / 30 hari).
class _RangePicker extends StatelessWidget {
  const _RangePicker({required this.current});

  final SensorRange current;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SensorRange>(
      initialValue: current,
      onSelected: context.read<SensorProvider>().setRange,
      itemBuilder: (_) => [
        for (final range in SensorRange.values)
          PopupMenuItem(value: range, child: Text(range.label)),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(242, 234, 237, 0.8),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current.label,
              style: AppText.sans(size: 11, weight: FontWeight.w700, color: const Color(0xFF655B62)),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF655B62)),
          ],
        ),
      ),
    );
  }
}

/// Tiga tombol pemilih sensor (Suhu / Lembap / Cahaya).
class _MetricSwitch extends StatelessWidget {
  const _MetricSwitch({required this.selected, required this.onSelected});

  final SensorMetric selected;
  final ValueChanged<SensorMetric> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(241, 235, 237, 0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          for (final metric in SensorMetric.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelected(metric),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 34,
                  decoration: BoxDecoration(
                    color: selected == metric ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: selected == metric
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon(
                        _metricStyles[metric]!.icon,
                        size: 14,
                        color: selected == metric ? _metricStyles[metric]!.color : const Color(0xFF897F85),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _metricStyles[metric]!.label,
                        style: AppText.sans(
                          size: 11,
                          weight: FontWeight.w700,
                          color: selected == metric ? _metricStyles[metric]!.color : const Color(0xFF897F85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Kartu hijau (atau kuning) yang merangkum kondisi tumbuh.
class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.device});

  final DeviceModel? device;

  @override
  Widget build(BuildContext context) {
    final String title;
    final String message;
    final bool good;

    if (device == null) {
      title = 'Belum ada perangkat';
      message = 'Tambahkan perangkat untuk mulai memantau.';
      good = false;
    } else if (!device!.isOnline) {
      title = 'Perangkat offline';
      message = 'Data terbaru belum bisa diterima.';
      good = false;
    } else if (SensorRules.isTemperatureIdeal(device!.temperature) &&
        SensorRules.isHumidityIdeal(device!.humidity)) {
      title = 'Kondisi tumbuh optimal';
      message = 'Semua sensor ideal.';
      good = true;
    } else {
      title = 'Perlu perhatian';
      message = 'Suhu: ${SensorRules.temperatureNote(device!.temperature)} · '
          'Kelembapan: ${SensorRules.humidityNote(device!.humidity)}';
      good = false;
    }

    final textColor = good ? const Color(0xFF34634F) : const Color(0xFF8A6830);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: AppRadius.leaf(22, 8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: good
              ? const [Color(0xFFE8F5ED), Color(0xFFF5FAED)]
              : const [Color(0xFFFFF4DA), Color(0xFFFFF9EC)],
        ),
      ),
      child: Row(
        children: [
          IconBubble(
            icon: AppIcons.leaf,
            iconColor: textColor,
            background: Colors.white,
            size: 40,
            iconSize: 22,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.sans(size: 13, weight: FontWeight.w800, color: textColor)),
                const SizedBox(height: 3),
                Text(message, style: AppText.sans(size: 11, color: textColor.withValues(alpha: 0.8))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Satu baris pada daftar "Data sensor".
class _RecordRow extends StatelessWidget {
  const _RecordRow({required this.reading, required this.isLatest, required this.trend});

  final SensorReading reading;
  final bool isLatest;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.leaf(20, 7),
        border: Border.all(color: const Color.fromRGBO(104, 64, 79, 0.07)),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(80, 46, 59, 0.055), blurRadius: 23, offset: Offset(0, 9)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isLatest ? const Color(0xFF51A37C) : const Color(0xFFC9BEC3),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  AppFormat.time(reading.createdAt),
                  style: AppText.mono(size: 11, color: const Color(0xFF6F6269)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _RecordMetric(
              icon: AppIcons.temp,
              label: 'SUHU',
              value: '${reading.temperature.toStringAsFixed(1)}°',
              color: const Color(0xFFC13A63),
              background: const Color(0xFFFFF0F4),
            ),
          ),
          Expanded(
            child: _RecordMetric(
              icon: AppIcons.water,
              label: 'LEMBAP',
              value: '${reading.humidity.round()}%',
              color: const Color(0xFF397B92),
              background: const Color(0xFFECF7FA),
            ),
          ),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7F1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(trend, style: AppText.sans(size: 12, weight: FontWeight.w700, color: const Color(0xFF428564))),
          ),
        ],
      ),
    );
  }
}

class _RecordMetric extends StatelessWidget {
  const _RecordMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final AppIcons icon;
  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBubble(icon: icon, iconColor: color, background: background, size: 30, iconSize: 14),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppText.sans(size: 8, weight: FontWeight.w800, color: const Color(0xFFA0949A))),
            Text(value, style: AppText.mono(size: 13)),
          ],
        ),
      ],
    );
  }
}
