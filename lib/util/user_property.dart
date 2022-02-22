enum UserProperty {
  studentBoard,
  studentStandard,
  learnerProficiency,
}

List<String> _userPropertyToString = [
  'Student Board',
  'Student Standard',
  'Learner Proficiency'
];

String userPropertyToString(UserProperty userProperty) {
  return _userPropertyToString[userProperty.index];
}
