import 'package:flutter/material.dart';
import '../models/history_record.dart';
import '../models/prediction_result.dart';
import '../services/mock_student_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/student_card.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  final MockStudentRepository repository;
  const HistoryScreen({super.key, required this.repository});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const _filters = ['Todos', 'Em risco', 'Sem risco'];
  final _search = TextEditingController();
  String _filter = 'Todos';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<HistoryRecord> _apply(List<HistoryRecord> all) {
    final q = _search.text.trim().toLowerCase();
    return all.where((r) {
      if (_filter == 'Em risco' && r.result.risk != RiskLevel.emRisco) return false;
      if (_filter == 'Sem risco' && r.result.risk != RiskLevel.semRisco) return false;
      if (q.isEmpty) return true;
      return r.student.name.toLowerCase().contains(q) ||
          r.student.course.toLowerCase().contains(q) ||
          r.student.summaryLine.toLowerCase().contains(q) ||
          r.id.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Histórico de Registros',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Confira todos os registros salvos e seus resultados.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.5)),
          const SizedBox(height: 16),
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Buscar por nome, curso ou ID...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(_search.clear),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _filter,
            borderRadius: BorderRadius.circular(12),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.filter_list_rounded),
            ),
            items: _filters
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _filter = v ?? 'Todos'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.repository,
              builder: (context, _) => _body(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final repo = widget.repository;
    if (repo.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (repo.error != null) {
      return _state(Icons.error_outline, repo.error!,
          action: CustomButton(
              label: 'Tentar novamente', icon: Icons.refresh, onPressed: repo.load));
    }
    if (repo.records.isEmpty) {
      return _state(Icons.inbox_outlined,
          'Nenhum registro salvo ainda.\nFaça uma previsão e salve no histórico.');
    }
    final list = _apply(repo.records);
    if (list.isEmpty) {
      return _state(Icons.search_off,
          'Nenhum registro encontrado para essa busca ou filtro.');
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: list.length,
            itemBuilder: (_, i) => StudentCard(
              record: list[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailScreen(record: list[i])),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Mostrando ${list.length} de ${repo.records.length} registros',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
          ),
        ),
      ],
    );
  }

  Widget _state(IconData icon, String text, {Widget? action}) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 46, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
              if (action != null) ...[const SizedBox(height: 16), action],
            ],
          ),
        ),
      ),
    );
  }
}
