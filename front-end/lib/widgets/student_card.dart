import 'package:flutter/material.dart';
import '../models/history_record.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'risk_badge.dart';

class StudentCard extends StatelessWidget {
  final HistoryRecord record;
  final VoidCallback onTap;
  final bool compact; // true na Home (sem linha de curso)

  const StudentCard({
    super.key,
    required this.record,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = record.student;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (!compact) ...[
                        const SizedBox(height: 4),
                        Text(
                          s.summaryLine,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12.5),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        formatDate(record.date),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
                RiskBadge(risk: record.result.risk),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
