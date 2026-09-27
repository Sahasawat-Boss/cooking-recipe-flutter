import 'package:easy_cooking/main.dart';
import 'package:easy_cooking/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('switches language from settings', (tester) async {
    SharedPreferences.setMockInitialValues({'language': 'en'});
    final state = await AppState.load();
    await tester.pumpWidget(AppScope(state: state, child: const EasyCookingApp()));
    await tester.pump();

    expect(find.text('Settings'), findsWidgets);

    state.setLanguage('th');
    await tester.pump();
    expect(find.text('ตั้งค่า'), findsWidgets);
  });
}
