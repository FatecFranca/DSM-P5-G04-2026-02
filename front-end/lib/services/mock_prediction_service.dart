
import '../models/form_options.dart';
import '../models/prediction_result.dart';
import '../models/student.dart';
import 'prediction_service.dart';

/// Serviço fictício para testar a interface.
/// Não utiliza o modelo real de Machine Learning.
class MockPredictionService implements PredictionService {
  @override
  Future<PredictionResult> predict(Student student) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    var dropout = 0.45;

    dropout += (7.0 - student.averageGrade) * 0.12;
    dropout += (75 - student.attendance) * 0.008;

    if (student.failedBefore) dropout += 0.15;
    if (student.works) dropout += 0.05;
    if (student.hasScholarship) dropout -= 0.08;

    if (FormOptions.incomes.indexOf(student.familyIncome) <= 1) {
      dropout += 0.04;
    }

    dropout = dropout.clamp(0.03, 0.97);

    final remaining = 1.0 - dropout;

    final enrolled = remaining * 0.45;
    final graduate = remaining * 0.55;

    final probabilities = {
      'Dropout': dropout,
      'Enrolled': enrolled,
      'Graduate': graduate,
    };

    final prediction = probabilities.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    ).key;

    return PredictionResult.fromJson({
      'previsao': prediction,
      'probabilidades': probabilities,
    });
  }
}
