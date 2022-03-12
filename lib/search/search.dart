import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/ErrorHandlers/error.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/word.dart';
import 'package:shabdamitra/db/word_synset.dart';
import 'package:shabdamitra/word/word_display.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Shabdamitra"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchShabdamitra(onClose: () {
                    setState(() {});
                  }));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: PageView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ApplicationContext().getRecentSearches().isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(
                    children: ApplicationContext()
                        .getRecentSearches()
                        .map(
                          (word) => FutureBuilder<List<WordSynset>>(
                            future: word.getWordSynsets(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return const ErrorRoute();
                              }
                              if (snapshot.hasData) {
                                List<WordSynset> wordSynsets = snapshot.data!;
                                if (wordSynsets.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ActionChip(
                                        label: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            word.word,
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(() => WordDisplay(
                                              wordSynsets: wordSynsets));
                                        }),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }
}

class SearchShabdamitra extends SearchDelegate<String> {
  List<Word> suggestions = <Word>[];
  void Function() onClose;

  SearchShabdamitra({required this.onClose}) : super();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        onClose();
        close(context, query);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<Word>(
      future: ApplicationContext().dataManager.getWord(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              query == '' ? '' : 'No results found...',
            ),
          );
        }
        if (snapshot.hasData) {
          Word word = snapshot.data!;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade500,
              child: Text(word.word[0]),
            ),
            title: Text(word.word),
            onTap: () {
              ApplicationContext().addToRecentSearch(word);
              Get.to(() {
                return FutureBuilder<List<WordSynset>>(
                  future: word.getWordSynsets(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const ErrorRoute();
                    }
                    if (snapshot.hasData) {
                      List<WordSynset> wordSynsets = snapshot.data!;
                      if (wordSynsets.isNotEmpty) {
                        return WordDisplay(wordSynsets: wordSynsets);
                      } else {
                        return Center(
                          child: Text(
                            'Sorry. Couldn\'t find word: ' + query,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                );
              });
            },
          );
        }
        return Container();
      },
    );
  }
}
