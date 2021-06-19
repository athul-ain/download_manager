import 'package:download_manager/pages/image_downloader.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            elevation: 0,
            child: Ink(
              color: Colors.grey[100],
              child: Column(
                children: [
                  ListTile(
                    title: Text("Image Downloader"),
                    leading: Icon(Icons.image_rounded),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: ImageDownloader()),
        ],
      ),
    );
  }
}
