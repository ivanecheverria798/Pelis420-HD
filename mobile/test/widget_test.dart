import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pelis420_hd/main.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('Pelis420 HD demo renders', (tester) async {
    await tester.pumpWidget(const Pelis420HDApp());
    await tester.pumpAndSettle();
    expect(find.text('Pelis420 HD'), findsWidgets);
    expect(find.text('Recomendados'), findsOneWidget);
  });
}
