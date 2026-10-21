import 'package:flutter_test/flutter_test.dart';
import 'package:monitoriza/main.dart';

void main() {
  testWidgets('Abre a Home do Monitoriza', (tester) async {
    await tester.pumpWidget(const MonitorizaApp());
    await tester.pumpAndSettle();
    expect(find.text('Olá, Ana Júlia!'), findsOneWidget);
  });
}
