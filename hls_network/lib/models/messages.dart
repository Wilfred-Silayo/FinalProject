

class Message {
  final String senderId;
  final String receiverid;
  final String text;
  final DateTime timeSent;
  final String id;
  final bool isSeen;
  Message({
    required this.senderId,
    required this.receiverid,
    required this.text,
    required this.timeSent,
    required this.id,
    required this.isSeen,
  });

  Message copyWith({
    String? senderId,
    String? receiverid,
    String? text,
    DateTime? timeSent,
    String? id,
    bool? isSeen,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      receiverid: receiverid ?? this.receiverid,
      text: text ?? this.text,
      timeSent: timeSent ?? this.timeSent,
      id: id ?? this.id,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverid': receiverid,
      'text': text,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'id': id,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverid: map['receiverid'] as String,
      text: map['text'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      id: map['id'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }


  @override
  String toString() {
    return 'Message(senderId: $senderId, receiverid: $receiverid, text: $text, timeSent: $timeSent, id: $id, isSeen: $isSeen)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;
  
    return 
      other.senderId == senderId &&
      other.receiverid == receiverid &&
      other.text == text &&
      other.timeSent == timeSent &&
      other.id == id &&
      other.isSeen == isSeen;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
      receiverid.hashCode ^
      text.hashCode ^
      timeSent.hashCode ^
      id.hashCode ^
      isSeen.hashCode;
  }
}
