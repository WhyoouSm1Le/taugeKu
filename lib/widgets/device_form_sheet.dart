import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text.dart';
import '../models/device_model.dart';
import 'app_icon.dart';
import 'icon_bubble.dart';

/// Menampilkan form tambah / edit perangkat dari bawah layar.
///
/// * [existing] diisi  -> mode EDIT (ID perangkat tidak bisa diubah).
/// * [existing] kosong -> mode TAMBAH (ID awal diisi [suggestedId]).
///
/// Mengembalikan [DeviceModel] hasil isian, atau null jika dibatalkan.
/// Penyimpanan ke Firebase dilakukan oleh pemanggil (DevicesScreen).
Future<DeviceModel?> showDeviceFormSheet(
  BuildContext context, {
  DeviceModel? existing,
  required String suggestedId,
}) {
  return showModalBottomSheet<DeviceModel>(
    context: context,
    isScrollControlled: true, // agar sheet naik saat keyboard muncul
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(27)),
    ),
    builder: (sheetContext) => Padding(
      // Memberi ruang untuk keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
      child: _DeviceForm(existing: existing, suggestedId: suggestedId),
    ),
  );
}

class _DeviceForm extends StatefulWidget {
  const _DeviceForm({required this.existing, required this.suggestedId});

  final DeviceModel? existing;
  final String suggestedId;

  @override
  State<_DeviceForm> createState() => _DeviceFormState();
}

class _DeviceFormState extends State<_DeviceForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _idController;
  late final TextEditingController _locationController;
  late bool _isOnline;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final device = widget.existing;
    _nameController = TextEditingController(text: device?.name ?? 'Tauge Baru');
    _idController = TextEditingController(text: device?.id ?? widget.suggestedId);
    _locationController = TextEditingController(text: device?.location ?? 'Rak C · Dapur');
    _isOnline = device?.isOnline ?? true;
  }

  @override
  void dispose() {
    // Controller harus dibuang agar tidak boros memori.
    _nameController.dispose();
    _idController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    // validate() menjalankan semua validator; false jika ada isian yang salah.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).pop(
      DeviceModel(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        isOnline: _isOnline,
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  String? _validateId(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    // ID menjadi nama dokumen Firestore: tidak boleh ada spasi atau garis miring.
    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value.trim())) {
      return 'Hanya huruf, angka, - dan _';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 26),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gagang kecil di atas sheet
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5DCE0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              children: [
                const IconBubble(
                  icon: AppIcons.device,
                  iconColor: AppColors.pink600,
                  size: 44,
                  iconSize: 23,
                  background: AppColors.pink50,
                ),
                const SizedBox(width: 12),
                Text(
                  _isEditing ? 'Edit perangkat' : 'Tambah perangkat',
                  style: AppText.sans(size: 18, weight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _FieldLabel('Nama perangkat'),
            TextFormField(controller: _nameController, validator: _required),
            const SizedBox(height: 14),
            _FieldLabel('Device ID'),
            TextFormField(
              controller: _idController,
              validator: _validateId,
              readOnly: _isEditing, // ID = nama dokumen, tidak boleh berubah
              style: AppText.mono(size: 14, color: _isEditing ? AppColors.muted : AppColors.ink),
              decoration: InputDecoration(
                helperText: _isEditing ? 'ID tidak dapat diubah' : null,
              ),
            ),
            const SizedBox(height: 14),
            _FieldLabel('Lokasi'),
            TextFormField(controller: _locationController, validator: _required),
            const SizedBox(height: 14),
            _FieldLabel('Status'),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Online'),
                  selected: _isOnline,
                  onSelected: (_) => setState(() => _isOnline = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Offline'),
                  selected: !_isOnline,
                  onSelected: (_) => setState(() => _isOnline = false),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      side: const BorderSide(color: AppColors.line),
                      foregroundColor: AppColors.ink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Batal', style: AppText.sans(size: 13, weight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      backgroundColor: AppColors.pink600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _isEditing ? 'Simpan perubahan' : 'Tambah perangkat',
                      style: AppText.sans(size: 13, weight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppText.sans(size: 12, weight: FontWeight.w700, color: const Color(0xFF655B61)),
      ),
    );
  }
}
