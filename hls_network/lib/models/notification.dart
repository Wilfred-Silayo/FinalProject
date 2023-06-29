import 'package:hls_network/utils/enums/notification_type.dart';

class Notification {
  final String text;
  final String postId;
  final DateTime createdAt;
  final String id;
  final String uid;
  final NotificationType notificationType;
  Notification({
    required this.text,
    required this.postId,
    required this.createdAt,
    required this.id,
    required this.uid,
    required this.notificationType,
  });

  Notification copyWith({
    String? text,
    String? postId,
    DateTime? createdAt,
    String? id,
    String? uid,
    NotificationType? notificationType,
  }) {
    return Notification(
      text: text ?? this.text,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'postId': postId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'id': id,
      'uid': uid,
      'notificationType': notificationType.type,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      text: map['text'] as String,
      postId: map['postId'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      id: map['id'] as String,
      uid: map['uid'] as String,
      notificationType: (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }

  @override
  String toString() {
    return 'Notification(text: $text, postId: $postId, createdAt: $createdAt, id: $id, uid: $uid, notificationType: $notificationType)';
  }

  @override
  bool operator ==(covariant Notification other) {
    if (identical(this, other)) return true;
  
    return 
      other.text == text &&
      other.postId == postId &&
      other.createdAt == createdAt &&
      other.id == id &&
      other.uid == uid &&
      other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      postId.hashCode ^
      createdAt.hashCode ^
      id.hashCode ^
      uid.hashCode ^
      notificationType.hashCode;
  }

}
