// ignore_for_file: lines_longer_than_80_chars

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final login = find.byType(ElevatedButton);

  group('Login Page', () {
    final userName = find.byKey(const Key('username'));
    final password = find.byKey(const Key('password'));

    const userSyncErrorMsg = 'Username must be at least 8 characters';
    const userASyncErrorMsg = 'Incorrect user name';
    const passSyncErrorMsg = 'Password must be at least 8 characters';
    const passASyncErrorMsg = 'Incorrect password';

    const secretUsername = 'username1';
    const secretPassword = 'password1';

    bool? isLoggedIn;
    final sut = MaterialApp(
      theme: ThemeData(),
      home: LoginPage(onSignIn: () => isLoggedIn = true),
    );

    setUp(() {
      isLoggedIn = false;
    });

    testWidgets('should trigger sync validation', (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      await tester.tap(userName);
      await tester.enterText(userName, 'user');
      await tester.tap(password);
      await tester.enterText(password, 'pass');
      await tester.tap(login);
      await tester.pump();

      // verify sync validators ran
      expect(find.text(userSyncErrorMsg), findsOneWidget);
      expect(find.text(passSyncErrorMsg), findsOneWidget);
      expect(find.text(userASyncErrorMsg), findsNothing);
      expect(find.text(passASyncErrorMsg), findsNothing);

      // Verify user is not logged-in.
      expect(isLoggedIn, isFalse);
    });

    testWidgets(
      'should trigger pass sync validator only on good username and no password',
      (WidgetTester tester) async {
        await tester.pumpWidget(sut);

        await tester.tap(userName);
        await tester.enterText(userName, secretUsername);
        await tester.tap(login);
        await tester.pump();

        // verify sync password validator only ran
        expect(find.text(userSyncErrorMsg), findsNothing);
        expect(find.text(passSyncErrorMsg), findsOneWidget);
        expect(find.text(userASyncErrorMsg), findsNothing);
        expect(find.text(passASyncErrorMsg), findsNothing);

        // Verify user is not logged-in.
        expect(isLoggedIn, isFalse);
      },
    );

    testWidgets('should trigger user async validator only on bad username',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      await tester.tap(userName);
      await tester.enterText(userName, 'bogususername');
      await tester.tap(password);
      await tester.enterText(password, 'boguspassword');
      await tester.tap(login);
      // wait for same time as demo async call
      await tester.pump(const Duration(seconds: 1));

      // verify async username validator only ran
      expect(find.text(userSyncErrorMsg), findsNothing);
      expect(find.text(passSyncErrorMsg), findsNothing);
      expect(find.text(userASyncErrorMsg), findsOneWidget);
      expect(find.text(passASyncErrorMsg), findsNothing);

      // Verify user is not logged-in.
      expect(isLoggedIn, isFalse);
    });

    testWidgets(
      'should trigger pass async validator only on good username and bad password',
      (WidgetTester tester) async {
        await tester.pumpWidget(sut);

        await tester.tap(userName);
        await tester.enterText(userName, secretUsername);
        await tester.tap(password);
        await tester.enterText(password, 'boguspassword');
        await tester.tap(login);
        // wait for same time as demo async call
        await tester.pump(const Duration(seconds: 1));

        // verify async password validator only ran
        expect(find.text(userSyncErrorMsg), findsNothing);
        expect(find.text(passSyncErrorMsg), findsNothing);
        expect(find.text(userASyncErrorMsg), findsNothing);
        expect(find.text(passASyncErrorMsg), findsOneWidget);

        // Verify user is not logged-in.
        expect(isLoggedIn, isFalse);
      },
    );

    testWidgets('should not trigger any validators on good login',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      await tester.tap(userName);
      await tester.enterText(userName, secretUsername);

      await tester.tap(password);
      await tester.enterText(password, secretPassword);

      await tester.tap(login);
      // wait for same time as demo async call
      await tester.pump(const Duration(seconds: 1));

      // verify no validators ran
      expect(find.text(userSyncErrorMsg), findsNothing);
      expect(find.text(passSyncErrorMsg), findsNothing);
      expect(find.text(userASyncErrorMsg), findsNothing);
      expect(find.text(passASyncErrorMsg), findsNothing);

      // Verify is logged in
      expect(isLoggedIn, isTrue);
    });
  });

  group('App', () {
    testWidgets('App smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      expect(find.byType(LoginPage), findsOneWidget);

      // tap the submit button and trigger a frame
      await tester.tap(login);
      await tester.pump();
    });
  });
}
