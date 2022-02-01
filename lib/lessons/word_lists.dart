import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';

class WordLists extends StatefulWidget {
  const WordLists({Key? key}) : super(key: key);

  @override
  _WordListsState createState() => _WordListsState();
}

class _WordListsState extends State<WordLists> {

  _getItems() {
    return List<String>.generate(30, (i) => 'Item $i');
  }

  @override
  Widget build(BuildContext context) {
    var items = _getItems();
    return Scaffold(
      appBar: AppBar(title: const Text("Word Lists"),),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                child: ListTile(
                  minVerticalPadding: 10,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade500,
                    child: Text(items[index][0]),
                  ),
                  title: Text(items[index]),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail(items[index])));
                  },
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
              );
            }
        ),
      )
    );

  }
}


class Detail extends StatelessWidget {

  final String w;
  const Detail(this.w, {Key? key}) : super(key: key);


  Future _speak(String s) async {
    var flutterTts = FlutterTts();
    flutterTts.setLanguage("hi-IN");
    await flutterTts.speak(s);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                elevation: 4.0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () => _speak(w),
                        ),
                        title: Text(w),
                      ),
                    ),

                    SizedBox(
                      height: 200,
                      child: Ink.image(
                        image: const NetworkImage("https://source.unsplash.com/random/800x600?house"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text("Beautiful home to rent, recently refurbished with modern appliances..."),
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