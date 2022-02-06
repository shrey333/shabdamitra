import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Center(
            child: CachedNetworkImage(
              imageUrl:
                  "https://www.cfilt.iitb.ac.in/hindishabdamitra-frontend/static/images/%E0%A4%86%E0%A4%AE_3462.jpg",
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
