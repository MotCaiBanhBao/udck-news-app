class NotificationModel {
  String id;
  String content;
  String url;
  String publisher;
  String target;
  bool checked = false;
  DateTime timeStamp = DateTime.now();

  NotificationModel({
    required this.id,
    required this.content,
    required this.url,
    required this.publisher,
    required this.target,
  });
}
