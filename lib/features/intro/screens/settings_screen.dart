import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_design_tokens.dart';
import '../../../core/widgets/animated_kid_button.dart';
import '../../../core/widgets/lesson_card.dart';
import '../../../shared/progress/progress_tracker.dart';
import '../../../shared/settings/app_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _recoverController;
  late final TextEditingController _pinController;
  bool _isRecovering = false;

  @override
  void initState() {
    super.initState();
    _recoverController = TextEditingController();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _recoverController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _recoverByUserId() async {
    final userId = _recoverController.text.trim();
    final pin = _pinController.text;
    if (userId.isEmpty || pin.length != 6 || _isRecovering) {
      return;
    }
    if (ProgressTracker.instance.hasPendingBackup) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kemajuan belum disandarkan'),
          content: const Text(
            'Pulihkan akaun lain hanya selepas kemajuan semasa disandarkan, atau kemajuan pada peranti ini mungkin hilang.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Teruskan')),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    setState(() => _isRecovering = true);
    final result = await ProgressTracker.instance.restoreFromStudentId(userId, pin);
    setState(() => _isRecovering = false);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));
    if (result.success) {
      context.go(AppRoutes.s003MainMenu);
    }
  }

  Future<void> _logout() async {
    if (ProgressTracker.instance.hasPendingBackup) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kemajuan belum disandarkan'),
          content: const Text(
            'Sebahagian kemajuan masih disimpan pada peranti ini sahaja. Log keluar boleh menyebabkan kemajuan itu hilang.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Log Keluar')),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await ProgressTracker.instance.clearUserIdentity(clearProgress: true);
    if (!mounted) {
      return;
    }
    context.go(AppRoutes.s002Welcome);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        AppSettingsService.instance,
        ProgressTracker.instance,
      ]),
      builder: (context, _) {
        final settings = AppSettingsService.instance;
        final tracker = ProgressTracker.instance;
        final displayName = tracker.userName.trim().isEmpty
            ? 'Pelajar'
            : tracker.userName;
        final displayUserId = tracker.userId.trim().isEmpty
            ? '(belum dijana)'
            : tracker.userId;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: const Text(
              'Tetapan',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              LessonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nama: $displayName',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID Pelajar: $displayUserId',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const LessonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maklumat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kemajuan disimpan pada peranti dan disandarkan secara automatik.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jika aplikasi dipasang semula, gunakan ID Pelajar dan PIN Pemulihan.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              LessonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pulihkan Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _recoverController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _recoverByUserId(),
                      decoration: const InputDecoration(
                        hintText: 'Masukkan ID Pelajar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        hintText: 'PIN Pemulihan 6 digit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedKidButton(
                      label: _isRecovering ? 'Memulihkan...' : 'Pulihkan',
                      icon: Icons.restore_rounded,
                      onPressed: _isRecovering ? null : _recoverByUserId,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                value: settings.voiceOverEnabled,
                title: const Text('Voice Over'),
                subtitle: const Text('Bacaan suara dalam modul belajar'),
                onChanged: settings.setVoiceOverEnabled,
              ),
              SwitchListTile(
                value: settings.soundEffectsEnabled,
                title: const Text('Kesan Bunyi'),
                subtitle: const Text('Bunyi jawapan betul/salah'),
                onChanged: settings.setSoundEffectsEnabled,
              ),
              SwitchListTile(
                value: settings.musicEnabled,
                title: const Text('Muzik Latar'),
                subtitle: const Text('Pilihan muzik latar (mod asas)'),
                onChanged: settings.setMusicEnabled,
              ),
              SwitchListTile(
                value: settings.gamificationOverlaysEnabled,
                title: const Text('Popup Ganjaran'),
                subtitle: const Text('Paparkan popup ganjaran/streak di skrin'),
                onChanged: settings.setGamificationOverlaysEnabled,
              ),
              const SizedBox(height: 8),
              AnimatedKidButton(
                label: tracker.isSyncing ? 'Sedang menyandar...' : 'Sandarkan sekarang',
                icon: Icons.cloud_upload_rounded,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await tracker.forceSync();
                  if (!mounted) {
                    return;
                  }
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Permintaan sandaran telah diproses.'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              AnimatedKidButton(
                label: 'Log Keluar',
                icon: Icons.logout_rounded,
                backgroundColor: const Color(0xFFD64545),
                onPressed: _logout,
              ),
            ],
          ),
        );
      },
    );
  }
}
