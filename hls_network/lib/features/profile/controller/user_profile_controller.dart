import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/Apis/post_api.dart';
import 'package:hls_network/Apis/storage_api.dart';
import 'package:hls_network/Apis/user_api.dart';
import 'package:hls_network/features/notifications/controller/notification_controller.dart';
import 'package:hls_network/models/post.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/utils/enums/notification_type.dart';
import 'package:hls_network/utils/utils.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserPosts(uid);
});


final getLatestUserProfileDataProvider =
    StreamProvider.family((ref, String uid) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData(uid);
});

final getUniversityProvider = FutureProvider.family((ref, String university) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getUniversityData(university);
});

final usernameAvailabilityProvider =
    StreamProvider.family<bool, String>((ref, username) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.checkUsernameAvailabilityStream(username);
});

class UserProfileController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  final NotificationController _notificationController;
  UserProfileController({
    required PostAPI postAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
    required NotificationController notificationController,
  })  : _postAPI = postAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        _notificationController = notificationController,
        super(false);

  Stream<List<Post>> getUserPosts(String uid) {
    return _postAPI.getUserPosts(uid);
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
    required UserModel currentUser,
  }) async {
    state = true;

    UserModel updatedUserModel =
        userModel.copyWith(); 


    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImage('banner', [bannerFile]);
      updatedUserModel = updatedUserModel.copyWith(bannerPic: bannerUrl[0]);
    }

    if (profileFile != null) {
      final profileUrl =
          await _storageAPI.uploadImage('profile', [profileFile]);
      updatedUserModel = updatedUserModel.copyWith(profilePic: profileUrl[0]);
    }

    if (updatedUserModel.following.contains(currentUser.uid)) {
      updatedUserModel.following.remove(currentUser.uid);
      updatedUserModel =
          updatedUserModel.copyWith(following: updatedUserModel.following);
    }

    final res = await _userAPI.updateUserData(updatedUserModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    UserModel updatedUser = user.copyWith();
    UserModel updatedCurrentUser = currentUser.copyWith();

    // Already following
    if (updatedCurrentUser.following.contains(user.uid)) {
      updatedUser.followers.remove(updatedCurrentUser.uid);
      updatedCurrentUser.following.remove(user.uid);
    }
     if (updatedCurrentUser.following.contains(updatedCurrentUser.uid)) {
      updatedCurrentUser.following.remove(updatedCurrentUser.uid);
    }
    
     else {
      updatedUser.followers.add(updatedCurrentUser.uid);
      updatedCurrentUser.following.add(user.uid);
    }

    updatedUser = updatedUser.copyWith(followers: updatedUser.followers);
    updatedCurrentUser =
        updatedCurrentUser.copyWith(following: updatedCurrentUser.following);

    final res = await _userAPI.followUser(updatedUser);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userAPI.addToFollowing(updatedCurrentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        _notificationController.createNotification(
          text: '${updatedCurrentUser.username} followed you!',
          postId: '',
          notificationType: NotificationType.follow,
          uid: updatedUser.uid,
        );
      });
    });
  }
}
