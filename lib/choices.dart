import 'package:awesome_select/awesome_select.dart' show S2Choice;

final List<S2Choice<int>> languageList = [
  S2Choice(value: 0, title: 'English'),
  S2Choice(value: 1, title: 'Hindi')
];
final List<S2Choice<int>> userBoardList = [
  S2Choice(value: 0, title: 'CBSE'),
  S2Choice(value: 1, title: 'SWDHAYAY'),
  S2Choice(value: 2, title: 'ICSE'),
  S2Choice(value: 3, title: 'MSBSHSE'),
];
final List<List<S2Choice<int>>> userClassList = [
  [
    S2Choice(value: 0, title: 'Class 1'),
    S2Choice(value: 1, title: 'Class 2'),
    S2Choice(value: 2, title: 'Class 3'),
    S2Choice(value: 3, title: 'Class 4'),
    S2Choice(value: 4, title: 'Class 5'),
    S2Choice(value: 5, title: 'Class 6'),
    S2Choice(value: 6, title: 'Class 7'),
    S2Choice(value: 7, title: 'Class 8'),
    S2Choice(value: 8, title: 'Class 9'),
    S2Choice(value: 9, title: 'Class 10'),
    S2Choice(value: 10, title: 'Class 11'),
  ],
  [
    S2Choice(value: 0, title: 'Class 1'),
  ],
  [
    S2Choice(value: 0, title: 'Class 1'),
    S2Choice(value: 1, title: 'Class 2'),
  ],
  [
    S2Choice(value: 4, title: 'Class 5'),
  ]
];

final List<S2Choice<int>> userProficiencyList = [
  S2Choice(value: 0, title: 'Beginner'),
  S2Choice(value: 1, title: 'Intermediate'),
  S2Choice(value: 2, title: 'Expert'),
];

final List<S2Choice<String>> themeList = [
  S2Choice(value: 'Blue', title: 'Blue'),
  S2Choice(value: 'Black', title: 'Black')
];