import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';

/// Card de destaque com o nível de risco; muda de cor conforme o resultado.
class RiskHeroCard extends StatelessWidget {
  final PredictionResult result;
  const RiskHeroCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final risk = result.risk;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: risk.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: risk.color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                    BoxDecoration(color: risk.color, shape: BoxShape.circle),
                child: Icon(risk.icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  risk.headline,
                  style: TextStyle(
                    color: risk.color,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'A probabilidade de evasão para este estudante é de:',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '${result.percent}%',
            style: TextStyle(
              color: risk.color,
              fontSize: 54,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: result.probability,
              minHeight: 8,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(risk.color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista "rótulo : valor" dentro de um card.
class DetailsCard extends StatelessWidget {
  final String title;
  final Map<String, String> rows;
  const DetailsCard({super.key, required this.title, required this.rows});

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
                    child: Text(entries[i].key,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14)),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(entries[i].value,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
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
