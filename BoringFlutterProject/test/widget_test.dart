
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boring_flutter_project/main.dart';

void main() {
  testWidgets("Clicking a tile opens it", (WidgetTester tester) async {
    //Build our app and trigger a frame
    await tester.pumpWidget(MyApp());

    //Tile should be initially close (FalsePositive)
    expect(find.byIcon(Icons.open_in_browser), findsNothing);

    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.open_in_browser), findsOneWidget);
  });
}
