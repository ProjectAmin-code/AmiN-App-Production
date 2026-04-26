import 'package:flutter/material.dart';

import 'learning_flow_screen.dart';

class BelajarFlowScreen extends StatelessWidget {
  const BelajarFlowScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return LearningFlowScreen(name: name);
  }
}
