import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../models/student.dart';
import '../services/mock_student_repository.dart';
import '../utils/format.dart';
import '../widgets/custom_button.dart';
import '../widgets/result_widgets.dart';

/// Resultado da previsão. Faz pop(true) quando o registro é salvo no histórico.
class ResultScreen extends StatefulWidget {
  final Student student;
  final PredictionResult result;
  final MockStudentRepository repository;

  const ResultScreen({
    super.key,
    required this.student,
    required this.result,
    required this.repository,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  void _save() {
    if (_saved) return;
    setState(() => _saved = true);
    widget.repository.add(widget.student, widget.result);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro salvo no histórico.')),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado da Predição')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(s.name,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            RiskHeroCard(result: widget.result),
            const SizedBox(height: 16),
            DetailsCard(
              title: 'Detalhes da análise',
              rows: {
                'Curso': s.course,
                'Período atual': s.semester,
                'Turno': s.shift,
                'Média das notas': formatGrade(s.averageGrade),
                'Frequência': formatPercent(s.attendance),
                'Renda familiar': s.familyIncome,
                'Já reprovou': yesNo(s.failedBefore),
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Salvar no histórico',
              icon: Icons.save_outlined,
              onPressed: _saved ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
