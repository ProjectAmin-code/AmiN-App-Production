import 'package:flutter/material.dart';
import 'screens/screen0.dart'; // Import Screen0
import 'shared/design/app_theme.dart';
import 'shared/gamification/gamification.dart';
import 'shared/progress/progress_tracker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressTracker.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GamificationController _gamificationController =
      GamificationController();

  @override
  Widget build(BuildContext context) {
    return GamificationScope(
      controller: _gamificationController,
      child: MaterialApp(
        title: 'Amin App',
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return GamificationOverlayHost(
            controller: _gamificationController,
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const Screen0(), // Start with Screen0
      ),
    );
  }
}
