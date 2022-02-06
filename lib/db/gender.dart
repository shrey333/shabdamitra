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
