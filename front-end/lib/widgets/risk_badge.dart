import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../theme/app_theme.dart';

class RiskBadge extends StatelessWidget {
  final RiskLevel risk;
  const RiskBadge({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: risk.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: risk.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            risk.label,
            style: TextStyle(
              color: risk.color,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
