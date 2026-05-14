import 'package:financeiro_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows login screen on cold start', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceiroApp());

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
