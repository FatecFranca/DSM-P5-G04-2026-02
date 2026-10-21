String formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

String formatGrade(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

String formatPercent(double v) =>
    '${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1).replaceAll('.', ',')}%';

String yesNo(bool v) => v ? 'Sim' : 'Não';
