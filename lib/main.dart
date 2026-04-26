import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/audio/audio_preloader.dart';
import 'shared/progress/progress_tracker.dart';
import 'shared/settings/app_settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressTracker.instance.initialize();
  await AppSettingsService.instance.initialize();
  await AudioPreloader.preloadDefaults();
  runApp(const ProviderScope(child: AminApp()));
}
