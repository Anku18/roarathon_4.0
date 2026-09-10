import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:roarathon_4/main.dart';
import 'package:roarathon_4/state/app_state.dart';
import 'package:roarathon_4/state/session_store.dart';
import 'package:roarathon_4/widgets/paper_nav.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  configureTestFonts();

  testWidgets('dummy login opens home and tabs', (tester) async {
    final view = tester.view;
    view.physicalSize = const Size(390 * 3, 844 * 3);
    view.devicePixelRatio = 3;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    final state = AppState(store: MemorySessionStore());
    await state.restore();

    await tester.pumpWidget(SharekhanApp(state: state));
    await tester.pump();

    expect(find.text('Investo'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'RM4K92');
    await tester.enterText(find.byType(TextField).at(1), 'demo123');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Where does NIFTY 50 close today?'), findsOneWidget);

    await tester.tap(find.text('Closes up'));
    await tester.pump();
    expect(find.textContaining('Your call is in'), findsOneWidget);

    Finder nav(String label) =>
        find.descendant(of: find.byType(PaperNav), matching: find.text(label));

    await tester.tap(nav('Markets'));
    await tester.pumpAndSettle();
    expect(find.text('Dummy watchlist'), findsOneWidget);

    await tester.tap(nav('Rewards'));
    await tester.pumpAndSettle();
    expect(find.text('Your streak'), findsOneWidget);

    await tester.tap(nav('Refer'));
    await tester.pumpAndSettle();
    expect(find.text('Leaderboard'), findsOneWidget);

    await tester.tap(nav('You'));
    await tester.pumpAndSettle();
    expect(find.text('Rohit Menon'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });
}
