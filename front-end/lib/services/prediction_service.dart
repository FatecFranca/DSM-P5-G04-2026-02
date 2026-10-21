import '../models/prediction_result.dart';
import '../models/student.dart';

/// Contrato do serviço de previsão.
/// Hoje: MockPredictionService. Futuro: PredictionApiService (POST /prediction).
/// A interface (telas) depende só desta classe abstrata.
abstract class PredictionService {
  Future<PredictionResult> predict(Student student);
}
