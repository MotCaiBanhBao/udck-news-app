class Notification {
  String id;
  String content;
  String url;
  String publicsher;
  String target;
  bool checked = false;
  DateTime timeStamp = DateTime.now();

  Notification({
    required this.id,
    required this.content,
    required this.url,
    required this.publicsher,
    required this.target,
  });
}
