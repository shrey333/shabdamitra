import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/enums.dart';
import 'package:shabdamitra/db/word.dart';
import 'package:shabdamitra/db/word_synset.dart';

class WordDisplay extends StatefulWidget {
  final Word word;
  final int index;
  const WordDisplay({Key? key, required this.word, required this.index})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _WordDisplayState createState() => _WordDisplayState(word, index);
}

class _WordDisplayState extends State<WordDisplay> {
  Word word;
  int index;
  List<WordSynset> wordSynsets = <WordSynset>[];
  List<WordSynset> synonyms = <WordSynset>[];
  List<WordSynset> antonyms = <WordSynset>[];
  String pluralForm = '';
  Gender gender = Gender.unknown;
  Affix affix = Affix();
  Countability countability = Countability.unspecified;
  Transitivity transitivity = Transitivity.unspecified;
  Indeclinable indeclinable = Indeclinable.unspecified;
  Junction junction = Junction.unspecified;
  PartOfSpeechWithSubtype posWithSubtype = PartOfSpeechWithSubtype('');
  List<WordSynset> holonyms = <WordSynset>[];
  List<WordSynset> hypernyms = <WordSynset>[];
  List<WordSynset> hyponyms = <WordSynset>[];
  List<WordSynset> meronyms = <WordSynset>[];
  List<WordSynset> modifiesVerb = <WordSynset>[];
  List<WordSynset> modifiesNoun = <WordSynset>[];

  final height = Get.height;
  final player = AudioPlayer();

