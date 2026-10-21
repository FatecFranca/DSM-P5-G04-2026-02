import 'package:flutter/foundation.dart';
import '../models/history_record.dart';
import '../models/prediction_result.dart';
import '../models/student.dart';

/// Repositório em memória do histórico (sem banco de dados).
/// Futuramente: trocar por um repositório que consome GET /records.
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
    HistoryRecord make(String name, String course, String sem, String shift,
        DateTime date, bool risk, double prob,
        {double grade = 7.0, double att = 85, bool failed = false}) {
      return HistoryRecord(
        id: _nextId(),
        date: date,
        result: PredictionResult(
          risk: risk ? RiskLevel.emRisco : RiskLevel.semRisco,
          probability: prob,
        ),
        student: Student(
          name: name,
          course: course,
          semester: sem,
          shift: shift,
          age: 18 + name.length % 10,
          gender: 'Feminino',
          works: risk,
          familyIncome: 'Até 3 salários mínimos',
          hasScholarship: !risk,
          averageGrade: grade,
          attendance: att,
          failedBefore: failed,
        ),
      );
    }

    const ads = 'Análise e Desenvolvimento de Sistemas';
    const eng = 'Engenharia de Software';
    final r = <HistoryRecord>[
      make('Ana Souza', ads, '3º semestre', 'Noturno', DateTime(2025, 9, 28),
          true, 0.78, grade: 5.8, att: 68, failed: true),
      make('Carlos Almeida', ads, '2º semestre', 'Noturno',
          DateTime(2025, 9, 27), false, 0.18, grade: 8.1, att: 94),
      make('Juliana Costa', eng, '4º semestre', 'Matutino',
          DateTime(2025, 9, 26), false, 0.22, grade: 7.9, att: 91),
      make('Rafael Lima', eng, '3º semestre', 'Noturno', DateTime(2025, 9, 25),
          true, 0.71, grade: 6.0, att: 70, failed: true),
      make('Beatriz Santos', ads, '2º semestre', 'Noturno',
          DateTime(2025, 9, 24), false, 0.12, grade: 8.8, att: 97),
      make('Felipe Oliveira', eng, '3º semestre', 'Matutino',
          DateTime(2025, 9, 23), true, 0.83, grade: 5.2, att: 62, failed: true),
    ];
    // Ids em ordem decrescente de data (o mais recente tem o maior número).
    return r;
  }
}
