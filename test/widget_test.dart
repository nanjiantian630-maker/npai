import 'package:flutter_test/flutter_test.dart';
import 'package:niubi_ai/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const NiubiAIApp());
    expect(find.text('牛批AI'), findsWidgets);
  });
}
