class ImageDownloadModel {
  late String link;
  String dirName;
  late int offset, end;
  bool downloadCompleted;

  ImageDownloadModel({
    required this.dirName,
    required this.end,
    required this.link,
    required this.offset,
    required this.downloadCompleted,
  });
}
