import 'package:flutter/material.dart';

import '../../design/app_design_tokens.dart';
import 'animated_kid_button.dart';

class RewardPopup extends StatelessWidget {
  const RewardPopup({
    super.key,
    required this.title,
    this.message = '',
    this.coins = 0,
    this.onClose,
  });

  final String title;
  final String message;
  final int coins;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            boxShadow: AppShadows.floaty,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.inventory_2_rounded,
                size: 48,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              if (message.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              if (coins > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on_rounded, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      '+$coins',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              AnimatedKidButton(
                label: 'Teruskan',
                onPressed: onClose,
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
