import 'package:shabdamitra/db/data_manager.dart';

class Synset {
  DataManager dataManager;
  int synsetId;
  String conceptDefinition;
  List<String> examples;

  Synset({
    required this.dataManager,
    required this.synsetId,
    required this.conceptDefinition,
    required this.examples,
  });
}
