// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/db/data_manager.dart';

class ApplicationContext {
  static const int defaultStudentBoardIndex = 0;
  static const int defaultStudentStandardIndex = 0;
  static const int defaultLearnerProficiencyIndex = 0;

  static const List<String> StudentBoards = [
    'CBSE',
    'CBSE-SWADHYAY',
    'ICSE',
    'MSBSHSE',
  ];

  static const Map<String, List<int>> StudentBoardsAndStandards = {
    'CBSE': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    'CBSE-SWADHYAY': [1],
    'ICSE': [1, 2],
    'MSBSHSE': [5],
  };

  static List<String> LearnerProficiencies = [
    'Beginner',
    'Intermediate',
    'Expert',
  ];

  late final GetStorage _storage;
  late DataManager dataManager;

  ApplicationContext._internal() {
    _storage = GetStorage();
    _storage.remove('onboardingDone');
    if (isOnboardingDone()) {
      if (isUserStudent()) {
        dataManager =
            DataManager.withHints(getStudentBoard(), getStudentStandard());
      } else {
        dataManager = DataManager();
      }
    }
  }

  static final ApplicationContext _instance = ApplicationContext._internal();

  factory ApplicationContext() {
    return _instance;
  }

  bool isOnboardingDone() {
    return _storage.read('onboardingDone') == true;
  }

  bool isUserStudent() {
    if (isOnboardingDone()) {
      return _storage.read('isUserStudent');
    }
    throw Exception('Invalid Operation: Onboarding not done');
  }

  bool isUserLearner() {
    if (isOnboardingDone()) {
      return !_storage.read('isUserStudent');
    }
    throw Exception('Invalid Operation: Onboarding not done');
  }

  int getStudentBoardIndex() {
    if (isUserStudent()) {
      return _storage.read('studentBoardIndex');
    }
    throw Exception(
        'Invalid Operation: Learners do not have property \'Board\'');
  }

  String getStudentBoard() {
    return StudentBoards[getStudentBoardIndex()];
  }

  int getStudentStandardIndex() {
    if (isUserStudent()) {
      return _storage.read('studentStandardIndex');
    }
    throw Exception(
        'Invalid Operation: Learners do not have property \'Standard\'');
  }

  int getStudentStandard() {
    return StudentBoardsAndStandards[getStudentBoard()]![
        getStudentStandardIndex()];
  }

  String getStudentStandardString() {
    return toStandardString(getStudentStandard());
  }

  int getLearnerProficiencyIndex() {
    if (isUserLearner()) {
      return _storage.read('learnerProficiencyIndex');
    }
    throw Exception(
        'Invalid Operation: Students do not have property \'Proficiency\'');
  }

  String getLearnerProficiency() {
    return LearnerProficiencies[getLearnerProficiencyIndex()];
  }

  void setUserTypeStudent(int boardIndex, int standardIndex) {
    unsetUserTypeLearner();
    _storage.write('onboardingDone', true);
    _storage.write('isUserStudent', true);
    _storage.write('studentBoard', StudentBoards[boardIndex]);
    _storage.write('studentBoardIndex', boardIndex);
    _storage.write('studentStandard',
        StudentBoardsAndStandards[StudentBoards[boardIndex]]![standardIndex]);
    _storage.write('studentStandardIndex', standardIndex);
    dataManager =
        DataManager.withHints(getStudentBoard(), getStudentStandard());
  }

  void setUserTypeStudentWithDefaultValues() {
    setUserTypeStudent(defaultStudentBoardIndex, defaultStudentStandardIndex);
  }

  void setStudentBoardIndex(int studentBoardIndex) {
    _storage.write('studentBoard', StudentBoards[studentBoardIndex]);
    _storage.write('studentBoardIndex', studentBoardIndex);
  }

  void setStudentBoard(String studentBoard) {
    _storage.write('studentBoard', studentBoard);
    _storage.write('studentBoardIndex', StudentBoards.indexOf(studentBoard));
    setStudentStandardIndex(defaultStudentStandardIndex);
  }

  void setStudentStandardIndex(int studentStandardIndex) {
    _storage.write('studentStandard',
        StudentBoardsAndStandards[getStudentBoard()]![studentStandardIndex]);
    _storage.write('studentStandardIndex', studentStandardIndex);
  }

  void setStudentStandard(int studentStandard) {
    _storage.write('studentStandard', studentStandard);
    _storage.write('studentStandardIndex',
        StudentBoardsAndStandards[getStudentBoard()]!.indexOf(studentStandard));
  }

  void unsetUserTypeStudent() {
    try {
      _storage.remove('isUserStudent');
      _storage.remove('studentBoard');
      _storage.remove('studentBoardIndex');
      _storage.remove('studentStandard');
      _storage.remove('studentStandardIndex');
    } catch (_) {}
  }

