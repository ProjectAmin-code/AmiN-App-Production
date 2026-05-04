import 'package:flutter/material.dart';

import '../../features/intro/screens/s003_main_menu_screen.dart';
import '../motion/app_motion_navigation.dart';

void goToMainMenu(BuildContext context) {
  pushReplacementAdaptive(context, const S003MainMenuScreen());
}
