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
  const WordDisplay({Key? key, required this.word}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _WordDisplayState createState() => _WordDisplayState(word);
}

class _WordDisplayState extends State<WordDisplay> {
  final Word word;
  List<WordSynset> wordSynsets = <WordSynset>[];
  // List<Word> synonyms = <Word>[];
  // List<Word> opposites = <Word>[];
  // String pluralForm = '';
  final height = Get.height;
  final player = AudioPlayer();

  _WordDisplayState(this.word) {
    word.getWordSynsets().then((wordSynsetsFut) {
      wordSynsetsFut[0].then((value) => setState(() {
            wordSynsets.add(value);
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (wordSynsets.isNotEmpty) {
    //   wordSynsets[0].getPluralForm().then((value) => setState(() {
    //         pluralForm = value;
    //       }));
    //   wordSynsets[0].getSynonyms().then((value) => setState(() {
    //         synonyms = value;
    //       }));
    //   wordSynsets[0].getOpposites().then((value) => setState(() {
    //         opposites = value;
    //       }));
    // }
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
                      subtitle: Row(
                        children: wordSynsets[0]
                            .synset
                            .examples
                            .map((example) => Text(example))
                            .toList(),
                      ),
                    ),
                    // ListTile(
                    //   title: const Text('बहुवचन'),
                    //   subtitle: Text(pluralForm),
                    // ),
                    // ListTile(
                    //   title: const Text("समानार्थी शब्द"),
                    //   subtitle: Row(
                    //     children: synonyms.map((synonym) {
                    //       return ActionChip(
                    //           label: Text(synonym.word), onPressed: () {});
                    //     }).toList(),
                    //   ),
                    // ),
                    ListTile(
                      title: const Text("लिंग"),
                      subtitle: Text(genderToString(wordSynsets[0].gender)),
                    ),
                    // ListTile(
                    //   title: const Text("विलोम शब्द"),
                    //   subtitle: Row(
                    //     children: opposites.map((opposite) {
                    //       return ActionChip(
                    //           label: Text(opposite.word), onPressed: () {});
                    //     }).toList(),
                    //   ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
