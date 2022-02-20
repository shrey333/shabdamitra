enum Gender {
  masculine,
  feminine,
  neuter,
  unknown,
}

final Map<String, Gender> _stringToGender = {
  'F': Gender.feminine,
  'M': Gender.masculine,
  'M/F': Gender.neuter,
  'U': Gender.unknown,
};

Gender genderFrom(String gender) {
  return _stringToGender[gender]!;
}

final List<String> _genderStrings = <String>[
  'स्त्रीलिंग',
  'पुल्लिंग',
  'नपुंसकलिंग',
  'अनजान'
];

String genderToString(Gender gender) {
  return _genderStrings[gender.index];
}

enum PartOfSpeech {
  noun,
  verb,
  adjective,
  adverb,
  unspecificed,
}

final List<String> _posStrings = <String>[
  'संज्ञा',
  'क्रिया',
  'विशेषण',
  'क्रियाविशेषण',
  ''
];

String partOfSpeechToString(PartOfSpeech partOfSpeech) {
  return _posStrings[partOfSpeech.index];
}

enum KindOfPartOfSpeech {
  properNoun,
  commonNoun,
  abstractNoun,
  collectiveNoun,
  simpleVerb,
  combinedVerb,
  compoundVerb,
  causativeVerb,
  qualitativeAdjective,
  numeralAdjective,
  quantitativeAdjective,
  pronominalAdjective,
  mannerAdverb,
  placeAdverb,
  timeAdverb,
  quantityAdverb,
  unspecified,
}

final List<String> _posKindStrings = <String>[
  'व्यक्तिवाचक',
  'जातिवाचक',
  'भाववाचक',
  'समूहवाचक',
  'सरल',
  'संयुक्त',
  'यौगिक',
  'प्रेरणार्थक',
  'गुणवाचक',
  'संख्यावाचक',
  'परिमाणवाचक',
  'सार्वनामिक',
  'रीतिवाचक',
  'स्थानवाचक',
  'कालवाचक',
  'परिमाणवाचक',
  ''
];

String kindOfPOSToString(KindOfPartOfSpeech kindOfPartOfSpeech) {
  return _posKindStrings[kindOfPartOfSpeech.index];
}

class PartOfSpeechWithSubtype {
  late final PartOfSpeech part;
  late final KindOfPartOfSpeech kind;

  static final Map<String, KindOfPartOfSpeech> _nouns = {
    'BV': KindOfPartOfSpeech.abstractNoun,
    'JA': KindOfPartOfSpeech.commonNoun,
    'SV': KindOfPartOfSpeech.collectiveNoun,
    'VY': KindOfPartOfSpeech.properNoun,
  };

  static final Map<String, KindOfPartOfSpeech> _verbs = {
    'SI': KindOfPartOfSpeech.simpleVerb,
    'CJ': KindOfPartOfSpeech.combinedVerb,
    'CS': KindOfPartOfSpeech.causativeVerb,
    'CP': KindOfPartOfSpeech.compoundVerb,
  };

  static final Map<String, KindOfPartOfSpeech> _adjectives = {
    'GU': KindOfPartOfSpeech.qualitativeAdjective,
    'PA': KindOfPartOfSpeech.quantitativeAdjective,
    'SK': KindOfPartOfSpeech.numeralAdjective,
    'SR': KindOfPartOfSpeech.pronominalAdjective,
  };

  static final Map<String, KindOfPartOfSpeech> _adverbs = {
    'RI': KindOfPartOfSpeech.mannerAdverb,
    'ST': KindOfPartOfSpeech.placeAdverb,
    'KA': KindOfPartOfSpeech.timeAdverb,
    'PR': KindOfPartOfSpeech.quantityAdverb,
  };

  PartOfSpeechWithSubtype(String subtype) {
    if (_nouns.containsKey(subtype)) {
      part = PartOfSpeech.noun;
      kind = _nouns[subtype]!;
    } else if (_verbs.containsKey(subtype)) {
      part = PartOfSpeech.verb;
      kind = _verbs[subtype]!;
    } else if (_adjectives.containsKey(subtype)) {
      part = PartOfSpeech.adjective;
      kind = _adjectives[subtype]!;
    } else if (_adverbs.containsKey(subtype)) {
      part = PartOfSpeech.adverb;
      kind = _adverbs[subtype]!;
    } else {
      part = PartOfSpeech.unspecificed;
      kind = KindOfPartOfSpeech.unspecified;
    }
  }
}

enum Junction {
  swar,
  vyanjan,
  visarg,
  unspecified,
}

final Map<String, Junction> _stringToJunction = {
  'VY': Junction.vyanjan,
  'SW': Junction.swar,
  'VI': Junction.visarg,
};

Junction junctionFrom(String junction) {
  if (_stringToJunction.containsKey(junction)) {
    return _stringToJunction[junction]!;
  } else {
    return Junction.unspecified;
  }
}

final List<String> _junctionToString = ['स्वर', 'व्यंजन', 'विसर्ग', ''];

String junctionToString(Junction junction) {
  return _junctionToString[junction.index];
}

enum AffixKind {
  prefix,
  suffix,
  unspecified,
}

final List<String> _affixKindToString = ['उपसर्ग', 'प्रत्यय', ''];

String affixKindToString(AffixKind affixKind) {
  return _affixKindToString[affixKind.index];
}

class Affix {
  late final String root;
  late final String affix;
  late final AffixKind affixKind;

  Affix() {
    root = '';
    affix = '';
    affixKind = AffixKind.unspecified;
  }

  Affix.prefix(this.root, this.affix) {
    affixKind = AffixKind.prefix;
  }

  Affix.suffix(this.root, this.affix) {
    affixKind = AffixKind.suffix;
  }
}

enum Countability {
  countable,
  uncountable,
  unspecified,
}

final Map<String, Countability> _stringToCountability = {
  'C': Countability.countable,
  'UC': Countability.uncountable,
};

Countability countabilityFrom(String countability) {
  if (_stringToCountability.containsKey(countability)) {
    return _stringToCountability[countability]!;
  } else {
    return Countability.unspecified;
  }
}

final List<String> _countabilityToString = ['गणनीय', 'अगणनीय', ''];

String countabilityToString(Countability countability) {
  return _countabilityToString[countability.index];
}

enum Indeclinable {
  yes,
  no,
  unspecified,
}

final Map<String, Indeclinable> _stringToIndeclinable = {
  'Y': Indeclinable.yes,
  'N': Indeclinable.no,
};

Indeclinable indeclinableFrom(String indeclinable) {
  if (_stringToCountability.containsKey(indeclinable)) {
    return _stringToIndeclinable[indeclinable]!;
  } else {
    return Indeclinable.unspecified;
  }
}

final List<String> _indeclinableToString = ['हाँ', 'ना', ''];

String indeclinableToString(Indeclinable indeclinable) {
  return _indeclinableToString[indeclinable.index];
}

enum Transitivity {
  transitive,
  intransitive,
  unspecified,
}

final Map<String, Transitivity> _stringToTransitivity = {
  'IT': Transitivity.intransitive,
  'T': Transitivity.transitive,
};

Transitivity transitivityFrom(String transitivity) {
  if (_stringToTransitivity.containsKey(transitivity)) {
    return _stringToTransitivity[transitivity]!;
  } else {
    return Transitivity.unspecified;
  }
}

final List<String> _transitivityToString = ['सकर्मक', 'अकर्मक', ''];

String transitivityToString(Transitivity transitivity) {
  return _transitivityToString[transitivity.index];
}
