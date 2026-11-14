
enum PredictionClass {
  dropout,
  enrolled,
  graduate,
}

class PredictionResult {
  final PredictionClass prediction;
  final Map<String, double> probabilities;

  const PredictionResult({
    required this.prediction,
    required this.probabilities,
  });

  double get dropoutProbability => probabilities['Dropout'] ?? 0.0;

  double get enrolledProbability => probabilities['Enrolled'] ?? 0.0;

  double get graduateProbability => probabilities['Graduate'] ?? 0.0;

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final resultado = json['previsao'] as String;

    final PredictionClass classificacao;

    switch (resultado) {
      case 'Dropout':
        classificacao = PredictionClass.dropout;
        break;
      case 'Enrolled':
        classificacao = PredictionClass.enrolled;
        break;
      case 'Graduate':
        classificacao = PredictionClass.graduate;
        break;
      default:
        throw FormatException('Classificação desconhecida: $resultado');
    }

    final probabilidadesJson =
        json['probabilidades'] as Map<String, dynamic>;

    return PredictionResult(
      prediction: classificacao,
      probabilities: probabilidadesJson.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }
}
