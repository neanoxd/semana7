import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('Divisor de Cuenta loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DivisorCuentaApp());
    await tester.pumpAndSettle();

    // Verify that the title is present
    expect(find.text('Divisor de Cuenta'), findsOneWidget);

    // Verify that the navigation destinations are present
    expect(find.text('División Rápida'), findsOneWidget);
    expect(find.text('Por Ítems / Amigos'), findsOneWidget);

    // Verify initial QuickSplitView content
    expect(find.text('Total por persona'), findsOneWidget);
    expect(find.text('Monto de la Cuenta'), findsOneWidget);

    // Tap on 'Por Ítems / Amigos' destination
    await tester.tap(find.text('Por Ítems / Amigos'));
    await tester.pumpAndSettle();

    // Verify ItemizedSplitView content
    expect(find.text('Total de la Mesa'), findsOneWidget);
    expect(find.textContaining('Amigos en la mesa'), findsOneWidget);
  });
}
