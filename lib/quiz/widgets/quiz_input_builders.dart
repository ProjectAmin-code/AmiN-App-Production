import 'package:flutter/material.dart';

import '../constants/quiz_tokens.dart';
import '../models/quiz_level.dart';
import '../models/quiz_option.dart';
import '../models/quiz_question.dart';

const _firstQuestionOptionPurple = Color(0xFF8E6CFF);

Widget buildQuizMultiSelectInput({
  required QuizQuestion question,
  required List<QuizOption> options,
  required Set<String> selectedIds,
  required ValueChanged<QuizOption> onToggle,
}) {
  if (question.level == QuizLevel.easy && question.id == 'EK1') {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final columns = constraints.maxWidth >= 560
            ? 4
            : constraints.maxWidth >= 420
            ? 3
            : 2;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: options.map((option) {
            final selected = selectedIds.contains(option.id);
            return SizedBox(
              width: itemWidth,
              child: FilterChip(
                label: Center(child: Text(option.label)),
                selected: selected,
                showCheckmark: true,
                checkmarkColor: Colors.white,
                backgroundColor: _firstQuestionOptionPurple,
                selectedColor: _firstQuestionOptionPurple,
                side: BorderSide(
                  color: selected
                      ? const Color(0xFF6D4DE7)
                      : const Color(0xFF7F5AF0),
                  width: selected ? 2 : 1.4,
                ),
                onSelected: (_) => onToggle(option),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: QuizTokens.headingTextSize,
                  color: Colors.white,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: options.map((option) {
      final selected = selectedIds.contains(option.id);
      return FilterChip(
        label: Text(option.label),
        selected: selected,
        selectedColor: const Color(0xFFB8ECFF),
        onSelected: (_) => onToggle(option),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: QuizTokens.headingTextSize,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      );
    }).toList(),
  );
}

Widget buildQuizSingleChoiceInput({
  required List<QuizOption> options,
  required String? selectedValue,
  required ValueChanged<String> onSelect,
  String? questionId,
}) {
  final isEasyCompact =
      questionId != null && questionId.startsWith('EK') && questionId != 'EK1';
  const optionTextSize = QuizTokens.headingTextSize;

  return Column(
    children: options
        .map(
          (option) => InkWell(
            onTap: () => onSelect(option.id),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: EdgeInsets.only(bottom: isEasyCompact ? 8 : 14),
              padding: EdgeInsets.symmetric(
                horizontal: isEasyCompact ? 12 : 18,
                vertical: isEasyCompact ? 10 : 18,
              ),
              constraints: BoxConstraints(minHeight: isEasyCompact ? 56 : 82),
              decoration: BoxDecoration(
                color: selectedValue == option.id
                    ? QuizTokens.selectedOptionFill
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selectedValue == option.id
                      ? QuizTokens.selectedOptionBorder
                      : QuizTokens.idleOptionBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selectedValue == option.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: isEasyCompact ? 20 : 24,
                    color: selectedValue == option.id
                        ? QuizTokens.selectedOptionBorder
                        : Colors.grey,
                  ),
                  SizedBox(width: isEasyCompact ? 8 : 10),
                  Expanded(
                    child: Text(
                      option.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: optionTextSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList(),
  );
}

Widget buildQuizTextInput({
  required QuizQuestion question,
  required String currentValue,
  required ValueChanged<String> onChanged,
}) {
  final isEasyCompact = question.id.startsWith('EK') && question.id != 'EK1';
  const textSize = QuizTokens.headingTextSize;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        key: ValueKey(question.id),
        initialValue: currentValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Taip jawapan anda di sini',
          hintStyle: TextStyle(fontSize: textSize),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isEasyCompact ? 12 : 16,
            vertical: isEasyCompact ? 10 : 14,
          ),
        ),
        style: TextStyle(fontSize: textSize),
        minLines: isEasyCompact ? 1 : 3,
        maxLines: isEasyCompact ? 2 : 5,
      ),
      if (question.helperLines.isNotEmpty) ...[
        const SizedBox(height: 8),
        ...question.helperLines.map(
          (line) => Text(
            line,
            style: TextStyle(
              fontSize: textSize,
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ],
  );
}

Widget buildQuizMatchingInput({
  required QuizQuestion question,
  required List<String?> selected,
  required List<String> Function(int index) choicesForIndex,
  required void Function(int index, String? value) onChanged,
}) {
  final isEasyCompact = question.id.startsWith('EK') && question.id != 'EK1';
  const textSize = QuizTokens.headingTextSize;

  return Column(
    children: List.generate(question.matchingLeft.length, (index) {
      final leftText = question.matchingLeft[index];
      final choices = choicesForIndex(index);
      return Container(
        margin: EdgeInsets.only(bottom: isEasyCompact ? 8 : 12),
        padding: EdgeInsets.all(isEasyCompact ? 10 : 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QuizTokens.answerPanelBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leftText,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1D3557),
                fontSize: textSize,
              ),
            ),
            SizedBox(height: isEasyCompact ? 6 : 8),
            DropdownButtonFormField<String>(
              initialValue: selected[index],
              hint: Text(question.dropdownPlaceholder),
              style: TextStyle(
                fontSize: textSize,
                color: const Color(0xFF1D3557),
                fontWeight: FontWeight.w600,
              ),
              items: choices
                  .map(
                    (choice) => DropdownMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    ),
                  )
                  .toList(),
              onChanged: (value) => onChanged(index, value),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isEasyCompact ? 10 : 14,
                  vertical: isEasyCompact ? 10 : 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }),
  );
}

Widget buildQuizDragInput({
  required QuizQuestion question,
  required List<String?> selected,
  required List<String> availableChoices,
  required void Function(int index, String value) onSetChoice,
  required void Function(int index) onClearChoice,
}) {
  final isEasyCompact = question.id.startsWith('EK') && question.id != 'EK1';
  const dragTextSize = QuizTokens.headingTextSize;
  final chipPadding = isEasyCompact
      ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
      : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: isEasyCompact ? 6 : 8,
        runSpacing: isEasyCompact ? 6 : 8,
        children: [
          ...availableChoices.map(
            (choice) => Draggable<String>(
              data: choice,
              feedback: Material(
                color: Colors.transparent,
                child: _choiceChip(
                  choice,
                  active: true,
                  fontSize: dragTextSize,
                  padding: chipPadding,
                ),
              ),
              childWhenDragging: _choiceChip(
                choice,
                active: false,
                fontSize: dragTextSize,
                padding: chipPadding,
              ),
              child: _choiceChip(
                choice,
                active: true,
                fontSize: dragTextSize,
                padding: chipPadding,
              ),
            ),
          ),
          if (availableChoices.isEmpty && question.showChoicesExhaustedText)
            const Text(
              'Semua pilihan telah digunakan.',
              style: TextStyle(
                fontSize: QuizTokens.headingTextSize,
                color: Color(0xFF4A5568),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
      SizedBox(height: isEasyCompact ? 8 : 12),
      ...List.generate(question.dragTargets.length, (index) {
        final target = question.dragTargets[index];
        final assigned = selected[index];
        return DragTarget<String>(
          onAcceptWithDetails: (details) => onSetChoice(index, details.data),
          builder: (context, candidateData, rejectedData) {
            return Container(
              margin: EdgeInsets.only(bottom: isEasyCompact ? 8 : 12),
              padding: EdgeInsets.all(isEasyCompact ? 10 : 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: candidateData.isNotEmpty
                      ? const Color(0xFF0EA5E9)
                      : QuizTokens.answerPanelBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D3557),
                      fontSize: dragTextSize,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: isEasyCompact ? 6 : 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isEasyCompact ? 10 : 12,
                            vertical: isEasyCompact ? 10 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: assigned == null
                                ? const Color(0xFFF3F7FB)
                                : const Color(0xFFDFF4FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            assigned ?? question.dropPlaceholder,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: dragTextSize,
                              color: assigned == null
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFF0E7490),
                            ),
                          ),
                        ),
                      ),
                      if (assigned != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => onClearChoice(index),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    ],
  );
}

Widget _choiceChip(
  String text, {
  required bool active,
  double fontSize = QuizTokens.headingTextSize,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  ),
}) {
  return Container(
    padding: padding,
    decoration: BoxDecoration(
      color: active ? const Color(0xFFFFC74D) : const Color(0xFFFFE6A8),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1D3557),
        fontSize: fontSize,
      ),
    ),
  );
}
