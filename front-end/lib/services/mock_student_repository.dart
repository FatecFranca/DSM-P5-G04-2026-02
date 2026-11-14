
import 'package:flutter/foundation.dart';
import '../models/history_record.dart';
import '../models/prediction_result.dart';
import '../models/student.dart';
import '../models/form_options.dart';

/// Repositório em memória do histórico (sem banco de dados).
/// Futuramente: trocar por um repositório conectado à API.
class MockStudentRepository extends ChangeNotifier {
  final List<HistoryRecord> _records = [];
  bool _loading = true;
  String? _error;
  int _counter = 0;

  List<HistoryRecord> get records => List.unmodifiable(_records);
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 700));
      if (_records.isEmpty) _records.addAll(_seed());
    } catch (_) {
      _error = 'Não foi possível carregar os registros.';
    }

    _loading = false;
    notifyListeners();
  }

  HistoryRecord add(Student student, PredictionResult result) {
    final record = HistoryRecord(
      id: _nextId(),
      student: student,
      result: result,
      date: DateTime.now(),
    );

    _records.insert(0, record);
    notifyListeners();
    return record;
  }

  String _nextId() {
    _counter++;
    return 'REG-${_counter.toString().padLeft(4, '0')}';
  }

  List<HistoryRecord> _seed() {
    HistoryRecord make(
      String name,
      String course,
      String sem,
      String shift,
      DateTime date,
      PredictionClass prediction,
      Map<String, double> probabilities, {
      double gradeFirst = 7.0,
      double attFirst = 85,
      double gradeSecond = 7.0,
      double attSecond = 85,
      bool failed = false,
    }) {
      return HistoryRecord(
        id: _nextId(),
        date: date,
        result: PredictionResult(
          prediction: prediction,
          probabilities: probabilities,
        ),
        student: Student(
          name: name,
          course: course,
          courseCode: FormOptions.courseCodes[course]!,
          semester: sem,
          shift: shift,
          age: 18 + name.length % 10,
          gender: 'Feminino',
          works: prediction == PredictionClass.dropout,
          familyIncome: 'Até 3 salários mínimos',
          hasScholarship: prediction == PredictionClass.graduate,
          averageGradeFirst: gradeFirst,
          attendanceFirst: attFirst,
          averageGradeSecond: gradeSecond,
          attendanceSecond: attSecond,
          failedBefore: failed,
        ),
      );
    }

    const rh = 'Gestão de Recursos Humanos';
    const ads = 'Análise e Desenvolvimento de Sistemas';
    const dsm = 'Desenvolvimento de Software Multiplataforma';
    const ge = 'Gestão Empresarial';

    return [
      make(
        'Ana Souza',
        ads,
        '3º semestre',
        'Noturno',
        DateTime(2025, 9, 28),
        PredictionClass.dropout,
        {'Dropout': 0.78, 'Enrolled': 0.15, 'Graduate': 0.07},
        gradeFirst: 6.0,
        attFirst: 72,
        gradeSecond: 5.8,
        attSecond: 68,
        failed: true,
      ),
      make(
        'Carlos Almeida',
        dsm,
        '2º semestre',
        'Noturno',
        DateTime(2025, 9, 27),
        PredictionClass.graduate,
        {'Dropout': 0.18, 'Enrolled': 0.12, 'Graduate': 0.70},
        gradeFirst: 7.8,
        attFirst: 90,
        gradeSecond: 8.1,
        attSecond: 94,
      ),
      make(
        'Juliana Costa',
        ge,
        '4º semestre',
        'Matutino',
        DateTime(2025, 9, 26),
        PredictionClass.enrolled,
        {'Dropout': 0.22, 'Enrolled': 0.65, 'Graduate': 0.13},
        gradeFirst: 7.5,
        attFirst: 88,
        gradeSecond: 7.9,
        attSecond: 91,
      ),
      make(
        'Rafael Lima',
        rh,
        '3º semestre',
        'Noturno',
        DateTime(2025, 9, 25),
        PredictionClass.dropout,
        {'Dropout': 0.71, 'Enrolled': 0.18, 'Graduate': 0.11},
        gradeFirst: 6.5,
        attFirst: 75,
        gradeSecond: 6.0,
        attSecond: 70,
        failed: true,
      ),
      make(
        'Beatriz Santos',
        ads,
        '2º semestre',
        'Noturno',
        DateTime(2025, 9, 24),
        PredictionClass.graduate,
        {'Dropout': 0.12, 'Enrolled': 0.08, 'Graduate': 0.80},
        gradeFirst: 8.5,
        attFirst: 95,
        gradeSecond: 8.8,
        attSecond: 97,
      ),
      make(
        'Felipe Oliveira',
        dsm,
        '3º semestre',
        'Matutino',
        DateTime(2025, 9, 23),
        PredictionClass.dropout,
        {'Dropout': 0.83, 'Enrolled': 0.10, 'Graduate': 0.07},
        gradeFirst: 5.8,
        attFirst: 68,
        gradeSecond: 5.2,
        attSecond: 62,
        failed: true,
      ),
    ];
  }
}
