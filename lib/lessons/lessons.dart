import 'package:flutter/material.dart';
import 'package:shabdamitra/lessons/get_lessons.dart';

import '../application_context.dart';

class Lessons extends StatefulWidget {
  const Lessons({Key? key}) : super(key: key);

  @override
  _LessonsState createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ApplicationContext().getStudentBoard() +
            ' ' +
            ApplicationContext().getStudentStandardString()),
        centerTitle: true,
      ),
      body: const GetLessons(),
    );
  }
}
//uncomment below code when adding tests pages

// class _LessonsState extends State<Lessons> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 1,
//       child: Scaffold(
//         appBar: AppBar(
//           flexibleSpace: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: const [
//               TabBar(
//                 tabs: [
//                   Tab(
//                     text: 'Lessons',
//                   ),
//                   // Tab(
//                   //   text: 'Tests',
//                   // ),
//                   // Tab(
//                   //   text: 'Progress',
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             GetLessons(),
//             // Tests(),
//             // Progress(),
//           ],
//         ),
//       ),
//     );
//   }
// }
