class MessageModel {
  String id;
  DateTime timeStamp = DateTime.now();
  String userName;
  String userID;
  String content;
  String photoUrl;

  MessageModel({
    required this.id,
    required this.userID,
    required this.userName,
    required this.content,
    required this.photoUrl,
    required this.timeStamp,
  });
}
