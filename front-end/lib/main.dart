import 'package:flutter/material.dart';
import 'screens/form_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'services/mock_prediction_service.dart';
import 'services/mock_student_repository.dart';
import 'services/prediction_service.dart';
import 'theme/app_theme.dart';

void main() => runApp(const MonitorizaApp());

class MonitorizaApp extends StatelessWidget {
  const MonitorizaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoriza',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainShell(),
    );
  }
}

/// Casca com a BottomNavigationBar (Início / Novo Registro / Histórico).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // Para usar a API no futuro, troque apenas esta linha por PredictionApiService().
  final PredictionService _predictionService = MockPredictionService();
  final MockStudentRepository _repository = MockStudentRepository()..load();

  void _go(int i) => setState(() => _index = i);

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: [
            HomeScreen(
              repository: _repository,
              onNewRecord: () => _go(1),
              onSeeAll: () => _go(2),
            ),
            FormScreen(
              predictionService: _predictionService,
              repository: _repository,
              onSaved: () => _go(2),
            ),
            HistoryScreen(repository: _repository),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: _go,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Novo Registro',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              activeIcon: Icon(Icons.history_toggle_off),
              label: 'Histórico',
            ),
          ],
        ),
      ),
    );
  }
}
