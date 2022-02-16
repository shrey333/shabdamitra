import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shabdamitra/db/data_manager.dart';
import 'package:shabdamitra/db/word_synset.dart';
import 'package:shabdamitra/word/word_display.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<WordSynset> wordSynsets = <WordSynset>[];

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = DataManager();
    return SafeArea(
      child: FloatingSearchBar(
        body: FloatingSearchBarScrollNotifier(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 60),
            itemCount: wordSynsets.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Center(
                    child: Text(wordSynsets[index].word.word[0]),
                  ),
                ),
                title: Text(wordSynsets[index].word.word),
                onTap: () {
                  Get.to(() => WordDisplay(
                        word: wordSynsets[index].word,
                        index: index,
                      ));
                },
              );
            },
          ),
        ),
        hint: 'Search any hindi word...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 400),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: 0.0,
        openAxisAlignment: 0.0,
        width: 600,
        debounceDelay: const Duration(milliseconds: 400),
        onQueryChanged: (query) {
          dataManager.getWord(query).then((word) {
            word.getWordSynsets().then((_wordSynsets) async {
              List<WordSynset> ws = <WordSynset>[];
              for (var wordSynsetFut in _wordSynsets) {
                ws.add(await wordSynsetFut);
              }
              setState(() {
                wordSynsets = ws;
              });
            });
          });
        },
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          // return ClipRRect(
          //   borderRadius: BorderRadius.circular(8),
          //   // child: Material(
          //   //   color: Colors.white,
          //   //   elevation: 4.0,
          //   // child: Column(
          //   //   mainAxisSize: MainAxisSize.min,
          //   //   children: Colors.accents.map(
          //   //     (color) {
          //   //       return Container(height: 50, color: color);
          //   //     },
          //   //   ).toList(),
          //   // ),
          // );
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
