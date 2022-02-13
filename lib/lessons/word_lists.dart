import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/word/word_display.dart';

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
      appBar: AppBar(
        title: const Text("Word Lists"),
      ),
      body: ListView.builder(
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
                Get.to(() => const WordDisplay());
              },
            ),
            padding: const EdgeInsets.symmetric(vertical: 5),
          );
        },
      ),
    );
  }
}
