enum Gender {
  masculine,
  feminine,
  genderNeutral,
  unknown,
}

Gender genderFrom(String gender) {
  if (gender == 'F') {
    return Gender.feminine;
  } else if (gender == 'M') {
    return Gender.masculine;
  } else if (gender == 'M/F') {
    return Gender.genderNeutral;
  } else {
    return Gender.unknown;
  }
}

String genderToString(Gender gender) {
  if (gender == Gender.feminine) {
    return 'स्त्रीलिंग';
  } else if (gender == Gender.masculine) {
    return 'पुल्लिंग';
  } else if (gender == Gender.genderNeutral) {
    return 'पुल्लिंग एवं स्त्रीलिंग';
  } else {
    return 'अनजान';
  }
}
