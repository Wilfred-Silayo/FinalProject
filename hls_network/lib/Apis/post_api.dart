import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hls_network/models/post.dart';
import 'package:hls_network/utils/failure.dart';
import 'package:hls_network/utils/type_defs.dart';


final postAPIProvider = Provider((ref) {
  return PostAPI(
    firestore: FirebaseFirestore.instance,
  );
});

abstract class IPostAPI {
  FutureEither<DocumentSnapshot> sharePost(Post post);
  Future<List<DocumentSnapshot>> getPosts();
  Stream<QuerySnapshot> getLatestPost();
  FutureEither<DocumentSnapshot> likePost(Post post);
  Future<List<DocumentSnapshot>> getRepliesToPost(Post post);
  Future<DocumentSnapshot> getPostById(String id);
  Future<List<DocumentSnapshot>> getUserPosts(String uid);
  Future<List<DocumentSnapshot>> getPostsByHashtag(String hashtag);
}

class PostAPI implements IPostAPI {
  final FirebaseFirestore _firestore;
  
  PostAPI({required FirebaseFirestore firestore})
      : _firestore = firestore
;

@override
FutureEither<DocumentSnapshot> sharePost(Post post) async {
  try {
    final collectionReference = _firestore.collection('posts');
    final documentReference = await collectionReference.add(post.toMap());
    final documentSnapshot = await documentReference.get();
    return right(documentSnapshot);
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
  Future<List<DocumentSnapshot>> getPosts() async {
    final snapshots = await _firestore
        .collection('posts')
        .orderBy('postedAt', descending: true)
        .get();
    return snapshots.docs;
  }

  @override
  Stream<QuerySnapshot> getLatestPost() {
    return _firestore.collection('posts').snapshots();
  }

@override
FutureEither<DocumentSnapshot> likePost(Post post) async {
  try {
    final collectionReference = _firestore.collection('posts');
    await collectionReference.doc(post.id).update({'likes': post.likes});
    final updatedDocument = await collectionReference.doc(post.id).get();
    return right(updatedDocument);
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
  Future<List<DocumentSnapshot>> getRepliesToPost(Post post) async {
    final snapshots = await _firestore
        .collection('posts')
        .where('repliedTo', isEqualTo: post.id)
        .get();
    return snapshots.docs;
  }

  @override
  Future<DocumentSnapshot> getPostById(String id) async {
    return _firestore.collection('posts').doc(id).get();
  }

  @override
  Future<List<DocumentSnapshot>> getUserPosts(String uid) async {
    final snapshots = await _firestore
        .collection('posts')
        .where('uid', isEqualTo: uid).orderBy('postedAt', descending: true)
        .get();
    return snapshots.docs;
  }

  @override
  Future<List<DocumentSnapshot>> getPostsByHashtag(String hashtag) async {
    final snapshots = await _firestore
        .collection('posts')
        .where('hashtags', arrayContains: hashtag)
        .get();
    return snapshots.docs;
  }
}
