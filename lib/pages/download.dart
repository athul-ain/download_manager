import 'dart:io';
import 'package:download_manager/models/image_download.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  final List<ImageDownloadModel> imageList;
  const DownloadPage({Key? key, required this.imageList}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<ImageDownloadModel> imageList = [];

  late ImageDownloadModel currentDownload;
  int progress = 0;
  double currentDownloadProgress = 0;
  String? downloadPath;

  @override
  void initState() {
    if (mounted)
      setState(() {
        imageList = widget.imageList;
        currentDownload = widget.imageList.first;
      });

    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) => pickDir());
  }

  void download() async {
    int imgLi = 0;
    while (imgLi < imageList.length) {
      setState(() => currentDownload = imageList[imgLi]);

      int i = imageList[imgLi].offset;
      while (i < imageList[imgLi].end) {
        if (mounted) setState(() => progress = i);
        try {
          final core = await Flowder.download(
            "${currentDownload.link}$i.jpg",
            DownloaderUtils(
              progressCallback: (current, total) {
                final progress = (current / total);
                print('Downloading: $progress');
                if (mounted)
                  setState(() {
                    currentDownloadProgress = progress;
                  });
              },
              file: File("$downloadPath/${currentDownload.dirName}/$i.jpg"),
              progress: ProgressImplementation(),
              onDone: () => i++,
              deleteOnCancel: true,
            ),
          );
        } catch (e) {
          i++;
          print(e.toString());
        }
      }

      if (mounted)
        setState(() {
          currentDownloadProgress = 0;
          progress = 0;
          imageList[imgLi].downloadCompleted = true;
        });
      imgLi++;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Download Completed")));
    Navigator.pop(context);
  }

  Future<void> pickDir() async {
    String? path = await FilesystemPicker.open(
      title: 'Save to folder',
      context: context,
      rootDirectory: Directory("./Downloads"),
      fsType: FilesystemType.folder,
      pickText: 'Save files to this folder',
      folderIconColor: Colors.blue,
    );

    if (path == null) {
      pickDir();
    } else {
      if (mounted)
        setState(() {
          downloadPath = path;
        });
      download();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.cancel)),
      ),
      body: Row(
        children: [
          Drawer(
            elevation: 0,
            child: Ink(
              color: Colors.grey[100],
              child: Column(
                children: imageList
                    .map((e) => ListTile(
                          title: Text(e.dirName),
                          subtitle: Text(e.link),
                          trailing: e.downloadCompleted
                              ? Icon(Icons.done)
                              : Icon(Icons.pending),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentDownload.link,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                Container(height: 30),
                Text(
                  "$downloadPath/${currentDownload.dirName}/",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Container(height: 30),
                Text(
                  "$progress / ${currentDownload.end}",
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
                Container(height: 30),
                CircularProgressIndicator(
                  value: currentDownloadProgress,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
