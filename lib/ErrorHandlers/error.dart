import 'package:flutter/material.dart';

class ErrorRoute extends StatelessWidget {
  const ErrorRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _biggerFont = TextStyle(fontSize: 20);
    const _fontStyle = TextStyle(fontSize: 14);
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body:
        Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/images/error.gif',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  heightFactor: 3.0,
                  child: Column(
                    children:  const [
                      Text('Something Went Wrong!!', style: _biggerFont,),
                      Text('An error has occurred, Please restart the App', style: _fontStyle,)
                    ],
                  )
              )
            ]
        )
    );
  }
}
