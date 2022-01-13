import 'package:flutter/material.dart';

class PageNotFoundRoute extends StatefulWidget {
  const PageNotFoundRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFoundRoute>
  with SingleTickerProviderStateMixin {

  late AssetImage image;

  @override
  void initState() {
    super.initState();
    image = const AssetImage('assets/images/404_error_with_person.gif');
  }

  @override
  void dispose() {
    super.dispose();
    image.evict();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.white,
        body:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: image,),
            Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 2.0,
                child: TextButton(onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Go To Home Page'),)
            )

          ],
        )
    );
  }

}