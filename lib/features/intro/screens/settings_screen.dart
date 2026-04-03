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
  bool _isRecovering = false;

  @override
  void initState() {
    super.initState();
    _recoverController = TextEditingController();
  }

  @override
  void dispose() {
    _recoverController.dispose();
    super.dispose();
  }

  Future<void> _recoverByUserId() async {
    final userId = _recoverController.text.trim();
    if (userId.isEmpty || _isRecovering) {
      return;
    }
    setState(() => _isRecovering = true);
    final result = await ProgressTracker.instance.restoreFromUserId(userId);
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
                      'User ID: $displayUserId',
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
                      'Data kemajuan dimuat naik automatik ke server.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jika aplikasi dipasang semula, gunakan User ID untuk pulihkan data.',
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
                      'Pulihkan Data Dengan User ID',
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
                        hintText: 'Masukkan User ID',
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
                subtitle: const Text('Paparkan popup XP/streak di skrin'),
                onChanged: settings.setGamificationOverlaysEnabled,
              ),
              const SizedBox(height: 8),
              AnimatedKidButton(
                label: 'Muat naik data sekarang',
                icon: Icons.cloud_upload_rounded,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await tracker.forceSync();
                  if (!mounted) {
                    return;
                  }
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Permintaan muat naik data dihantar.'),
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
