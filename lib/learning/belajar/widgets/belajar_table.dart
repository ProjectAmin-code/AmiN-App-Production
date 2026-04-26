import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/belajar_tokens.dart';
import '../models/belajar_table_content.dart';
import '../models/lesson_theme_variant.dart';

class BelajarTable extends StatelessWidget {
  const BelajarTable({super.key, required this.table, required this.palette});

  final BelajarTableContent table;
  final BelajarThemePalette palette;

  @override
  Widget build(BuildContext context) {
    if (table.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final minWidth =
            table.headers.length * BelajarTokens.tableMinColumnWidth;
        final tableWidth = math.max(constraints.maxWidth, minWidth);

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BelajarTokens.radiusMd),
            border: Border.all(color: palette.tableBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(BelajarTokens.radiusMd),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder(
                    horizontalInside: BorderSide(color: palette.tableBorder),
                    verticalInside: BorderSide(color: palette.tableBorder),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: palette.tableHeaderBackground,
                      ),
                      children: table.headers
                          .map(
                            (header) => _cell(
                              context: context,
                              text: header,
                              textColor: palette.tableHeaderForeground,
                              fontSize: BelajarTokens.tableHeaderFontSize,
                              fontWeight: BelajarTokens.tableHeaderWeight,
                              align: TextAlign.center,
                            ),
                          )
                          .toList(),
                    ),
                    ...table.rows.asMap().entries.map((entry) {
                      final rowIndex = entry.key;
                      final row = entry.value;
                      final rowColor = rowIndex.isEven
                          ? palette.tableRowEven
                          : palette.tableRowOdd;
                      final cells = List<String>.generate(
                        table.headers.length,
                        (index) =>
                            index < row.cells.length ? row.cells[index] : '',
                      );
                      return TableRow(
                        decoration: BoxDecoration(color: rowColor),
                        children: cells
                            .map(
                              (value) => _cell(
                                context: context,
                                text: value,
                                textColor: palette.bodyColor,
                                fontSize: BelajarTokens.tableCellFontSize,
                                fontWeight: BelajarTokens.tableCellWeight,
                                align: TextAlign.center,
                              ),
                            )
                            .toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cell({
    required BuildContext context,
    required String text,
    required Color textColor,
    required double fontSize,
    required FontWeight fontWeight,
    required TextAlign align,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BelajarTokens.tableCellHorizontalPadding,
        vertical: BelajarTokens.tableCellVerticalPadding,
      ),
      child: Text(
        text,
        textAlign: align,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontFamily: BelajarTokens.fontFamily,
          fontFamilyFallback: BelajarTokens.fontFallback,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
          height: 1.3,
        ),
      ),
    );
  }
}
