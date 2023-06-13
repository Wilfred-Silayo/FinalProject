import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/providers/firebase_providers.dart';
import 'package:hls_network/utils/failure.dart';
import 'package:hls_network/utils/type_defs.dart';


final userAPIProvider = Provider((ref) {
  return UserAPI(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<DocumentSnapshot> getUserData(String uid);
  Future<List<DocumentSnapshot>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<QuerySnapshot> getLatestUserProfileData();
  FutureEitherVoid followUser(UserModel user);
  FutureEitherVoid addToFollowing(UserModel user);
}

class UserAPI implements IUserAPI {
  final FirebaseFirestore _firestore;
  UserAPI({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<DocumentSnapshot> getUserData(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .get();
  }

  @override
  Future<List<DocumentSnapshot>> searchUserByName(String name) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('name', isEqualTo: name)
        .get();

    return querySnapshot.docs;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toMap());
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

 @override
Stream<QuerySnapshot> getLatestUserProfileData() {
  return _firestore
      .collection('users')
      .snapshots();
}


  @override
  FutureEitherVoid followUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'followers': user.followers});
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid addToFollowing(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'following': user.following});
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
