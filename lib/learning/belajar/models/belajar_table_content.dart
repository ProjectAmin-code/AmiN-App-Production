class BelajarTableRow {
  const BelajarTableRow({required this.cells});

  final List<String> cells;
}

class BelajarTableContent {
  const BelajarTableContent({required this.headers, required this.rows});

  final List<String> headers;
  final List<BelajarTableRow> rows;

  bool get isEmpty => headers.isEmpty || rows.isEmpty;
}
