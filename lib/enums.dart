enum UserType {
  student,
  learner,
}

List<String> _userTypeToString = [
  'Student',
  'Learner',
];

String userTypeToString(UserType userType) {
  return _userTypeToString[userType.index];
}

List<String> _promptForUser = [
  'Select your board and standard',
  'Select your hindi proficiency level ',
];

String getPrompt(UserType userType) {
  return _promptForUser[userType.index];
}

List<String> _settingsTitleForUser = [
  'Student Settings',
  'Learner Settings',
];

String getSettingsTitle(UserType userType) {
  return _settingsTitleForUser[userType.index];
}
