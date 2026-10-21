import 'package:flutter/material.dart';
import '../models/history_record.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/result_widgets.dart';

/// Detalhes completos de um registro do histórico.
class DetailScreen extends StatelessWidget {
  final HistoryRecord record;
  const DetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final s = record.student;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Registro')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(s.name,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('${record.id} • ${formatDate(record.date)}',
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 14),
            RiskHeroCard(result: record.result),
            const SizedBox(height: 16),
            DetailsCard(
              title: 'Informações acadêmicas',
              rows: {
                'Curso': s.course,
                'Período atual': s.semester,
                'Turno': s.shift,
              },
            ),
            const SizedBox(height: 16),
            DetailsCard(
              title: 'Dados pessoais e socioeconômicos',
              rows: {
                'Idade': '${s.age} anos',
                'Gênero': s.gender,
                'Trabalha': yesNo(s.works),
                'Renda familiar': s.familyIncome,
                'Bolsa de estudos': yesNo(s.hasScholarship),
              },
            ),
            const SizedBox(height: 16),
            DetailsCard(
              title: 'Desempenho acadêmico',
              rows: {
                'Média das notas': formatGrade(s.averageGrade),
                'Frequência': formatPercent(s.attendance),
                'Já reprovou': yesNo(s.failedBefore),
              },
            ),
          ],
        ),
      ),
    );
  }
}
