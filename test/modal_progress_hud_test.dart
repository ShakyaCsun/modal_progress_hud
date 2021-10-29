import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() {
  group('Modal Progress HUD', () {
    Widget sut({bool inAsyncCall = false, Offset? offset}) {
      return MaterialApp(
        home: ModalProgressHud(
          inAsyncCall: inAsyncCall,
          offset: offset,
          child: const Text(''),
        ),
      );
    }

    testWidgets(
      'should show progress indicator when in async call',
      (tester) async {
        await tester.pumpWidget(sut(inAsyncCall: true));

        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'should not show progress indicator when not in async call',
      (tester) async {
        await tester.pumpWidget(sut());

        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets('should allow positioning of progress indicator',
        (tester) async {
      const offset = Offset(0.1, 0.1);
      await tester.pumpWidget(sut(inAsyncCall: true, offset: offset));

      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