  _WordDisplayState(this.word, this.index) {
    word.getWordSynsets().then((wordSynsets) {
      WordSynset wordSynset = wordSynsets[index];
      List<Future> futures = <Future>[];
      if (ApplicationContext().showPluralForm()) {
        futures.add(wordSynset.getPluralForm());
      }
      futures.add(wordSynset.getSynonyms());
      futures.add(wordSynset.getAntonyms());
      if (ApplicationContext().showGender()) {
        futures.add(wordSynset.getGender());
      }
      if (ApplicationContext().showAffix()) {
        futures.add(wordSynset.getAffix());
      }
      if (ApplicationContext().showCountability()) {
        futures.add(wordSynset.getCountability());
      }
      if (ApplicationContext().showTransitivity()) {
        futures.add(wordSynset.getTransitivity());
      }
      if (ApplicationContext().showIndeclinable()) {
        futures.add(wordSynset.getIndeclinable());
      }
      if (ApplicationContext().showJunction()) {
        futures.add(wordSynset.getJunction());
      }
      if (ApplicationContext().showPOSKind()) {
        futures.add(wordSynset.getPOS());
      }
      if (ApplicationContext().showSpellingVariation()) {
        // TODO: Get Different Spelling
      }
      if (ApplicationContext().showHolonyms()) {
        futures.add(wordSynset.getHolonyms());
      }
      if (ApplicationContext().showHypernyms()) {
        futures.add(wordSynset.getHypernyms());
      }
      if (ApplicationContext().showHyponyms()) {
        futures.add(wordSynset.getHyponyms());
      }
      if (ApplicationContext().showMeronyms()) {
        futures.add(wordSynset.getMeronyms());
      }
      if (ApplicationContext().showModifiesVerb()) {
        futures.add(wordSynset.getModifiesVerb());
      }
      if (ApplicationContext().showModifiesNoun()) {
        futures.add(wordSynset.getModifiesNoun());
      }
      Future.wait(futures).then((values) {
        setState(() {
          this.wordSynsets.add(wordSynset);
          int index = 0;
          if (ApplicationContext().showPluralForm()) {
            pluralForm = values[index] as String;
            index++;
          }
          synonyms = values[index] as List<WordSynset>;
          synonyms = synonyms.sublist(0, synonyms.length >= 5 ? 5 : synonyms.length);
          index++;
          antonyms = values[index] as List<WordSynset>;
          antonyms = antonyms.sublist(0, antonyms.length >= 5 ? 5 : antonyms.length);
          index++;
          if (ApplicationContext().showGender()) {
            gender = values[index] as Gender;
            index++;
          }
          if (ApplicationContext().showAffix()) {
            affix = values[index] as Affix;
            index++;
          }
          if (ApplicationContext().showCountability()) {
            countability = values[index] as Countability;
            index++;
          }
          if (ApplicationContext().showTransitivity()) {
            transitivity = values[index] as Transitivity;
            index++;
          }
          if (ApplicationContext().showIndeclinable()) {
            indeclinable = values[index] as Indeclinable;
            index++;
          }
          if (ApplicationContext().showJunction()) {
            junction = values[index] as Junction;
            index++;
          }
          if (ApplicationContext().showPOSKind()) {
            posWithSubtype = values[index] as PartOfSpeechWithSubtype;
            index++;
          }
          if (ApplicationContext().showSpellingVariation()) {
            // TODO: Get Different Spelling
          }
          if (ApplicationContext().showHolonyms()) {
            holonyms = values[index] as List<WordSynset>;
            holonyms = holonyms.sublist(0, holonyms.length >= 5 ? 5 : holonyms.length);
            index++;
          }
          if (ApplicationContext().showHypernyms()) {
            hypernyms = values[index] as List<WordSynset>;
            hypernyms = hypernyms.sublist(0, hypernyms.length >= 5 ? 5 : hypernyms.length);
            index++;
          }
          if (ApplicationContext().showHyponyms()) {
            hyponyms = values[index] as List<WordSynset>;
            hyponyms = hyponyms.sublist(0, hyponyms.length >= 5 ? 5 : hyponyms.length);
            index++;
          }
          if (ApplicationContext().showMeronyms()) {
            meronyms = values[index] as List<WordSynset>;
            meronyms = meronyms.sublist(0, meronyms.length >= 5 ? 5 : meronyms.length);
            index++;
          }
          if (ApplicationContext().showModifiesVerb()) {
            modifiesVerb = values[index] as List<WordSynset>;
            modifiesVerb = modifiesVerb.sublist(0, modifiesVerb.length >= 5 ? 5 : modifiesVerb.length);
            index++;
          }
          if (ApplicationContext().showModifiesNoun()) {
            modifiesNoun = values[index] as List<WordSynset>;
            modifiesNoun = modifiesNoun.sublist(0, modifiesNoun.length >= 5 ? 5 : modifiesNoun.length);
            index++;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(word.word),
          actions: [
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () async {
                await player.setUrl(wordSynsets[index].audioURL);
                await player.play();
              },
            ),
          ],
        ),
        body: wordSynsets.isEmpty
            ? Center(
                child: SizedBox(
                  child: const CircularProgressIndicator(),
                  height: context.mediaQuery.size.height * 0.05,
                ),
              )
            : Card(
                child: ListView(
                  children: [
                    if (ApplicationContext().showIllustration())
                      ListTile(
                        title: CachedNetworkImage(
                          imageUrl: wordSynsets[0].imageURL,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: height * 0.3,
                        ),
                      ),
                    ListTile(
                      title: const Text('परिभाषा'),
                      subtitle: Text(wordSynsets[0].synset.conceptDefinition),
                    ),
                    if (posWithSubtype.part != PartOfSpeech.unspecificed)
                      ListTile(
                        title: const Text('शब्दभेद'),
                        subtitle:
                            Text(partOfSpeechToString(posWithSubtype.part)),
                      ),
                    ListTile(
                      title: const Text('वाक्य में प्रयोग'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: wordSynsets[0]
                            .synset
                            .examples
                            .map((example) => Text(
                                  example,
                                  textAlign: TextAlign.left,
                                ))
                            .toList(),
                      ),
                    ),
                    if (ApplicationContext().showPluralForm() &&
                        pluralForm != '')
                      ListTile(
                        title: const Text('बहुवचन'),
                        subtitle: Text(pluralForm),
                      ),
                    if (ApplicationContext().showGender())
                      ListTile(
                        title: const Text('लिंग'),
                        subtitle: Text(genderToString(gender)),
                      ),
                    if (synonyms.isNotEmpty)
                      ListTile(
                        title: const Text('समानार्थी शब्द'),
                        subtitle: Wrap(
                          children: synonyms.map((synonym) {
                            return ActionChip(
                                label: Text(synonym.word.word),
                                onPressed: () {});
                          }).toList(),
                        ),
                      ),
                    if (antonyms.isNotEmpty)
                      ListTile(
                        title: const Text('विलोम शब्द'),
                        subtitle: Wrap(
                          children: antonyms.map((opposite) {
                            return ActionChip(
                                label: Text(opposite.word.word),
                                onPressed: () {});
                          }).toList(),
                        ),
                      ),
                    if (ApplicationContext().showPOSKind() &&
                        posWithSubtype.part != PartOfSpeech.unspecificed)
                      ListTile(
                        title: Text(
                            '${partOfSpeechToString(posWithSubtype.part)} का प्रकार'),
                        subtitle: Text(kindOfPOSToString(posWithSubtype.kind)),
                      ),
                    if (ApplicationContext().showAffix() &&
                        affix.affixKind != AffixKind.unspecified) ...[
                      ListTile(
                        title: const Text('मूल शब्द'),
                        subtitle: Text(affix.root),
                      ),
                      ListTile(
                        title: Text(affixKindToString(affix.affixKind)),
                        subtitle: Text(affix.affix),
                      ),
                    ],
                    if (ApplicationContext().showCountability() &&
                        countability != Countability.unspecified)
                      ListTile(
                        title: const Text('गणनीयता'),
                        subtitle: Text(
                          countabilityToString(countability),
                        ),
                      ),
                    if (ApplicationContext().showJunction() &&
                        junction != Junction.unspecified)
                      ListTile(
                        title: const Text('संधि'),
                        subtitle: Text(junctionToString(junction)),
                      ),
                    if (ApplicationContext().showIndeclinable() &&
                        indeclinable != Indeclinable.unspecified)
                      ListTile(
                        title: const Text('अव्यय'),
                        subtitle: Text(indeclinableToString(indeclinable)),
                      ),
                    if (ApplicationContext().showTransitivity() &&
                        transitivity != Transitivity.unspecified)
                      ListTile(
                        title: const Text('संक्रामिता'),
                        subtitle: Text(transitivityToString(transitivity)),
                      ),
                    if (ApplicationContext().showHypernyms() &&
                        hypernyms.isNotEmpty)
                      ListTile(
                        title: const Text('एक तरह का'),
                        subtitle: Wrap(
                          children: hypernyms.map((hypernym) {
                            return ActionChip(
                                label: Text(hypernym.word.word),
                                onPressed: () {});
                          }).toList(),
                        ),
                      ),
                    if (ApplicationContext().showHyponyms() &&
                        hyponyms.isNotEmpty)
                      ListTile(
                        title: const Text('प्रकार'),
                        subtitle: Wrap(
                          children: hyponyms.map((hyponym) {
                            return ActionChip(
                                label: Text(hyponym.word.word),
                                onPressed: () {});
                          }).toList(),
                        ),
                      ),
                    if (ApplicationContext().showMeronyms() &&
                        meronyms.isNotEmpty)
                      ListTile(
                        title: const Text('का हिस्सा'),
                        subtitle: Wrap(
                          children: meronyms.map((meronym) {
                            return ActionChip(
                                label: Text(meronym.word.word),
                                onPressed: () {});
                          }).toList(),
                        ),
                      ),
                    if (ApplicationContext().showHolonyms() &&
                        holonyms.isNotEmpty)
                      ListTile(
                        title: const Text('अंगिवाची'),
                        subtitle: Wrap(
                          children: holonyms.map((holonym) {
                            return ActionChip(
                                label: Text(holonym.word.word),
                                onPressed: () {});
                          }).toList(),
                        ),
                      ),
                    if (ApplicationContext().showModifiesVerb() &&
                        modifiesVerb.isNotEmpty)
                      ListTile(
                        title: const Text('Modifies Verb'),
                        subtitle: Wrap(
                          children: modifiesVerb.map((_modifiesVerb) {
                            return ActionChip(
                                label: Text(_modifiesVerb.word.word),
                                onPressed: () {});
                          }).toList(),
                        ),
                      ),
                    if (ApplicationContext().showModifiesNoun() &&
                        modifiesNoun.isNotEmpty)
                      ListTile(
                        title: const Text('Modifies Noun'),
                        subtitle: Wrap(
                          children: modifiesVerb.map((_modifiesNoun) {
                            return ActionChip(
                                label: Text(_modifiesNoun.word.word),
                                onPressed: () {});
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
