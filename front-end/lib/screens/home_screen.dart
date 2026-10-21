import 'package:flutter/material.dart';
import '../services/mock_student_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/student_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final MockStudentRepository repository;
  final VoidCallback onNewRecord;
  final VoidCallback onSeeAll;

  const HomeScreen({
    super.key,
    required this.repository,
    required this.onNewRecord,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 22),
          const Text(
            'Olá, Ana Júlia!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aqui você pode consultar o risco de evasão de estudantes e '
            'acompanhar os registros analisados pelo sistema.',
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 14.5, height: 1.4),
          ),
          const SizedBox(height: 20),
          _heroCard(),
          const SizedBox(height: 26),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Últimos registros',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
              ),
              TextButton(onPressed: onSeeAll, child: const Text('Ver todos')),
            ],
          ),
          const SizedBox(height: 6),
          _recent(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.school_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'ConectaFatec',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary),
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Perfil',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil disponível em versões futuras.')),
          ),
          icon: const Icon(Icons.person_outline_rounded),
        ),
      ],
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF), shape: BoxShape.circle),
                child: const Icon(Icons.school_rounded,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Mais dados, mais permanência!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 1.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'A análise preditiva ajuda a identificar riscos de evasão e apoia '
            'decisões para manter os estudantes na faculdade.',
            style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onNewRecord,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Novo cadastro'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recent(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        if (repository.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (repository.error != null) {
          return _message(
            icon: Icons.error_outline,
            text: repository.error!,
            action: CustomButton(
              label: 'Tentar novamente',
              icon: Icons.refresh,
              onPressed: repository.load,
            ),
          );
        }
        final recent = repository.records.take(4).toList();
        if (recent.isEmpty) {
          return _message(
            icon: Icons.inbox_outlined,
            text: 'Nenhum registro ainda. Crie o primeiro em "Novo cadastro".',
          );
        }
        return Column(
          children: [
            for (final r in recent)
              StudentCard(
                record: r,
                compact: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(record: r)),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _message({required IconData icon, required String text, Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(icon, size: 42, color: AppColors.textSecondary),
          const SizedBox(height: 10),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary)),
          if (action != null) ...[const SizedBox(height: 14), action],
        ],
      ),
    );
  }
}
