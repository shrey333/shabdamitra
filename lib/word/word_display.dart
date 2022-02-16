import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shabdamitra/db/gender.dart';
import 'package:shabdamitra/db/word.dart';
import 'package:shabdamitra/db/word_synset.dart';
import 'package:shabdamitra/word/image_display.dart';

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
  final Word word;
  final int index;
  List<WordSynset> wordSynsets = <WordSynset>[];
  List<Word> synonyms = <Word>[];
  List<String> opposites = <String>[];
  String pluralForm = '';
  final height = Get.height;
  final player = AudioPlayer();

  _WordDisplayState(this.word, this.index) {
    word.getWordSynsets().then((wordSynsetsFut) {
      wordSynsetsFut[index].then((wordSynset) {
        wordSynset.getPluralForm().then((_pluralForm) {
          wordSynset.getSynonyms().then((_synonyms) {
            wordSynset.getOpposites().then((_opposites) {
              setState(() {
                wordSynsets.add(wordSynset);
                pluralForm = _pluralForm;
                synonyms = _synonyms;
                opposites = _opposites;
              });
            });
          });
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
                await player.setUrl(wordSynsets[0].audioURL);
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
                    if (pluralForm != '')
                      ListTile(
                        title: const Text('बहुवचन'),
                        subtitle: Text(pluralForm),
                      ),
                    ListTile(
                      title: const Text("लिंग"),
                      subtitle: Text(genderToString(wordSynsets[0].gender)),
                    ),
                    if (synonyms.isNotEmpty)
                      ListTile(
                        title: const Text("समानार्थी शब्द"),
                        subtitle: Wrap(
                          children: synonyms.map((synonym) {
                            return ActionChip(
                                label: Text(synonym.word), onPressed: () {});
                          }).toList(),
                        ),
                      ),
                    if (opposites.isNotEmpty)
                      ListTile(
                        title: const Text("विलोम शब्द"),
                        subtitle: Wrap(
                          children: opposites.map((opposite) {
                            return ActionChip(
                                label: Text(opposite), onPressed: () {});
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
