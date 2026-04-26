import 'package:flutter/material.dart';

import '../features/intro/screens/s003_main_menu_screen.dart';
import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';
import '../shared/progress/progress_tracker.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key, required this.name});

  final String name;

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  static const List<_AffixExampleRow> _rows = [
    _AffixExampleRow(
      huruf: 'l',
      kataDasar: 'lukis',
      imbuhan: 'me-',
      kataBerimbuhan: 'melukis',
    ),
    _AffixExampleRow(
      huruf: 'm',
      kataDasar: 'masak',
      imbuhan: 'me-',
      kataBerimbuhan: 'memasak',
    ),
    _AffixExampleRow(
      huruf: 'n',
      kataDasar: 'nanti',
      imbuhan: 'me-',
      kataBerimbuhan: 'menanti',
    ),
    _AffixExampleRow(
      huruf: 'r',
      kataDasar: 'ronda',
      imbuhan: 'me-',
      kataBerimbuhan: 'meronda',
    ),
    _AffixExampleRow(
      huruf: 'w',
      kataDasar: 'warna',
      imbuhan: 'me-',
      kataBerimbuhan: 'mewarna',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressTracker.instance.setUserName(widget.name);
    });
  }

  void _goNext() {
    final gamification = GamificationScope.of(context);
    gamification.awardXp(10, reason: 'Selesai penerangan imbuhan me-');
    pushReplacementAdaptive(context, const S003MainMenuScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxWidth / 390)
                .clamp(0.92, 1.0)
                .toDouble();
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFCDE5F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Penggunaan imbuhan me-',
                                  style: TextStyle(
                                    fontSize: 34 * scale,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                    height: 1.05,
                                  ),
                                ),
                                SizedBox(height: 12 * scale),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F3F7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Gunakan imbuhan me- apabila kata dasar bermula dengan huruf: l, m, n, r, w, y.\nHuruf awal tidak berubah.',
                                    style: TextStyle(
                                      fontSize: 16 * scale,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12 * scale),
                                _buildAffixTable(scale),
                                SizedBox(height: 12 * scale),
                                Text(
                                  'Huruf lain seperti p, t, k dan s akan menyebabkan imbuhan meN- berubah.\nIni akan diterangkan dalam skrin seterusnya.',
                                  style: TextStyle(
                                    fontSize: 16 * scale,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    height: 1.35,
                                  ),
                                ),
                                SizedBox(height: 8 * scale),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                          child: AnimatedKidButton(
                            icon: Icons.arrow_forward_rounded,
                            label: 'Teruskan',
                            onPressed: _goNext,
                            backgroundColor: const Color(0xFFFFC300),
                            foregroundColor: const Color(0xFF0F2E56),
                            height: 52 * scale,
                            labelFontSize: 19 * scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAffixTable(double scale) {
    Widget headerCell(String text) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: const Color(0xFF0A7D95),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13 * scale,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
      );
    }

    Widget bodyCell(String text, bool isStriped) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: isStriped ? const Color(0xFFE2EBF2) : const Color(0xFFEEF4F8),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13 * scale,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: AppShadows.soft,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Table(
          border: TableBorder.all(color: const Color(0xFFD6E2EA), width: 0.8),
          columnWidths: const {
            0: FlexColumnWidth(0.9),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(1.0),
            3: FlexColumnWidth(1.7),
          },
          children: [
            TableRow(
              children: [
                headerCell('Huru\nf'),
                headerCell('Kata\nDasar'),
                headerCell('Imbu\nhan'),
                headerCell('Kata Ber\nimbuhan'),
              ],
            ),
            ..._rows.asMap().entries.map((entry) {
              final row = entry.value;
              final isStriped = entry.key.isOdd;
              return TableRow(
                children: [
                  bodyCell(row.huruf, isStriped),
                  bodyCell(row.kataDasar, isStriped),
                  bodyCell(row.imbuhan, isStriped),
                  bodyCell(row.kataBerimbuhan, isStriped),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AffixExampleRow {
  const _AffixExampleRow({
    required this.huruf,
    required this.kataDasar,
    required this.imbuhan,
    required this.kataBerimbuhan,
  });

  final String huruf;
  final String kataDasar;
  final String imbuhan;
  final String kataBerimbuhan;
}
