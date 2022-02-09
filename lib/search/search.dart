import 'dart:math';

import 'package:flappy_search_bar_ns/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';

class Word {
  late final String word;
  late final String meaning;
  //late final Image image;

  Word(this.word, this.meaning);
}

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchBarController<Word> _searchBarController = SearchBarController();

  Future<List<Word>> _getResult(String? text) async {
    await Future.delayed(const Duration(seconds: 2));
    if (text?.length == 8) throw Error();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    List<Word> w = [];
    var random = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));

    for (int i = 0; i < 10; i++) {
      w.add(Word("$text $i", "Meaning: ${getRandomString(20)}"));
    }

    return w;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SearchBar<Word>(
          searchBarStyle: SearchBarStyle(
            backgroundColor: const Color.fromRGBO(254, 254, 255, 255),
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10),
          ),
          searchBarPadding: const EdgeInsets.symmetric(horizontal: 10),
          headerPadding: const EdgeInsets.symmetric(horizontal: 10),
          listPadding: const EdgeInsets.symmetric(horizontal: 10),
          searchBarController: _searchBarController,
          onError: (error) => Center(
            child: Text('ERROR: ${error.toString()}'),
          ),
          placeHolder: Flexible(
            child: Center(
              child: Image.asset("assets/images/Questions.gif"),
            ),
          ),
          onSearch: _getResult,
          cancellationWidget: const Text(
            "Cancel",
            style: TextStyle(color: Colors.blue),
          ),
          emptyWidget: const Center(child: Text("No Such Entry")),
          onCancelled: () {},
          hintText: "Search Our Hindi Shabdamitra",
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 1,
          onItemFound: (Word? w, int index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade500,
                child: Text(w!.word[0]),
              ),
              title: Text(w.word),
              subtitle: Text(w.meaning),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Detail(w)));
              },
            );
          },
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  final Word w;
  const Detail(this.w, {Key? key}) : super(key: key);

  void _speak(String s) {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                elevation: 4.0,
                child: Column(
                  children: [
                    ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => _speak(w.word),
                      ),
                      title: Text(w.word),
                      subtitle: Text(
                        w.meaning,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Flexible(
                      child: Ink.image(
                        image: const NetworkImage(
                            "https://source.unsplash.com/random/800x600?house"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                          "Beautiful home to rent, recently refurbished with modern appliances..."),
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Synonym 1'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Synonym 2'),
                        ),
                      ],
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Antonym 1'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Antonym 2'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
