import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:roarathon_4/main.dart';
import 'package:roarathon_4/state/app_scope.dart';
import 'package:roarathon_4/state/app_state.dart';
import 'package:roarathon_4/state/session_store.dart';
import 'package:roarathon_4/widgets/net_bubble.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  configureTestFonts();

  Future<AppState> pumpBubble(WidgetTester tester) async {
    final state = AppState(store: MemorySessionStore());
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: const MaterialApp(
          home: Scaffold(
            body: Align(alignment: Alignment.topRight, child: NetBubble()),
          ),
        ),
      ),
    );
    return state;
  }

  testWidgets('tap shows the connected popup, which hides itself', (tester) async {
    await pumpBubble(tester);
    expect(find.text('Internet is connected'), findsNothing);

    await tester.tap(find.byType(NetBubble));
    await tester.pumpAndSettle();
    expect(find.text('Internet is connected'), findsOneWidget);

    await tester.pump(NetBubble.popupDuration);
    await tester.pumpAndSettle();
    expect(find.text('Internet is connected'), findsNothing);
  });

  testWidgets('offline popup updates live and closes on an outside tap',
      (tester) async {
    final state = await pumpBubble(tester);
    state.setOnline(false);
    await tester.pump();

    await tester.tap(find.byType(NetBubble));
    // Offline waves repeat forever, so pump a fixed time instead of settling.
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('No internet connection'), findsOneWidget);

    state.setOnline(true);
    await tester.pump();
    expect(find.text('Internet is connected'), findsOneWidget);

    await tester.tapAt(const Offset(20, 400));
    await tester.pumpAndSettle();
    expect(find.text('Internet is connected'), findsNothing);
  });
}
