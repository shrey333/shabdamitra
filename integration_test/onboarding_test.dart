import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shabdamitra/application_context.dart';

import 'package:shabdamitra/main.dart' as app;
import 'package:shabdamitra/onboarding/select_user_type.dart';
import 'package:shabdamitra/util/user_property_value_picker.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test Onboarding:', () {
    testWidgets('Show Home if onboarding done', (WidgetTester tester) async {
      // Setting defaults to complete onboarding.
      ApplicationContext().setUserTypeStudentWithDefaultValues();

      app.main();

      await tester.pumpAndSettle();

      // Finds the Home screen.
      // expect(find.byElementType(BottomNavigationBarItem), findsNWidgets(3));

      expect(find.text('Shabdamitra'), findsNothing);
      expect(
        find.text('A digital learning aid for teaching and learning Hindi'),
        findsNothing,
      );
    });

    // testWidgets('Show Introduction and Features if onboarding not done',
    //     (WidgetTester tester) async {
    //   app.main();

    //   await tester.pumpAndSettle();

    //   // Finds the Introduction screen.
    //   expect(find.byIcon(Icons.menu_book), findsNothing);
    //   expect(find.byIcon(Icons.search), findsNothing);
    //   expect(find.byIcon(Icons.settings), findsNothing);

    //   expect(find.image(FileImage(File('assets/images/teaching.png'))),
    //       findsOneWidget);

    //   var nextButton = find.byElementType(FloatingActionButton);
    //   expect(nextButton, findsOneWidget);

    //   await tester.tap(nextButton);

    //   await tester.pumpAndSettle();

    //   // Finds the Features screen.
    //   expect(find.image(FileImage(File('assets/images/learn.png'))),
    //       findsOneWidget);
    //   expect(find.image(FileImage(File('assets/images/image.png'))),
    //       findsOneWidget);
    //   expect(find.image(FileImage(File('assets/images/audio.png'))),
    //       findsOneWidget);
    //   expect(find.image(FileImage(File('assets/images/grammar.png'))),
    //       findsOneWidget);

    //   nextButton = find.byElementType(FloatingActionButton);
    //   expect(nextButton, findsOneWidget);

    //   await tester.tap(nextButton);

    //   await tester.pumpAndSettle();
    // });

    // testWidgets('Show dialogbox if user type not selected',
    //     (WidgetTester tester) async {
    //   tester.pumpWidget(const SelectUserType());

    //   expect(find.image(FileImage(File('assets/images/student.png'))),
    //       findsOneWidget);
    //   expect(find.image(FileImage(File('assets/images/enthusiastic.png'))),
    //       findsOneWidget);

    //   expect(find.byElementType(OutlinedButton), findsNWidgets(2));

    //   var nextButton = find.byElementType(FloatingActionButton);

    //   expect(find.byElementType(FloatingActionButton), findsOneWidget);

    //   await tester.tap(nextButton);

    //   await tester.pumpAndSettle();

    //   expect(find.byElementType(AlertDialog), findsOneWidget);
    // });

    // testWidgets(
    //     'Show board and standard selection page if user type is student',
    //     (WidgetTester tester) async {
    //   tester.pumpWidget(const SelectUserType());

    //   var studentButtonImage =
    //       find.image(FileImage(File('assets/images/student.png')));

    //   expect(studentButtonImage, findsOneWidget);
    //   expect(find.image(FileImage(File('assets/images/enthusiastic.png'))),
    //       findsOneWidget);

    //   expect(find.byElementType(OutlinedButton), findsNWidgets(2));

    //   var nextButton = find.byElementType(FloatingActionButton);

    //   expect(find.byElementType(FloatingActionButton), findsOneWidget);

    //   var studentButton = find.ancestor(
    //     of: studentButtonImage,
    //     matching: find.byElementType(OutlinedButton),
    //   );

    //   expect(studentButton, findsOneWidget);

    //   await tester.tap(studentButton);

    //   await tester.pumpAndSettle();

    //   await tester.tap(nextButton);

    //   await tester.pumpAndSettle();

    //   var studentDetailsPicker = find.byElementType(UserPropertyValuePicker);

    //   expect(studentDetailsPicker, findsOneWidget);

    //   expect(
    //     find.descendant(
    //       of: studentDetailsPicker,
    //       matching: find.byElementType(ListTile),
    //     ),
    //     findsNWidgets(2),
    //   );

    //   var finishButton = find.byElementType(FloatingActionButton);

    //   expect(finishButton, findsOneWidget);

    //   await tester.tap(finishButton);

    //   await tester.pumpAndSettle();

    //   expect(find.byIcon(Icons.menu_book), findsOneWidget);
    //   expect(find.byIcon(Icons.search), findsOneWidget);
    //   expect(find.byIcon(Icons.settings), findsOneWidget);
    // });

    // testWidgets('Show proficiency selection page if user type is learner',
    //     (WidgetTester tester) async {
    //   tester.pumpWidget(const SelectUserType());

    //   var learnerButtonImage =
    //       find.image(FileImage(File('assets/images/enthusiastic.png')));

    //   expect(learnerButtonImage, findsOneWidget);
    //   expect(find.image(FileImage(File('assets/images/enthusiastic.png'))),
    //       findsOneWidget);

    //   expect(find.byElementType(OutlinedButton), findsNWidgets(2));

    //   var nextButton = find.byElementType(FloatingActionButton);

    //   expect(find.byElementType(FloatingActionButton), findsOneWidget);

    //   var learnerButton = find.ancestor(
    //     of: learnerButtonImage,
    //     matching: find.byElementType(OutlinedButton),
    //   );

    //   expect(learnerButton, findsOneWidget);

    //   await tester.tap(learnerButton);

    //   await tester.pumpAndSettle();

    //   await tester.tap(nextButton);

    //   await tester.pumpAndSettle();

    //   var learnerDetailsPicker = find.byElementType(UserPropertyValuePicker);

    //   expect(learnerDetailsPicker, findsOneWidget);

    //   expect(
    //     find.descendant(
    //       of: learnerDetailsPicker,
    //       matching: find.byElementType(ListTile),
    //     ),
    //     findsNWidgets(2),
    //   );

    //   var finishButton = find.byElementType(FloatingActionButton);

    //   expect(finishButton, findsOneWidget);

    //   await tester.tap(finishButton);

    //   await tester.pumpAndSettle();

    //   expect(find.byIcon(Icons.search), findsOneWidget);
    //   expect(find.byIcon(Icons.settings), findsOneWidget);
    // });
  });
}
