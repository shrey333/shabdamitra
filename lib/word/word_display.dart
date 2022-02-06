import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shabdamitra/word/image_display.dart';

class WordDisplay extends StatefulWidget {
  const WordDisplay({Key? key}) : super(key: key);

  @override
  _WordDisplayState createState() => _WordDisplayState();
}

class _WordDisplayState extends State<WordDisplay> {
  final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('आम'),
          actions: [
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () async {
                await player.setUrl(
                    "https://www.cfilt.iitb.ac.in/hindishabdamitra-frontend/static/audio/%E0%A4%86%E0%A4%AE_3462.wav");
                player.play();
              },
            ),
          ],
        ),
        body: Swiper(
          itemCount: 10,
          loop: false,
          pagination: const SwiperPagination(),
          control: const SwiperControl(),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      Get.to(() => ImageDisplay(index: index));
                    },
                    title: CachedNetworkImage(
                      imageUrl:
                          "https://www.cfilt.iitb.ac.in/hindishabdamitra-frontend/static/images/%E0%A4%86%E0%A4%AE_3462.jpg",
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 300,
                    ),
                  ),
                  const ListTile(
                    title: Text('परिभाषा'),
                    subtitle: Text('एक फल जो खाया या चूसा जाता है'),
                  ),
                  const ListTile(
                    title: Text('वाक्य में प्रयोग'),
                    subtitle: Text('सीता को आम बहुत अच्छा लगता है ।'),
                  ),
                  const ListTile(
                    title: Text("बहुवचन"),
                    subtitle: Text("आम"),
                  ),
                  ListTile(
                    title: const Text("समानार्थी शब्द"),
                    subtitle: Row(
                      children: [
                        ActionChip(
                          label: const Text("आम्र"),
                          onPressed: () {},
                        ),
                        ActionChip(
                          label: const Text("आँब"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const ListTile(
                    title: Text("लिंग"),
                    subtitle: Text("पुल्लिंग"),
                  ),
                  const ListTile(
                    title: Text("संज्ञा के प्रकार"),
                    subtitle: Text("जातिवाचक"),
                  ),
                  const ListTile(
                    title: Text("गणनीयता"),
                    subtitle: Text("गणनीय"),
                  ),
                  ListTile(
                    title: const Text("एक तरह का"),
                    subtitle: Row(
                      children: [
                        ActionChip(
                          label: const Text("खाद्य फल"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text("प्रकार"),
                    subtitle: Wrap(
                      children: [
                        ActionChip(
                          label: const Text("तोतापरी"),
                          onPressed: () {},
                        ),
                        ActionChip(
                          label: const Text("जरदालू"),
                          onPressed: () {},
                        ),
                        ActionChip(
                          label: const Text("दशहरी"),
                          onPressed: () {},
                        ),
                        ActionChip(
                          label: const Text("सफेदा"),
                          onPressed: () {},
                        ),
                        ActionChip(
                          label: const Text("लँगड़ा आम"),
                          onPressed: () {},
                        ),
                        ActionChip(
                          label: const Text("सिंदूरिया"),
                          onPressed: () {},
                        ),
                        ActionChip(
                          label: const Text("अंबिया"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const ListTile(
                    title: Text("का हिस्सा"),
                    subtitle: Text("गुठली"),
                  ),
                  const ListTile(
                    title: Text("अंगीवाची"),
                    subtitle: Text("अमरस , आम , अमावट"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
