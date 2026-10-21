import '../models/form_options.dart';
import '../models/prediction_result.dart';
import '../models/student.dart';
import 'prediction_service.dart';

/// Simula a API de ML: espera 1,5 s e devolve o mesmo JSON que a API real devolverá.
class MockPredictionService implements PredictionService {
  @override
  Future<PredictionResult> predict(Student student) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    // Heurística apenas para o mock variar conforme os dados informados.
    var p = 0.45;
    p += (7.0 - student.averageGrade) * 0.12;
    p += (75 - student.attendance) * 0.008;
    if (student.failedBefore) p += 0.15;
    if (student.works) p += 0.05;
    if (student.hasScholarship) p -= 0.08;
    if (FormOptions.incomes.indexOf(student.familyIncome) <= 1) p += 0.04;
    p = p.clamp(0.03, 0.97);

    // Mesmo formato do contrato futuro: {"prediction": "...", "probability": 0.78}
    final json = {
      'prediction': p >= 0.5 ? 'em_risco' : 'sem_risco',
      'probability': double.parse(p.toStringAsFixed(2)),
    };
    return PredictionResult.fromJson(json);
  }
}
