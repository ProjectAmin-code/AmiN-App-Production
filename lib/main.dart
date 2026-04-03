import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/audio/audio_preloader.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/gamification/gamification.dart';
import 'shared/progress/progress_tracker.dart';
import 'shared/settings/app_settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressTracker.instance.initialize();
  await AppSettingsService.instance.initialize();
  await AudioPreloader.preloadDefaults();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static final GamificationController _gamificationController =
      GamificationController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return GamificationScope(
      controller: _gamificationController,
      child: MaterialApp.router(
        title: 'Amin App',
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (context, child) {
          return GamificationOverlayHost(
            controller: _gamificationController,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
