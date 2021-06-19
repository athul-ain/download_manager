import 'dart:io';

import 'package:download_manager/pages/home.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _incrementCounter() async {
    String? path = await FilesystemPicker.open(
      title: 'Save to folder',
      context: context,
      rootDirectory: Directory("./Downloads"),
      fsType: FilesystemType.folder,
      pickText: 'Save file to this folder',
      folderIconColor: Colors.teal,
    );

    print(path);

    final downloaderUtils = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        print('Downloading: $progress');
      },
      file: File('$path/test1.png'),
      progress: ProgressImplementation(),
      onDone: () => print('Download done'),
      deleteOnCancel: true,
    );

    final core = await Flowder.download(
      'https://via.placeholder.com/300x300.png',
      downloaderUtils,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