  static String getDefaultStudentBoard() {
    return StudentBoards[defaultStudentBoardIndex];
  }

  static int getDefaultStudentStandard() {
    return StudentBoardsAndStandards[getDefaultStudentBoard()]![
        defaultStudentStandardIndex];
  }

  static String getDefaultStudentStandardString() {
    return toStandardString(getDefaultStudentStandard());
  }

  static String toStandardString(int studentStandard) {
    return 'Class ${studentStandard.toString()}';
  }

  void setUserTypeLearner(int proficiencyIndex) {
    unsetUserTypeStudent();
    _storage.write('onboardingDone', true);
    _storage.write('isUserStudent', false);
    _storage.write(
        'learnerProficiency', LearnerProficiencies[proficiencyIndex]);
    _storage.write('learnerProficiencyIndex', proficiencyIndex);
    dataManager = DataManager();
  }

  void setUserTypeLearnerWithDefaultValues() {
    setUserTypeLearner(defaultLearnerProficiencyIndex);
  }

  void setLearnerProficiencyIndex(int learnerProficiencyIndex) {
    _storage.write(
        'learnerProficiency', LearnerProficiencies[learnerProficiencyIndex]);
    _storage.write('learnerProficiencyIndex', learnerProficiencyIndex);
  }

  void setLearnerProficiency(String learnerProficiency) {
    _storage.write('learnerProficiency', learnerProficiency);
    _storage.write('learnerProficiencyIndex',
        LearnerProficiencies.indexOf(learnerProficiency));
  }

  void unsetUserTypeLearner() {
    try {
      _storage.remove('isUserStudent');
      _storage.remove('learnerProficiency');
      _storage.remove('learnerProficiencyIndex');
    } catch (_) {}
  }

  static String getDefaultLearnerProficiency() {
    return LearnerProficiencies[defaultLearnerProficiencyIndex];
  }

  bool showSimplifiedData() {
    if (isUserStudent()) {
      return getStudentStandard() <= 5;
    } else {
      return getLearnerProficiencyIndex() == 0;
    }
  }

  bool showGender() {
    if (isUserStudent()) {
      return getStudentStandard() >= 3;
    } else {
      return true;
    }
  }

  bool showIllustration() {
    if (isUserStudent()) {
      return getStudentStandard() <= 5;
    } else {
      return getLearnerProficiencyIndex() == 0;
    }
  }

  bool showTransitivity() {
    return false;
  }

  bool showPluralForm() {
    if (isUserStudent()) {
      return getStudentStandard() >= 3;
    } else {
      return true;
    }
  }

  bool showCountability() {
    if (isUserStudent()) {
      return getStudentStandard() >= 3;
    } else {
      return true;
    }
  }

  bool showSpellingVariation() {
    return false;
  }

  bool showAffix() {
    if (isUserStudent()) {
      return getStudentStandard() > 5;
    } else {
      return getLearnerProficiencyIndex() > 0;
    }
  }

  bool showJunction() {
    if (isUserStudent()) {
      return getStudentStandard() > 5;
    } else {
      return getLearnerProficiencyIndex() > 0;
    }
  }

  bool showPOSKind() {
    if (isUserStudent()) {
      return getStudentStandard() > 5;
    } else {
      return getLearnerProficiencyIndex() > 0;
    }
  }

  bool showIndeclinable() {
    if (isUserStudent()) {
      return getStudentStandard() > 5;
    } else {
      return getLearnerProficiencyIndex() > 0;
    }
  }

  bool showHypernyms() {
    if (isUserStudent()) {
      return getStudentStandard() > 5;
    } else {
      return getLearnerProficiencyIndex() > 0;
    }
  }

  bool showHyponyms() {
    if (isUserStudent()) {
      return getStudentStandard() > 5;
    } else {
      return getLearnerProficiencyIndex() > 0;
    }
  }

  bool showMeronyms() {
    if (isUserStudent()) {
      return getStudentStandard() > 5;
    } else {
      return getLearnerProficiencyIndex() > 0;
    }
  }

  bool showHolonyms() {
    if (isUserStudent()) {
      return getStudentStandard() > 5;
    } else {
      return getLearnerProficiencyIndex() > 0;
    }
  }

  bool showModifiesVerb() {
    if (isUserStudent()) {
      return getStudentStandard() > 12;
    } else {
      return getLearnerProficiencyIndex() == 2;
    }
  }

  bool showModifiesNoun() {
    if (isUserStudent()) {
      return getStudentStandard() > 12;
    } else {
      return getLearnerProficiencyIndex() == 2;
    }
  }

  void unsetOnboardingDone() {
    _storage.remove('onboardingDone');
  }
}
