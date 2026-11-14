
import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';

/// Card de destaque com a classificação prevista pelo modelo.
class RiskHeroCard extends StatelessWidget {
  final PredictionResult result;

  const RiskHeroCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final prediction = result.prediction;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: prediction.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: prediction.color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: prediction.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  prediction.icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  prediction.headline,
                  style: TextStyle(
                    color: prediction.color,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Classificação prevista para este estudante:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            prediction.label,
            style: TextStyle(
              color: prediction.color,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Probabilidades por classificação:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _ProbabilityRow(
            label: 'Abandono (Dropout)',
            probability: result.dropoutProbability,
            color: AppColors.danger,
          ),
          const SizedBox(height: 12),
          _ProbabilityRow(
            label: 'Matriculado (Enrolled)',
            probability: result.enrolledProbability,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _ProbabilityRow(
            label: 'Graduado (Graduate)',
            probability: result.graduateProbability,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _ProbabilityRow extends StatelessWidget {
  final String label;
  final double probability;
  final Color color;

  const _ProbabilityRow({
    required this.label,
    required this.probability,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (probability * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: probability.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

/// Lista "rótulo : valor" dentro de um card.
class DetailsCard extends StatelessWidget {
  final String title;
  final Map<String, String> rows;

  const DetailsCard({
    super.key,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final entries = rows.entries.toList();

    return SectionCard(
      title: title,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      entries[i].key,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      entries[i].value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i != entries.length - 1)
              const Divider(height: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}
