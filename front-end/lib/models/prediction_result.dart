enum RiskLevel { emRisco, semRisco }

/// Resultado devolvido pelo modelo.
/// Formato esperado da API: {"prediction": "em_risco", "probability": 0.78}
class PredictionResult {
  final RiskLevel risk;
  final double probability; // 0.0 a 1.0

  const PredictionResult({required this.risk, required this.probability});

  int get percent => (probability * 100).round();

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      risk: json['prediction'] == 'em_risco'
          ? RiskLevel.emRisco
          : RiskLevel.semRisco,
      probability: (json['probability'] as num).toDouble(),
    );
  }
}
