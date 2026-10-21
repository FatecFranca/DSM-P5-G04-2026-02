import 'prediction_result.dart';
import 'student.dart';

/// Registro salvo no histórico (estudante + resultado + data).
class HistoryRecord {
  final String id;
  final Student student;
  final PredictionResult result;
  final DateTime date;

  const HistoryRecord({
    required this.id,
    required this.student,
    required this.result,
    required this.date,
  });
}
