import 'package:flutter/foundation.dart';

@immutable
class UserModel {
 final String email;
  final String username;
  final String fullName;
  final List<String> followers;
  final List<String> following;
  final String profilePic;
  final String bannerPic;
  final String uid;
  final String bio;
  final String university;
  final String verifiedAs;
 const  UserModel({
    required this.email,
    required this.username,
    required this.fullName,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,
    required this.university,
    required this.verifiedAs,
  });

  UserModel copyWith({
    String? email,
    String? username,
    String? fullName,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? uid,
    String? bio,
    String? university,
    String? verifiedAs,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      university: university ?? this.university,
      verifiedAs: verifiedAs ?? this.verifiedAs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'fullName': fullName,
      'followers': followers,
      'following': following,
      'profilePic': profilePic,
      'bannerPic': bannerPic,
      'uid': uid,
      'bio': bio,
      'university': university,
      'verifiedAs': verifiedAs,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      followers: List<String>.from(map['followers'] as List<String>),
      following: List<String>.from(map['following'] as List<String>),
      profilePic: map['profilePic'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      uid: map['uid'] ?? '',
      bio: map['bio'] ?? '',
      university: map['university'] ?? '',
      verifiedAs: map['verifiedAs'] ?? '',
    );
  }

 

  @override
  String toString() {
    return 'UserModel(email: $email, username: $username, fullName: $fullName, followers: $followers, following: $following, profilePic: $profilePic, bannerPic: $bannerPic, uid: $uid, bio: $bio, university: $university, verifiedAs: $verifiedAs)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.username == username &&
      other.fullName == fullName &&
      listEquals(other.followers, followers) &&
      listEquals(other.following, following) &&
      other.profilePic == profilePic &&
      other.bannerPic == bannerPic &&
      other.uid == uid &&
      other.bio == bio &&
      other.university == university &&
      other.verifiedAs == verifiedAs;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      username.hashCode ^
      fullName.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      profilePic.hashCode ^
      bannerPic.hashCode ^
      uid.hashCode ^
      bio.hashCode ^
      university.hashCode ^
      verifiedAs.hashCode;
  }
}
