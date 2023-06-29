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
  Stream<UserModel> getUserData(String uid);
  Future<DocumentSnapshot> getUniversityData(String university);
  Stream<List<UserModel>> searchUserByName(String query);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<UserModel> getLatestUserProfileData(String uid);
  FutureEitherVoid followUser(UserModel user);
  FutureEitherVoid addToFollowing(UserModel user);
  Stream<bool> checkUsernameAvailabilityStream(String username);
}

class UserAPI implements IUserAPI {
  final FirebaseFirestore _firestore;
  UserAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

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
  Stream<UserModel> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  Future<DocumentSnapshot> getUniversityData(String university) {
    return _firestore.collection('universities').doc(university).get();
  }


  @override
  Stream<List<UserModel>> searchUserByName(String query) {
    return _firestore
        .collection('users')
        .where(
          'username',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var user in event.docs) {
        users.add(UserModel.fromMap(user.data()));
      }
      return users;
    });
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
  Stream<UserModel> getLatestUserProfileData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  Stream<bool> checkUsernameAvailabilityStream(String username) {
    Stream<QuerySnapshot> querySnapshotStream = FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .snapshots();

    return querySnapshotStream
        .map((querySnapshot) => querySnapshot.docs.isEmpty);
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
