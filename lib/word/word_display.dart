// ignore_for_file: no_logic_in_create_state

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shabdamitra/ErrorHandlers/error.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/enums.dart';
import 'package:shabdamitra/db/word_synset.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WordDisplay extends StatefulWidget {
  final List<WordSynset> wordSynsets;
  final int initialWordSynset;
  const WordDisplay(
      {Key? key, required this.wordSynsets, this.initialWordSynset = 0})
      : super(key: key);

  @override
  _WordDisplayState createState() =>
      _WordDisplayState(wordSynsets, initialWordSynset);
}

class _WordDisplayState extends State<WordDisplay> {
  final List<WordSynset> wordSynsets;
  final int initialWordSynset;

  _WordDisplayState(this.wordSynsets, this.initialWordSynset);

  @override
  Widget build(BuildContext context) {
    PageController pageController =
        PageController(initialPage: initialWordSynset);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Flexible(
            flex: 19,
            child: PageView.builder(
              controller: pageController,
              itemCount: wordSynsets.length,
              itemBuilder: (context, index) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(wordSynsets[index].word.word),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () async {
                          var player = AudioPlayer();
                          await player.setUrl(wordSynsets[index].audioURL);
                          await player.play();
                        },
                      ),
                    ],
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  body: Card(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        if (ApplicationContext().showIllustration())
                          ListTile(
                            title: CachedNetworkImage(
                              imageUrl: wordSynsets[index].imageURL,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                              height: Get.height * 0.3,
                            ),
                          ),
                        ListTile(
                          title: const Text('परिभाषा'),
                          subtitle:
                              Text(wordSynsets[index].synset.conceptDefinition),
                        ),
                        FutureBuilder<PartOfSpeechWithSubtype>(
                          future: wordSynsets[index].getPOS(),
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
                              PartOfSpeechWithSubtype posWithSubtype =
                                  snapshot.data!;
                              if (posWithSubtype.part !=
                                  PartOfSpeech.unspecificed) {
                                return Column(children: [
                                  ListTile(
                                    title: const Text('शब्दभेद'),
                                    subtitle: Text(
                                      partOfSpeechToString(posWithSubtype.part),
                                    ),
                                  ),
                                  if (ApplicationContext().showPOSKind() &&
                                      posWithSubtype.kind !=
                                          KindOfPartOfSpeech.unspecified)
                                    ListTile(
                                      title: Text(
                                          '${partOfSpeechToString(posWithSubtype.part)} का प्रकार'),
                                      subtitle: Text(kindOfPOSToString(
                                          posWithSubtype.kind)),
                                    ),
                                ]);
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        if (wordSynsets[index].synset.examples.isNotEmpty)
                          ListTile(
                            title: const Text('वाक्य में प्रयोग'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: wordSynsets[index]
                                  .synset
                                  .examples
                                  .map((example) => Text(
                                        example,
                                        textAlign: TextAlign.left,
                                      ))
                                  .toList(),
                            ),
                          ),
                        if (ApplicationContext().showPluralForm())
                          FutureBuilder<String>(
                            future: wordSynsets[index].getPluralForm(),
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
                                String pluralForm = snapshot.data!;
                                if (pluralForm != '') {
                                  return ListTile(
                                    title: const Text('बहुवचन'),
                                    subtitle: Text(pluralForm),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showGender())
                          FutureBuilder<Gender>(
                            future: wordSynsets[index].getGender(),
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
                                Gender gender = snapshot.data!;
                                return ListTile(
                                  title: const Text('लिंग'),
                                  subtitle: Text(genderToString(gender)),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        FutureBuilder<List<WordSynset>>(
                          future: wordSynsets[index].getSynonyms(),
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
                              List<WordSynset> synonyms = snapshot.data!;
                              if (synonyms.isNotEmpty) {
                                return ListTile(
                                  title: const Text('समानार्थी शब्द'),
                                  subtitle: Wrap(
                                    children: synonyms.map((synonym) {
                                      return ActionChip(
                                          label: Text(synonym.word.word),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WordDisplay(
                                                            wordSynsets: [
                                                              synonym
                                                            ])));
                                          });
                                    }).toList(),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        FutureBuilder<List<WordSynset>>(
                          future: wordSynsets[index].getAntonyms(),
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
                              List<WordSynset> antonyms = snapshot.data!;
                              if (antonyms.isNotEmpty) {
                                return ListTile(
                                  title: const Text('विलोम शब्द'),
                                  subtitle: Wrap(
                                    children: antonyms.map((antonym) {
                                      return ActionChip(
                                          label: Text(antonym.word.word),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WordDisplay(
                                                            wordSynsets: [
                                                              antonym
                                                            ])));
                                          });
                                    }).toList(),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        if (ApplicationContext().showAffix())
                          FutureBuilder<Affix>(
                            future: wordSynsets[index].getAffix(),
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
                                Affix affix = snapshot.data!;
                                if (affix.affixKind != AffixKind.unspecified) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: const Text('मूल शब्द'),
                                        subtitle: Text(affix.root),
                                      ),
                                      ListTile(
                                        title: Text(
                                            affixKindToString(affix.affixKind)),
                                        subtitle: Text(affix.affix),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showCountability())
                          FutureBuilder<Countability>(
                            future: wordSynsets[index].getCountability(),
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
                                Countability countability = snapshot.data!;
                                if (countability != Countability.unspecified) {
                                  return ListTile(
                                    title: const Text('गणनीयता'),
                                    subtitle: Text(
                                      countabilityToString(countability),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showJunction())
                          FutureBuilder<Junction>(
                            future: wordSynsets[index].getJunction(),
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
                                Junction junction = snapshot.data!;
                                if (junction != Junction.unspecified) {
                                  return ListTile(
                                    title: const Text('संधि'),
                                    subtitle: Text(junctionToString(junction)),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showIndeclinable())
                          FutureBuilder<Indeclinable>(
                            future: wordSynsets[index].getIndeclinable(),
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
                                Indeclinable indeclinable = snapshot.data!;
                                if (indeclinable != Indeclinable.unspecified) {
                                  return ListTile(
                                    title: const Text('अव्यय'),
                                    subtitle: Text(
                                        indeclinableToString(indeclinable)),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showTransitivity())
                          FutureBuilder<Transitivity>(
                            future: wordSynsets[index].getTransitivity(),
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
                                Transitivity transitivity = snapshot.data!;
                                if (transitivity != Transitivity.unspecified) {
                                  return ListTile(
                                    title: const Text('संक्रामिता'),
                                    subtitle: Text(
                                        transitivityToString(transitivity)),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showHypernyms())
                          FutureBuilder<List<WordSynset>>(
                            future: wordSynsets[index].getHypernyms(),
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
                                List<WordSynset> hypernyms = snapshot.data!;
                                if (hypernyms.isNotEmpty) {
                                  return ListTile(
                                    title: const Text('एक तरह का'),
                                    subtitle: Wrap(
                                      children: hypernyms.map((hypernym) {
                                        return ActionChip(
                                            label: Text(hypernym.word.word),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WordDisplay(
                                                              wordSynsets: [
                                                                hypernym
                                                              ])));
                                            });
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showHyponyms())
                          FutureBuilder<List<WordSynset>>(
                            future: wordSynsets[index].getHyponyms(),
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
                                List<WordSynset> hyponyms = snapshot.data!;
                                if (hyponyms.isNotEmpty) {
                                  return ListTile(
                                    title: const Text('प्रकार'),
                                    subtitle: Wrap(
                                      children: hyponyms.map((hyponym) {
                                        return ActionChip(
                                            label: Text(hyponym.word.word),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WordDisplay(
                                                              wordSynsets: [
                                                                hyponym
                                                              ])));
                                            });
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showMeronyms())
                          FutureBuilder<List<WordSynset>>(
                            future: wordSynsets[index].getMeronyms(),
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
                                List<WordSynset> meronyms = snapshot.data!;
                                if (meronyms.isNotEmpty) {
                                  return ListTile(
                                    title: const Text('का हिस्सा'),
                                    subtitle: Wrap(
                                      children: meronyms.map((meronym) {
                                        return ActionChip(
                                            label: Text(meronym.word.word),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WordDisplay(
                                                              wordSynsets: [
                                                                meronym
                                                              ])));
                                            });
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showHolonyms())
                          FutureBuilder<List<WordSynset>>(
                            future: wordSynsets[index].getHolonyms(),
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
                                List<WordSynset> holonyms = snapshot.data!;
                                if (holonyms.isNotEmpty) {
                                  return ListTile(
                                    title: const Text('अंगिवाची'),
                                    subtitle: Wrap(
                                      children: holonyms.map((holonym) {
                                        return ActionChip(
                                            label: Text(holonym.word.word),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WordDisplay(
                                                              wordSynsets: [
                                                                holonym
                                                              ])));
                                            });
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showModifiesVerb())
                          FutureBuilder<List<WordSynset>>(
                            future: wordSynsets[index].getModifiesVerb(),
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
                                List<WordSynset> modifiesVerb = snapshot.data!;
                                if (modifiesVerb.isNotEmpty) {
                                  return ListTile(
                                    title: const Text('Modifies Verb'),
                                    subtitle: Wrap(
                                      children:
                                          modifiesVerb.map((_modifiesVerb) {
                                        return ActionChip(
                                            label:
                                                Text(_modifiesVerb.word.word),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WordDisplay(
                                                              wordSynsets: [
                                                                _modifiesVerb
                                                              ])));
                                            });
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        if (ApplicationContext().showModifiesNoun())
                          FutureBuilder<List<WordSynset>>(
                            future: wordSynsets[index].getModifiesNoun(),
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
                                List<WordSynset> modifiesNoun = snapshot.data!;
                                if (modifiesNoun.isNotEmpty) {
                                  return ListTile(
                                    title: const Text('Modifies Noun'),
                                    subtitle: Wrap(
                                      children:
                                          modifiesNoun.map((_modifiesNoun) {
                                        return ActionChip(
                                            label:
                                                Text(_modifiesNoun.word.word),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WordDisplay(
                                                              wordSynsets: [
                                                                _modifiesNoun
                                                              ])));
                                            });
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SmoothPageIndicator(
                controller: pageController,
                count: wordSynsets.length,
                effect: const ScrollingDotsEffect(
                  activeDotColor: Colors.blue,
                  activeStrokeWidth: 2.6,
                  activeDotScale: 1.3,
                  maxVisibleDots: 15,
                  radius: 8,
                  spacing: 10,
                  dotHeight: 12,
                  dotWidth: 12,
                ),
                onDotClicked: (index) {
                  pageController.jumpToPage(index);
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
