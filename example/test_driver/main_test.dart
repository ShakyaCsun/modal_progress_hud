import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('app test: ', () {
    const userSync = 'Username must be at least 8 characters';
    const userASync = 'Incorrect user name';
    const passSync = 'Password must be at least 8 characters';
    const passASync = 'Incorrect password';

    late FlutterDriver driver;
    final userName = find.byValueKey('username');
    final password = find.byValueKey('password');
    final login = find.byType('RaisedButton');
    final notLoggedIn = find.byValueKey('notLoggedIn');

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('trigger sync validation', () async {
      await driver.tap(userName);
      await driver.enterText('user');
      await driver.waitFor(find.text('user'));

      await driver.tap(password);
      await driver.enterText('pass');
      await driver.waitFor(find.text('pass'));

      await driver.tap(login);

      // verify sync validators ran
      await driver.waitFor(find.text(userSync));
      await driver.waitFor(find.text(passSync));
      await driver.waitForAbsent(find.text(userASync));
      await driver.waitForAbsent(find.text(passASync));

      // verify not logged in
      final loginStatus = await driver.getText(notLoggedIn);
      expect(loginStatus, equals('Not logged in'));
    });

    test('trigger async validation', () async {
      await driver.tap(userName);
      await driver.enterText('username');
      await driver.waitFor(find.text('username'));

      await driver.tap(password);
      await driver.enterText('password');
      await driver.waitFor(find.text('password'));

      await driver.tap(login);

      // verify user async validator ran
      await driver.waitForAbsent(find.text(userSync));
      await driver.waitForAbsent(find.text(passSync));
      await driver.waitFor(find.text(userASync));
      await driver.waitForAbsent(find.text(passASync));

      // verify not logged in
      final loginStatus = await driver.getText(notLoggedIn);
      expect(loginStatus, equals('Not logged in'));
      final loggedIn = find.byValueKey('loggedIn');
      await driver.waitForAbsent(loggedIn);
    });

    test('try to login', () async {
      final loginStatus = await driver.getText(notLoggedIn);
      expect(loginStatus, equals('Not logged in'));

      await driver.tap(userName);
      await driver.enterText('username1');
      await driver.waitFor(find.text('username1'));

      await driver.tap(password);
      await driver.enterText('password1');
      await driver.waitFor(find.text('password1'));

      await driver.tap(login);

      // verify no validator ran
      await driver.waitForAbsent(find.text(userSync));
      await driver.waitForAbsent(find.text(passSync));
      await driver.waitForAbsent(find.text(userASync));
      await driver.waitForAbsent(find.text(passASync));

      await driver.waitFor(find.byValueKey('loggedIn'));
      final loggedIn = find.byValueKey('loggedIn');
      expect(loggedIn, isNotNull);
    });
  });
}
