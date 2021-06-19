import 'package:download_manager/models/image_download.dart';
import 'package:download_manager/pages/download.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageDownloader extends StatefulWidget {
  const ImageDownloader({Key? key}) : super(key: key);

  @override
  _ImageDownloaderState createState() => _ImageDownloaderState();
}

class _ImageDownloaderState extends State<ImageDownloader> {
  final _formKey = GlobalKey<FormState>();
  List<ImageDownloadModel> imageLinkList = [];

  TextEditingController linkController = TextEditingController();
  TextEditingController directoryController = TextEditingController();
  TextEditingController offsetController = TextEditingController();
  TextEditingController endController = TextEditingController();

  @override
  void initState() {
    offsetController.text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 1300,
              margin: EdgeInsets.only(bottom: 30),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                children: [
                      TableRow(
                        children: [
                          Text(
                            'Link',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            'Offset',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            'End',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            'Dirname',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(''),
                        ],
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                        ),
                      ),
                    ] +
                    imageLinkList
                        .map((e) => TableRow(children: [
                              TableCell(child: Text("${e.link}")),
                              TableCell(child: Text("${e.offset}")),
                              TableCell(child: Text("${e.end}")),
                              TableCell(child: Text("${e.dirName}")),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    imageLinkList.remove(e);
                                  });
                                },
                                child: Icon(Icons.delete),
                              )
                            ]))
                        .toList(),
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              Container(
                width: 1300,
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: linkController,
                  validator: (value) {
                    bool validUrl = Uri.parse(value ?? "123").isAbsolute;
                    if (!validUrl) {
                      return "Enter a valid Url";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.link),
                    helperText: "Link",
                    border: OutlineInputBorder(),
                    suffixIcon: TextButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: linkController.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Link Copied to Clipboard"),
                          ),
                        );
                      },
                      child: Icon(Icons.copy),
                    ),
                  ),
                ),
              ),
              Container(
                width: 700,
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: directoryController,
                  validator: (value) {
                    if (value == "") {
                      return "Enter a valid Directory";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.folder),
                    helperText: "Directory",
                    border: OutlineInputBorder(),
                    suffixIcon: TextButton(
                      onPressed: () {
                        List _list = linkController.text.split('/');
                        setState(() {
                          directoryController.text = _list.last;
                        });
                      },
                      child: Icon(Icons.sync),
                    ),
                  ),
                ),
              ),
              Container(
                width: 88,
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: offsetController,
                  validator: (value) {
                    var result = int.tryParse(value ?? "a");
                    if (result == null) {
                      return "Invalid Number";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    helperText: "Offset",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                width: 88,
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: endController,
                  validator: (value) {
                    var result = int.tryParse(value ?? "a");
                    if (result == null) {
                      return "Invalid Number";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    helperText: "End",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: imageLinkList.length == 0
                        ? null
                        : () {
                            offsetController.text = "1";
                            setState(() {
                              imageLinkList = [];
                            });
                          },
                    label: Text("Clear"),
                    icon: Icon(Icons.clear),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.grey[800],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          imageLinkList.add(ImageDownloadModel(
                            end: int.parse(endController.text),
                            link: linkController.text,
                            offset: int.parse(offsetController.text),
                            downloadCompleted: false,
                            dirName: directoryController.text,
                          ));
                        });
                      }
                    },
                    label: Text("Add to List"),
                    icon: Icon(Icons.playlist_add),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: imageLinkList.length == 0
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DownloadPage(imageList: imageLinkList),
                              ),
                            );
                          },
                    label: Text("Download"),
                    icon: Icon(Icons.download),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
