import 'package:flutter_test/flutter_test.dart';
import 'package:pelis420_hd/main.dart';

void main() {
  testWidgets('Pelis420 HD home screen renders', (tester) async {
    await tester.pumpWidget(const Pelis420HDApp());
    expect(find.text('Pelis420 HD'), findsWidgets);
    expect(find.text('Seguir viendo'), findsOneWidget);
  });
}
