import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final List<String> imageUrls = [
  "https://avatars.githubusercontent.com/u/68773259?v=4",
  "https://avatars.githubusercontent.com/u/51291657?v=4",
  "https://avatars.githubusercontent.com/u/53311728?v=4"
];

final List<String> githubUrls = [
  "https://github.com/d3v-26",
  "https://github.com/VishalDalwadi",
  "https://github.com/shrey333"
];

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  _launchUrl(url) async{
    if(!await launch(url)){
       showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Could not Open URL"),
            content: Text("Error in opening $url"),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Get.back();
                },
                child: const Text(
                  'Okay ',
                ),
              )
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Developers"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  imageUrls[0]
              ),
            ),
            title: const Text("Dev Patel"),
            subtitle: const Text("Web Developer"),
            trailing: const Icon(Icons.open_in_new),
            onTap: (){
              _launchUrl(githubUrls[0]);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  imageUrls[1]
              ),
            ),
            title: const Text("Vishal Dalwadi"),
            subtitle: const Text("Web Developer"),
            trailing: const Icon(Icons.open_in_new),
            onTap: (){
              _launchUrl(githubUrls[1]);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  imageUrls[2]
              ),
            ),
            title: const Text("Shrey Bhadiyadara"),
            subtitle: const Text("Web Developer"),
            trailing: const Icon(Icons.open_in_new),
            onTap: (){
              _launchUrl(githubUrls[2]);
            },
          )
        ],
      ),
    );
  }
}
