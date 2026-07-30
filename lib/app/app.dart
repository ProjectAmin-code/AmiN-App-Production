import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/navigation/app_router.dart';
import '../core/theme/app_theme.dart';
import '../shared/gamification/gamification.dart';
import '../shared/progress/progress_tracker.dart';

class AminApp extends ConsumerStatefulWidget {
  const AminApp({super.key});

  static final GamificationController _gamificationController =
      GamificationController();

  @override
  ConsumerState<AminApp> createState() => _AminAppState();
}

class _AminAppState extends ConsumerState<AminApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ProgressTracker.instance.registerActivity();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ProgressTracker.instance.onAppResumed();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      ProgressTracker.instance.onAppPaused();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return GamificationScope(
      controller: AminApp._gamificationController,
      child: MaterialApp.router(
        title: 'Amin App',
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (context, child) {
          return Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => ProgressTracker.instance.registerActivity(),
            child: GamificationOverlayHost(
              controller: AminApp._gamificationController,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
