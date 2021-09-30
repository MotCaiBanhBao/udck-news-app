import '/business_logic/models/notification_model.dart';

extension NotificationX on NotificationModel {
  Map<String, dynamic> toJon() {
    return {
      'id': id,
      'content': content,
      "url": url,
      'publisher': publisher,
      'target': target,
      'checked': checked,
      'timeStamp': timeStamp,
    };
  }

  static NotificationModel fromJson(Map<String, dynamic> parsedJson) {
    return NotificationModel(
      content: parsedJson['content'],
      id: parsedJson['id'],
      publisher: parsedJson['publisher'],
      target: parsedJson['target'],
      url: parsedJson['url'],
    );
  }
}
