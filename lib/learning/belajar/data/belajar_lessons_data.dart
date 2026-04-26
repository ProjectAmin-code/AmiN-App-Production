import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../models/belajar_animation_type.dart';
import '../models/belajar_character_config.dart';
import '../models/belajar_indicator.dart';
import '../models/belajar_info_box.dart';
import '../models/belajar_lesson_content.dart';
import '../models/belajar_table_content.dart';
import '../models/lesson_theme_variant.dart';

class BelajarLessonsData {
  const BelajarLessonsData._();

  static const String initialLessonId = 'kenali-men';

  static final List<BelajarLessonContent> lessons = [
    BelajarLessonContent(
      id: 'kenali-men',
      title: 'Kenali imbuhan meN-',
      descriptionBlocks: [
        'Imbuhan meN- digunakan untuk membentuk kata kerja.',
        'Bentuk imbuhan berubah mengikut huruf awal kata dasar supaya sebutan lebih lancar.',
      ],
      infoBox: BelajarInfoBoxData(
        title: 'Cara fikir ringkas',
        message:
            'Lihat huruf pertama kata dasar, kemudian pilih bentuk meN- yang betul.',
      ),
      indicators: [
        BelajarIndicator(
          label: 'Huruf awal kata dasar',
          icon: Icons.arrow_downward_rounded,
        ),
        BelajarIndicator(
          label: 'Pilih bentuk imbuhan',
          icon: Icons.chevron_right_rounded,
        ),
        BelajarIndicator(
          label: 'Bina kata kerja',
          icon: Icons.check_circle_rounded,
        ),
      ],
      table: BelajarTableContent(
        headers: ['Bentuk', 'Digunakan Apabila', 'Contoh'],
        rows: [
          BelajarTableRow(cells: ['mem-', 'huruf b, f', 'membaca']),
          BelajarTableRow(cells: ['men-', 'huruf c, d, j, z, sy', 'mencetak']),
          BelajarTableRow(cells: ['meng-', 'huruf vokal, g, h', 'mengangkat']),
        ],
      ),
      noteText:
          'Peraturan ini akan digunakan dalam 2 lesson seterusnya sebelum kuiz.',
      themeVariant: LessonThemeVariant.blue,
      animationType: BelajarAnimationType.slideUp,
      buttonLabel: 'Teruskan',
      nextRoute: AppRoutes.belajarLessonPath('penggunaan-mem'),
      character: BelajarCharacterConfig(
        assetPath: 'assets/Action Figures/AmiN Pointing.svg',
        position: BelajarCharacterPosition.right,
      ),
    ),
    BelajarLessonContent(
      id: 'penggunaan-mem',
      title: 'Penggunaan imbuhan mem-',
      descriptionBlocks: [
        'Gunakan imbuhan mem- apabila kata dasar bermula dengan huruf b atau f.',
        'Huruf awal kata dasar tidak berubah.',
      ],
      infoBox: BelajarInfoBoxData(
        title: 'Petunjuk',
        message:
            'Ingat pola ini dahulu: b/f -> mem-. Ini ialah pola asas yang selalu muncul dalam latihan.',
        icon: Icons.auto_awesome_rounded,
      ),
      indicators: [
        BelajarIndicator(label: 'b', icon: Icons.arrow_forward_rounded),
        BelajarIndicator(label: 'f', icon: Icons.arrow_forward_rounded),
      ],
      table: BelajarTableContent(
        headers: ['Huruf Awal', 'Kata Dasar', 'Imbuhan', 'Kata Berimbuhan'],
        rows: [
          BelajarTableRow(cells: ['b', 'baca', 'mem-', 'membaca']),
          BelajarTableRow(cells: ['b', 'bantu', 'mem-', 'membantu']),
          BelajarTableRow(cells: ['f', 'fitnah', 'mem-', 'memfitnah']),
          BelajarTableRow(cells: ['f', 'fokus', 'mem-', 'memfokus']),
        ],
      ),
      noteText:
          'Nota: untuk huruf p, bentuknya boleh berubah kepada mem- '
          'dengan pengguguran huruf p dalam pola tertentu.',
      themeVariant: LessonThemeVariant.orange,
      animationType: BelajarAnimationType.fadeIn,
      buttonLabel: 'Seterusnya',
      nextRoute: AppRoutes.belajarLessonPath('penggunaan-men'),
      character: BelajarCharacterConfig(
        assetPath: 'assets/Action Figures/AmiN pointing right.svg',
        position: BelajarCharacterPosition.center,
      ),
    ),
    BelajarLessonContent(
      id: 'penggunaan-men',
      title: 'Penggunaan imbuhan men-',
      descriptionBlocks: [
        'Gunakan imbuhan men- apabila kata dasar bermula dengan c, d, j, z, atau sy.',
        'Kebanyakan huruf awal kekal, jadi tumpu pada padanan huruf -> imbuhan.',
      ],
      infoBox: BelajarInfoBoxData(
        title: 'Ringkas sebelum kuiz',
        message:
            'Jika huruf awal ialah c, d, j, z, atau sy, biasanya pilih men- tanpa ubah huruf.',
      ),
      indicators: [
        BelajarIndicator(label: 'c, d, j, z, sy', icon: Icons.rule_rounded),
        BelajarIndicator(
          label: 'men- + kata dasar',
          icon: Icons.arrow_forward_rounded,
        ),
      ],
      table: BelajarTableContent(
        headers: ['Huruf Awal', 'Kata Dasar', 'Imbuhan', 'Kata Berimbuhan'],
        rows: [
          BelajarTableRow(cells: ['c', 'cetak', 'men-', 'mencetak']),
          BelajarTableRow(cells: ['d', 'dengar', 'men-', 'mendengar']),
          BelajarTableRow(cells: ['j', 'jawab', 'men-', 'menjawab']),
          BelajarTableRow(cells: ['z', 'ziarah', 'men-', 'menziarah']),
          BelajarTableRow(cells: ['sy', 'syor', 'men-', 'mensyor']),
        ],
      ),
      noteText: 'Selesai modul asas. Selepas ini anda boleh terus ke kuiz.',
      themeVariant: LessonThemeVariant.blue,
      animationType: BelajarAnimationType.scaleIn,
      buttonLabel: 'Ke Kuiz',
      nextRoute: AppRoutes.kuiz,
      character: BelajarCharacterConfig(
        assetPath: 'assets/Action Figures/AmiN showing both hands.svg',
        position: BelajarCharacterPosition.left,
      ),
    ),
  ];
}
