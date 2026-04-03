import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';

void goToMainMenu(BuildContext context) {
  final router = GoRouter.maybeOf(context);
  if (router != null) {
    context.go(AppRoutes.s003MainMenu);
    return;
  }
  Navigator.of(context).popUntil((route) => route.isFirst);
}
