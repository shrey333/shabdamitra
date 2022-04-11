import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({Key? key, required this.word, required this.url})
      : super(key: key);
  final String word;
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
