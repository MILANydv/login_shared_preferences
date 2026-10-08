import 'package:flutter_test/flutter_test.dart';

import 'package:login_app/main.dart';
import 'package:login_app/screens/login_screen.dart';
import 'package:login_app/screens/register_screen.dart';

void main() {
  testWidgets('shows login screen when logged out', (tester) async {
    await tester.pumpWidget(const LoginApp(isLoggedIn: false));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('navigates to register screen', (tester) async {
    await tester.pumpWidget(const LoginApp(isLoggedIn: false));

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
