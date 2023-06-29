import 'package:flutter/foundation.dart';
import 'package:hls_network/utils/enums/post_type.dart';


@immutable
class Post {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final PostType postType;
  final DateTime postedAt;
  final List<String> likes;
  final String id;
  final String repliedTo;
  const Post({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.postType,
    required this.postedAt,
    required this.likes,
    required this.id,
    required this.repliedTo,
  });

  Post copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    PostType?  postType,
    DateTime? postedAt,
    List<String>? likes,
    String? id,
    String? repliedTo,
  }) {
    return Post(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      postType: postType ?? this.postType,
      postedAt: postedAt ?? this.postedAt,
      likes: likes ?? this.likes,
      id: id ?? this.id,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    result.addAll({'link': link});
    result.addAll({'imageLinks': imageLinks});
    result.addAll({'uid': uid});
    result.addAll({'id': id});
    result.addAll({'postType': postType.type});
    result.addAll({'postedAt': postedAt.millisecondsSinceEpoch});
    result.addAll({'likes': likes});
    result.addAll({'repliedTo': repliedTo});

    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      link: map['link'] ?? '',
      imageLinks: List<String>.from(map['imageLinks']),
      uid: map['uid'] ?? '',
      postType: (map['postType'] as String).toPostTypeEnum(),
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
      likes: List<String>.from(map['likes']),
      id: map['id'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Post(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, postType: $postType, postedAt: $postedAt, likes: $likes,id: $id, repliedTo: $repliedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.postType == postType &&
        other.postedAt == postedAt &&
        listEquals(other.likes, likes) &&
        other.id == id &&
        other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        postType.hashCode ^
        postedAt.hashCode ^
        likes.hashCode ^
        id.hashCode ^
        repliedTo.hashCode;
  }
}
