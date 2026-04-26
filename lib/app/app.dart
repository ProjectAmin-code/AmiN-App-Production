import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/navigation/app_router.dart';
import '../core/theme/app_theme.dart';
import '../shared/gamification/gamification.dart';

class AminApp extends ConsumerWidget {
  const AminApp({super.key});

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
