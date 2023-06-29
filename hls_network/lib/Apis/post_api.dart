import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hls_network/models/post.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/utils/failure.dart';
import 'package:hls_network/utils/type_defs.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(
    firestore: FirebaseFirestore.instance,
  );
});

abstract class IPostAPI {
  FutureEitherVoid sharePost(Post post);
  FutureEitherVoid deletePost(Post post);
  Stream<List<Post>> getPosts(UserModel currentUser);
  FutureEitherVoid likePost(Post post);
  Stream<List<Post>> getRepliesToPost(Post post);
  Stream<Post> getPostById(String id);
  Stream<List<Post>> getUserPosts(String uid);
  Stream<List<Post>> getPostsByHashtag(String hashtag);
}

class PostAPI implements IPostAPI {
  final FirebaseFirestore _firestore;

  PostAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  @override
  FutureEitherVoid sharePost(Post post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set(post.toMap());
      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid deletePost(Post post) async {
    try {
      await _firestore.collection('posts').doc(post.id).delete();
      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<List<Post>> getPosts(UserModel currentUser) {
    List<String> followingUserIds = currentUser.following;

    followingUserIds.add(currentUser.uid);

    return _firestore
        .collection('posts')
        .where('uid', whereIn: followingUserIds)
        .orderBy('postedAt', descending: true)
        .limit(50)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Post.fromMap(
                e.data(),
              ),
            )
            .toList());
  }

  @override
  FutureEitherVoid likePost(Post post) async {
    try {
      await _firestore
          .collection('posts')
          .doc(post.id)
          .update({'likes': post.likes});
      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<List<Post>> getRepliesToPost(Post post) {
    return _firestore
        .collection('posts')
        .where('repliedTo', isEqualTo: post.id)
        .limit(10)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<Post> getPostById(String id) {
    return _firestore
        .collection('posts')
        .doc(id)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  Stream<List<Post>> getUserPosts(String uid) {
    return _firestore
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<List<Post>> getPostsByHashtag(String hashtag) {
    return _firestore
        .collection('posts')
        .where('hashtags', arrayContains: hashtag)
        .limit(10)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}
