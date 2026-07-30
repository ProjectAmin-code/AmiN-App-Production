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
  bool revealCorrectness = false,
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
            final isCorrect = question.correctOptionIds.contains(option.id);
            final isSelectedCorrect = revealCorrectness && selected && isCorrect;
            final isSelectedWrong = revealCorrectness && selected && !isCorrect;
            final isMissedCorrect = revealCorrectness && !selected && isCorrect;
            return SizedBox(
              width: itemWidth,
              child: FilterChip(
                label: Center(child: Text(option.label)),
                selected: selected,
                showCheckmark: isSelectedCorrect,
                checkmarkColor: isSelectedCorrect
                    ? const Color(0xFF15803D)
                    : Colors.white,
                avatar: isSelectedWrong
                    ? const Icon(
                        Icons.close_rounded,
                        color: Color(0xFFDC2626),
                      )
                    : isMissedCorrect
                    ? const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF15803D),
                      )
                    : null,
                backgroundColor: _firstQuestionOptionPurple,
                selectedColor: isSelectedWrong
                    ? const Color(0xFFFFE4E6)
                    : isSelectedCorrect
                    ? const Color(0xFFDCFCE7)
                    : _firstQuestionOptionPurple,
                side: BorderSide(
                  color: isSelectedWrong
                      ? const Color(0xFFDC2626)
                      : (isSelectedCorrect || isMissedCorrect)
                      ? const Color(0xFF16A34A)
                      : selected
                      ? const Color(0xFF6D4DE7)
                      : const Color(0xFF7F5AF0),
                  width: revealCorrectness && (selected || isMissedCorrect)
                      ? 2.4
                      : selected
                      ? 2
                      : 1.4,
                ),
                onSelected: revealCorrectness
                    ? (_) {}
                    : (_) => onToggle(option),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: QuizTokens.headingTextSize,
                  color: revealCorrectness && (selected || isMissedCorrect)
                      ? const Color(0xFF1F2937)
                      : Colors.white,
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
      final isCorrect = question.correctOptionIds.contains(option.id);
      final isSelectedCorrect = revealCorrectness && selected && isCorrect;
      final isSelectedWrong = revealCorrectness && selected && !isCorrect;
      final isMissedCorrect = revealCorrectness && !selected && isCorrect;
      return FilterChip(
        label: Text(option.label),
        selected: selected,
        showCheckmark: isSelectedCorrect,
        checkmarkColor: const Color(0xFF15803D),
        avatar: isSelectedWrong
            ? const Icon(Icons.close_rounded, color: Color(0xFFDC2626))
            : isMissedCorrect
            ? const Icon(Icons.check_rounded, color: Color(0xFF15803D))
            : null,
        selectedColor: isSelectedWrong
            ? const Color(0xFFFFE4E6)
            : isSelectedCorrect
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFB8ECFF),
        side: BorderSide(
          color: isSelectedWrong
              ? const Color(0xFFDC2626)
              : (isSelectedCorrect || isMissedCorrect)
              ? const Color(0xFF16A34A)
              : QuizTokens.idleOptionBorder,
          width: revealCorrectness && (selected || isMissedCorrect) ? 2.4 : 1,
        ),
        onSelected: revealCorrectness ? (_) {} : (_) => onToggle(option),
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

  if (question.id == 'HK10') {
    final values = currentValue.split(',').take(3).toList();
    while (values.length < 3) {
      values.add('');
    }

    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _questionNumber(index, fontSize: textSize),
              Expanded(
                child: TextFormField(
                  key: ValueKey('${question.id}-answer-$index'),
                  initialValue: values[index].trim(),
                  onChanged: (value) {
                    values[index] = value;
                    onChanged(values.join(','));
                  },
                  decoration: InputDecoration(
                    labelText: 'Jawapan',
                    hintText: 'Taip jawapan',
                    hintStyle: const TextStyle(fontSize: textSize),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: const TextStyle(fontSize: textSize),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

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

  if (question.id == 'HK2' ||
      question.id == 'HK7' ||
      question.id == 'HK8') {
    return Column(
      children: List.generate(question.matchingLeft.length, (index) {
        final selectedValue = selected[index];
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: QuizTokens.answerPanelBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _questionNumber(index, fontSize: textSize),
                  Expanded(
                    child: Text(
                      _withoutLeadingNumber(question.matchingLeft[index]),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D3557),
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...choicesForIndex(index).map((choice) {
                final isSelected = selectedValue == choice;
                return InkWell(
                  onTap: () => onChanged(index, choice),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? QuizTokens.selectedOptionFill
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? QuizTokens.selectedOptionBorder
                            : QuizTokens.idleOptionBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          size: 24,
                          color: isSelected
                              ? QuizTokens.selectedOptionBorder
                              : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            choice,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: textSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  final itemSpacing = question.id == 'EK3'
      ? (isEasyCompact ? 14.0 : 18.0)
      : (isEasyCompact ? 8.0 : 12.0);

  return Column(
    children: List.generate(question.matchingLeft.length, (index) {
      final leftText = question.matchingLeft[index];
      final choices = choicesForIndex(index);
      return Container(
        margin: EdgeInsets.only(bottom: itemSpacing),
        padding: EdgeInsets.all(isEasyCompact ? 10 : 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QuizTokens.answerPanelBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _questionNumber(index, fontSize: textSize),
                Expanded(
                  child: Text(
                    _withoutLeadingNumber(leftText),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D3557),
                      fontSize: textSize,
                    ),
                  ),
                ),
              ],
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
            if (question.id == 'EK8') {
              final inputWidth = (MediaQuery.sizeOf(context).width * 0.30)
                  .clamp(104.0, 132.0);
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: candidateData.isNotEmpty
                        ? const Color(0xFF0EA5E9)
                        : QuizTokens.answerPanelBorder,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${index + 1}.',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D3557),
                          fontSize: dragTextSize,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: inputWidth,
                      child: GestureDetector(
                        onTap: assigned == null
                            ? null
                            : () => onClearChoice(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: assigned == null
                                ? const Color(0xFFF3F7FB)
                                : const Color(0xFFDFF4FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  assigned ?? question.dropPlaceholder,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: dragTextSize,
                                    color: assigned == null
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF0E7490),
                                  ),
                                ),
                              ),
                              if (assigned != null) ...[
                                const SizedBox(width: 2),
                                const Icon(Icons.close_rounded, size: 18),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        target,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D3557),
                          fontSize: dragTextSize,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (question.id == 'EK10' ||
                question.id == 'MK3' ||
                question.id == 'MK10') {
              final blankMatch = RegExp(r'_+').firstMatch(target);
              final textBeforeBlank = blankMatch == null
                  ? target
                  : target.substring(0, blankMatch.start);
              final textAfterBlank = blankMatch == null
                  ? ''
                  : target.substring(blankMatch.end);

              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: isEasyCompact ? 20 : 24),
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
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D3557),
                      fontSize: dragTextSize,
                      height: 1.25,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${index + 1}. '
                            '${_withoutLeadingNumber(textBeforeBlank)}',
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: assigned == null
                              ? null
                              : () => onClearChoice(index),
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 54),
                            padding: EdgeInsets.symmetric(
                              horizontal: isEasyCompact ? 10 : 12,
                              vertical: isEasyCompact ? 8 : 10,
                            ),
                            decoration: BoxDecoration(
                              color: assigned == null
                                  ? const Color(0xFFF3F7FB)
                                  : const Color(0xFFDFF4FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              assigned ?? question.dropPlaceholder,
                              textAlign: TextAlign.center,
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
                      ),
                      TextSpan(text: textAfterBlank),
                    ],
                  ),
                ),
              );
            }

            return Container(
              margin: EdgeInsets.only(bottom: isEasyCompact ? 14 : 16),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _questionNumber(index, fontSize: dragTextSize),
                  Expanded(
                    flex: question.id == 'EK10' ? 1 : 2,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: isEasyCompact ? 10 : 12,
                        right: assigned == null ? (isEasyCompact ? 10 : 12) : 4,
                        top: isEasyCompact ? 10 : 12,
                        bottom: isEasyCompact ? 10 : 12,
                      ),
                      decoration: BoxDecoration(
                        color: assigned == null
                            ? const Color(0xFFF3F7FB)
                            : const Color(0xFFDFF4FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
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
                          if (assigned != null)
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(4),
                              onPressed: () => onClearChoice(index),
                              icon: const Icon(Icons.close_rounded, size: 20),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: isEasyCompact ? 12 : 16),
                  Expanded(
                    flex: question.id == 'EK10' ? 2 : 1,
                    child: Text(
                      _withoutLeadingNumber(target),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D3557),
                        fontSize: dragTextSize,
                        height: 1.25,
                      ),
                    ),
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

Widget _questionNumber(int index, {required double fontSize}) {
  return SizedBox(
    width: 28,
    child: Text(
      '${index + 1}.',
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1D3557),
        fontSize: fontSize,
        height: 1.25,
      ),
    ),
  );
}

String _withoutLeadingNumber(String text) {
  return text.replaceFirst(RegExp(r'^\s*\d+\.\s*'), '');
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
